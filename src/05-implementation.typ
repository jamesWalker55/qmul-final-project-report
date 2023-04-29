= Implementation

== Parsing Plain Text Queries <query-introduction>

To support the plain-text query language described in @sec-searching-for-items, the application needs to implement a compiler that translates from the plain-text query language to SQL.

This is one of the major challenges when implementing the software. In order to support arbitrarily-complicated queries, the compiler must be able to handle any combination of search operators and many edge cases.

Since the application fetches data from the same tables for every query, the `SELECT` and `JOIN` clauses of the SQL statement stay constant - I only need to consider the `WHERE` clause of the SQL statement when converting from a plain-text query. The following is the SQL template used in the compiler:

```sql
SELECT i.id, i.path, i.tags, i.meta_tags
FROM items i
INNER JOIN
    tag_query tq ON tq.id = i.id
WHERE
    :converted_plain_text_query
```

When given a plain-text query, the application converts it into a SQL `WHERE` clause, then inserts it into the template. However, due to differences between the plain-text and SQL languages, there is no straight-forward way to convert plain-text queries to SQL `WHERE` clauses. I will explain those differences by examining a few cases.

=== Query Edge Cases

==== Case 1: FTS5-only queries <query-edge-case-1>

```sql
-- The plain-text query:
-- "Item with tags a and b, or items with tag c without tag d"
a b | c -d

-- The SQL WHERE clause
WHERE tag_query = '(a AND b) OR (c NOT d)'
```

In the simplest case, the plain-text query only contains tag queries.

Terms prefixed with a minus symbol (`-`) are "NOT" clauses and have the highest precedence; terms next to each other without operators are "AND" clauses; terms separated with a bar (`|`) are "OR" clauses and have the lowest precedence.

In terms of SQL, the plain-text query only queries using the FTS5 extension without accessing any other columns. In this case, the resulting WHERE clause will only contain one expression - the FTS5 expression. Conversion from plain-text to FTS5 is relatively simple, except for an edge case:

```sql
-- The plain-text query:
-- "Item with tags a and b, or items without tag d"
a b | -d

-- The SQL WHERE clause
WHERE tag_query = '(a AND b) OR (meta_tags:all NOT d)'
```

The FTS5 extension treats `NOT` as a binary operator, not a unary operator. In other words, the `NOT` operator computes the set difference of two conditions. It cannot search for the complement of a single condition. Often, it can be useful to search for the complement of a single tag, for example searching for all items that don't have the tag `old`. However, it is impossible to represent complements in FTS5.

To circumvent this issue, I added a new column to the `items(id, path, tags)` table called `meta_tags`. The `meta_tags` column contains the string `"all"` by default, so all items in the table will gain a new `all` tag. I can then specify `meta_tags:all` in the FTS5 query to search for _"all items that have the tag 'all' in the 'meta_tags' column"_. I finally use `meta_tags:all` as the first operand in the `NOT` operator to compute the set difference between all items and the given query, effectively implementing unary negation of a single term.

==== Case 2: FTS5 and SQL queries without OR operands

```sql
-- The plain-text query:
-- "Item in the folder 'my_folder' with tags a and b"
a b in:my_folder

-- The SQL WHERE clause
WHERE tag_query = 'a AND b' AND i.path LIKE 'my\_folder%' ESCAPE '\'
```

For clarity, "FTS terms/expressions" will refer to tag searches like "a b", while "SQL terms/expressions" will refer to non-tag searches like "in:my_folder".

In this case, the WHERE clause requires multiple expressions in addition to the FTS expression. For each SQL term in the query, the WHERE clause must include a separate SQL expression for the term. All the rules and edge cases from @query-edge-case-1 apply here. This case is similar to case 1 and is simple to handle.

==== Case 3: FTS5 and SQL queries with OR operands <query-edge-case-3>

```sql
-- The plain-text query:
-- "Either i) item in the folder 'my_folder' with tags a and b, or
--         ii) item in the folder 'other_folder' without the tag d
a b in:my_folder | -d in:other_folder

-- Incorrect SQL clause
-- This will not behave as expected
WHERE (
  (tag_query = 'a AND b'
    AND i.path LIKE 'my\_folder%' ESCAPE '\\')
  OR
  (tag_query = 'meta_tags:all NOT d'
    AND i.path LIKE 'other\_folder%' ESCAPE '\\')
)

-- The working SQL WHERE clause
WHERE (
  (i.id IN (SELECT id FROM tag_query('a AND b'))
    AND i.path LIKE 'my\_folder%' ESCAPE '\\')
  OR
  (i.id IN (SELECT id FROM tag_query('meta_tags:all NOT d'))
    AND i.path LIKE 'other\_folder%' ESCAPE '\\')
)
```

When the plain-text query contains FTS5 terms and SQL terms joined together with at least one OR operator, the resulting SQL statement must make use of subqueries.

This is due to two limitations of SQLite's FTS5 extension. First, it only supports at most one FTS5 expression in the WHERE clause. Attempting to query using multiple FTS expressions will result in zero rows being returned. Second, it does not handle OR groups that contain a FTS5 expression correctly. A query such as _"a b | in:my\_folder"_ will have rows missing from the output.

To overcome this, I replace all FTS expressions with a subquery that contains the required FTS expression. In effect, this make the statement behave as expected.

=== Compiler Implementation <query-implementation>

The compiler is implemented using two files, `parser.rs` and `convert.rs`.

#figure(
  image("res/compiler-flow.png"),
  caption: [Diagram showing the process of converting a plain-text query to a SQL statement],
)

The parser is implemented in `parser.rs` using the "nom" crate @couprie_2021_nom. Its purpose is to validate and parse a plain-text query into a parse tree.

The purpose of `convert.rs` is to convert the parse tree into an abstract syntax tree (AST) @thain2019introduction. In this stage, it combines any FTS terms on the same level into a single `FTS()` object that represents a single FTS expression in the output SQL statement.

The conversion from the AST to SQL code is also handled by `convert.rs`. This is done by calling the `to_sql_clause(&self)` method on the base of the tree, which then recursively calls `to_sql_subclause(&self, is_root: bool)` on its child nodes.

Finally, the compiler inserts the SQL clause into the SQL template to obtain the final SQL statement. The statement can then be used to query items in the database.

The final number of lines of code in the compiler module was 1149 lines.

== File Paths and Operating Systems

One of the requirements of the software is cross-platform compatibility: the software should run on all major operating systems, and the produced database must be transferable between operating systems. However, in terms of file path handling, Windows and Unix-like operating systems (including macOS and Linux) have drastic differences.

The first major difference is path separators. Windows defaults to backslashes (`\`) to separate components in a path, but also recognises forward slashes (`/`) as valid path separators in command contexts. Unix systems use forward slashes to separate path components, whereas backslashes, while heavily discouraged, are allowed as normal characters in filenames.

The second major difference is partitions. A Windows system partitions disk space into partition, each of which has a unique drive letter such as `C:\` and `D:\`. Windows absolute file paths will always contain drive letters, for example "`D:\Audio Samples`". Unix systems do not use partitions, on such systems file paths always begin with a forward slash, for example `/home/james/audio`.

These differences present several issues when storing paths in the database. If the application directly stored the absolute paths of files in the database, this would mean storing either Windows-specific paths or Unix-specific paths in the database. The database would become operating system-specific and is no longer cross-platform.

The issue of path separators is easy to solve - we only use forward slashes as separators since that is recognised as a valid separator on all operating systems. On Unix, this requires no changes to the paths and thus has no effect. On Windows, this can be implemented with a simple string substitution.

The issue of drive letters is more difficult to handle. If we wish to store absolute paths in the database, there is no way to create absolute paths that are valid on both Windows and Unix systems, since Windows drive letters are invalid on Unix systems.

Thus, the software must be limited to relative paths for cross-platform compatibility. This means the software must choose a location as the root directory, and store paths relative to the root directory. In the software, this is abstracted with the concept of "repositories", which is a folder where tags are managed and stored. This ensures that all paths can be stored as relative paths relative to the root of the folder. If the software doesn't track files outside the folder, this also has the added benefit of lower performance overhead as the software does not need to keep track of files in the entire system, including system files that the user may not want to tag. This also allows the user to create several isolated folders of tags, each folder dedicated for a different purpose and containing different tags.

== Optimising the Item List <optimise-item-list>

One of the requirements for this project is for the software to remain responsive when handling large file collections. The main item list of the user interface is a major component of the software that the user will interact with frequently, thus it is important to ensure that the item list is sufficiently responsive.

A naive implementation of the item list may be as follows: When the user enters a new search query, the frontend sends the query to the Rust backend. The backend queries the database for a list of items, then returns a list of each item and any associated information such as item paths to the frontend. Upon receiving the list, the item list renders every item in the received list using data that is stored in the list.

The above implementation works well for small file collections, but does not scale with larger collections.

As the length of the list increases, the data needed to be transferred from the backend to the frontend increases very quickly, and requires a longer time to complete. This causes a momentary freeze in the user interface lasting 1 to 5 seconds or more depending on the size of the list.

After the transfer, the item list then renders every item in the list. In a DOM-based (Document Object Model) user interface library like Vue, this means creating DOM nodes for every item in the list. This can quickly become expensive, especially for larger lists. This is reflected in the user interface as stuttering when the user scrolls the list.

The software implements two optimisations to address these issues.

=== Virtual Item List

The first optimisation is a virtual item list. A virtual list is a technique for rendering only the items visible on-screen in a scrollable list, while skipping the rendering of all other items to improve performance.

In Vue, a virtual item list massively reduces the number of DOM nodes generated for a given item list. Since the number of items visible depends on the size of the application window, the number of rendered items remain constant as the length of the item list increases. This way, the item list only generates a fixed number of elements, and the user can still interact with all items as if they were all present on the page.

The full code for the item list is included as an appendix at @code-virtual-list.

In my implementation of the virtual list, I added a buffer zone to pre-render items that are slightly off-screen. The reason for this buffer zone will be explained in the next section.

#figure(
    image("res/virtual-list.png", width: 60%),
    caption: [Diagram showing the different regions involved in a virtualised list.],
)

=== Limiting the Data Transferred

To reduce the amount of data transferred from the backend to the frontend during the initial load, we observe that not all of the data is useful when the list first loads. In a large list of items, only the paths and tags of the first few items will be visible, whereas the path and tags of all other items are not visible until scrolled to. Thus it is unnecessary to transfer the paths and tags of all items for the initial load, the only necessary information is the item ID, which uniquely identifies the item in the database.

In the software implementation, the virtual list initially only has access to a list of item IDs. If it wishes to get more information about an item to render it, it must make another request to the backend to fetch the item data. The fetching of items is not instantaneous and takes about 5-10ms for each item.

A further optimisation is to cache the data obtained from the backend. I implemented an item data cache that stores any retrieved items until the next query. When the virtual list attempts to fetch data from the backend, it now checks the item cache for existing data before attempting the fetch.

One downside of this approach is that the rendering of items is no longer instantaneous, since it needs to wait for the backend to respond with the relevant data before being able to render the item. To address this, the virtual list includes a buffer zone to pre-render items that are slightly off-screen. This ensures that items have enough time to render before being scrolled into view.

== Extension: Directory watcher <watcher-introduction>

The ability to track file movement is essential to this application. When implemented, it allows the application to preserve tags on a file when the user moves a file to a new location. However, implementing this on the Windows operating system presents a major challenge.

=== Detecting File Movement on Windows

Windows provides a native API to watch a directory for changes. However, one major issue with this API is that it is unable to detect file movement. The API can emit events for file creation, removal, and in-place renames. However, file movement from one directory to another is simply detected as a pair of file-create and file-delete events.

This prevents it from being able to be used directly as the watcher for the application. When used as the watcher for the application, the application is unable to preserve tags on a file when the user moves a file to a different folder. This is a major issue for many existing tag-based file managers as well - they often lack the ability to track file movement, have unorthodox solutions that affect user usability, or make it the user's responsibility to manually update tags after file movement.

To solve this issue, I implemented an asynchronous event handler that takes Windows' native events as input, and automatically resolves file movement by checking the file paths of the received events.

This watcher is only used on Windows systems. On other systems, their respective default watchers are used instead with conditional compilation.

=== Final Implementation

#figure(
  block(align(left)[
    ```plain
    Watcher
      |
      v
    Handler
      |
      v
    Output
    ```
  ]),
  caption: [Diagram showing the final iteration of the watcher],
)

I observe that moved files retain the same file name, even if they are moved to a different directory. The solution I implemented makes the following assumption: A delete event, followed shortly by a create event with the same file name is caused by a file rename event.

The final implementation used two components: the watcher, and the handler.

The watcher is an instance of a `Watcher` from the `notify` file watching library. It watches a directory and emits events generated by the underlying operating system (on Windows, the events come from the Windows API). In Windows, file movement is treated as a pair of create and delete events.

The handler is an asynchronous infinite loop, iterating through all events received from the watcher. It is responsible for determining whether a received event can be used as-is, or whether the event must undergo further processing and be deferred. The following sections describe the algorithm used to process events.

==== Handler Algorithm

In Windows' file system, all events except create and delete events can be used as-is, these events will be sent directly to the output. Create and delete events may correspond to a single rename event, as such they are handled differently from other events.

When a delete event is received, it may correspond to either a file movement or a file deletion. The algorithm stores this event in a list, and adds to the event an expiry date. The reason behind the expiry date will be explained in the next section. If the path is determined to be a rename event before the expiry time, then the algorithm sends a rename event. Otherwise, the path expires and is treated as a delete event, which the algorithm sends to the output.

When a create event is received, it may correspond to either a file movement or a file creation. The algorithm goes through the list of recently-deleted paths and checks if any path has the same file name as this create event. If a matching file name is found, it marks the path as a rename event, then sends a rename event to the output. Otherwise, the algorithm returns the create event as-is.

If the list of recently-deleted paths is empty, the infinite loop blocks indefinitely while waiting for a new event from the watcher. If the list is not empty, the infinite loop will wait for the new event but timeout on the next earliest expiry time in the list. If a timeout occurs, it removes the associated path from the list and waits for the next loop cycle.

==== Implementation

When the handler receives an event, the handler must determine whether the event belongs to a pair of create-delete events. The issue is that the pairing event may appear in a later loop, or it might have already arrived in an earlier loop. As such, the handler stores any received delete events in a list which is initialised on the first loop and persistent across future loops. The handler will search this list for a matching pair on every received create event.

However, we do not want to store these events in the list indefinitely - if the handler receives a remove event for `foo.txt`, then a create event for `foo.txt` 10 hours later, these events should not be paired together as a single rename event. The handler thus adds a timeout to each delete event added to the list. The timeout is an arbitrary short time window, the implementation uses a time window of 10ms. In every loop, the handler will now either wait for a new event from the handler, or wait for the timeout of any path in the list, whichever occurs first. If a timeout occurs, the handler removes the path from the list and waits for the next loop cycle.

In the actual implementation, the timeout of the handler must be handled asynchronously to prevent blocking of the current thread, otherwise new events from the watcher cannot be processed as the handler waits for a matching pair. The implementation overcomes this by starting the watcher and handler in separate threads.

The full code for the event handler is included as an appendix at @code-dir-watcher.

=== Previous Implementation

The solution had gone through several iterations before reaching the current implementation. I will briefly cover one of the previous iterations.

#figure(
  block(align(left)[
    ```plain
    Watcher
      |
      v
    Handler -> Manager
      |   ^      |
      |   +------+
      v
    Output
    ```
  ]),
  caption: [Diagram showing a previous iteration of the watcher],
)

Compared the the final iteration, this iteration is more complex. The assumption used in this iteration differs from that in the final iteration: A pair of create and delete events within a short time window with the same file name is caused by a file rename event. The assumption does not specify the order of create and delete events, meaning a create followed by a delete event is treated the same as a delete followed by a create event.

The handler in this iteration differs from the final solution in that it only checks if an event can be used as-is, otherwise it sends the event to the manager. The handler is not responsible for pairing create and delete events, but rather the manager.

The manager is an asynchronous infinite loop like the handler, it loops through create and delete events received from the handler. The key difference from the final solution is that this solution adds an expiry time to both delete events and create events. The reason is that this solution assumes that the create and delete events corresponding to a single rename event can be in any order, either create-delete or delete-create. It searches for a pair of matching events upon receipt of either create or delete events.

An error was discovered in the assumption when I was implementing unit tests for the module.

In one of the unit tests, the test first creates several files called `apple.txt` in several subfolders, then removes a random `apple.txt` file. This should not be considered as a rename event. However, the file watcher observes that the deleted `apple.txt` file has the same name as the previously-created `apple.txt` files, and considers the delete event as a rename event.

The assumption fails to consider that in a rename event, a delete event must precede a create event. This means the create / delete events corresponding to a rename event must be ordered. The assumption was corrected and this led to the final iteration described previously.

The code for this iteration is included in the appendix at @code-deprecated-watcher.

== Software Manual <manual-website>

As part of the evaluation for the project, I have created a public website containing documentation for the software @wong_2023_introduction. The website is hosted on GitHub Pages and contains information such as the software download link, version changelogs, documentation about basic usage, and documentation about the custom query language used by the software.

#figure(
  image("res/documentation.png", width: 70%),
  caption: [Screenshot of the documentation website, 17 May 2023],
)

One of the requirements of the project was that the software should remain accessible to new users. The manual helps with this requirement by providing explanations of related concepts and software features, allowing new users to gain a better understanding of the software and its uses.

#pagebreak()
