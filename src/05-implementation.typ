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

In the simplest case, the plain-text query only contains tag queries. In terms of SQL, the plain-text query only queries using the FTS5 extension without accessing any other columns. In this case, the resulting WHERE clause will only contain one expression - the FTS5 expression. Conversion from plain-text to FTS5 is relatively simple, except for an edge case:

```sql
-- The plain-text query:
-- "Item with tags a and b, or items without tag d"
a b | -d

-- The SQL WHERE clause
WHERE tag_query = '(a AND b) OR (meta_tags:all NOT d)'
```

The FTS5 extension treats `NOT` as a binary operator, not a unary operator. In other words, the `NOT` operator computes the set difference of two conditions. It is unable to search for the complement of a single condition. Often, it can be useful to search for the complement of a single tag, for example searching for all items that don't have the tag `old`. However, it is impossible to represent the following query in FTS5: _"items that don't have the tag 'old'"_.

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

==== Case 3: FTS5 and SQL queries with OR operands

```sql
-- The plain-text query:
-- "Either i) item in the folder 'my_folder' with tags a and b, or
--         ii) item in the folder 'other_folder' without the tag d
a b in:my_folder | -d in:other_folder

-- Incorrect SQL clause
-- This will not behave as expected
WHERE (
  (tag_query = 'a AND b'
    AND i.path LIKE 'my\_folder%' ESCAPE '\')
  OR
  (tag_query = 'meta_tags:all NOT d'
    AND i.path LIKE 'other\_folder%' ESCAPE '\')
)

-- The working SQL WHERE clause
WHERE (
  (i.id IN (SELECT id FROM tag_query('a AND b'))
    AND i.path LIKE 'my\_folder%' ESCAPE '\')
  OR
  (i.id IN (SELECT id FROM tag_query('meta_tags:all NOT d'))
    AND i.path LIKE 'other\_folder%' ESCAPE '\')
)
```

When the plain-text query contains FTS5 terms and SQL terms joined together with at least one OR operator, the resulting SQL statement must make use of subqueries.

This is due to two limitations of SQLite's FTS5 extension. First, it only supports at most one FTS5 expression in the WHERE clause. Attempting to query using multiple FTS expressions will result in zero rows being returned. Second, it does not handle OR groups that contain a FTS5 expression correctly. A query such as _"a b | in:my\_folder"_ will have rows missing from the output.

To overcome this, I replace all FTS expressions with a subquery that contains the required FTS expression. In effect, this make the statement behave as expected.

=== Compiler Implementation <query-implementation>

// To implement a compiler in Rust
//
// There are many Rust crates (libraries) available for implementing compilers. In the application, I used #link("https://github.com/rust-bakery/nom")[the nom crate] to implement the compiler. The compiler comprises of two parts:

The compiler is implemented using two files, `parser.rs` and `convert.rs`.

#figure(
    image("res/compiler-flow.png"),
    caption: [Diagram showing the process of converting a plain-text query to a SQL statement],
)

The parser is implemented in `parser.rs` using the "nom" crate @couprie_2021_nom. Its purpose is to validate and parse a plain-text query into a parse tree.

The purpose of `convert.rs` is to convert the parse tree into an abstract syntax tree (AST) @thain2019introduction. In this stage, it combines any FTS terms on the same level into a single `FTS()` object that represents a single FTS expression in the output SQL statement.

The conversion from the AST to SQL code is also handled by `convert.rs`. This is done by calling the `to_sql_clause(&self) -> String` method on the base of the tree, which then recursively calls `to_sql_subclause(&self, is_root: bool) -> String` on its child nodes.

Finally, the compiler inserts the SQL clause into the SQL template to obtain the final SQL statement. The statement can then be used to query items in the database.

The final number of lines of code in the compiler module was 1149 lines.

== Testing

Testing of the application involved implementing unit tests for each application module, as well as integration tests for testing how the different modules integrate together.

At the moment, 104 unit and integration tests have been implemented. The test output is included in the appendix.

Unit tests for each module etc

Implemented.

== Extension 1 - Directory watcher <watcher-introduction>

// TODO: any challenges encountered while implementing this?
// TODO: give an example of it detecting a rename

The ability to track file movement is essential to this application. When implemented, it allows the application to preserve tags on a file when the user moves a file to a new location. However, implementing this on the Windows operating system presents a major challenge.

=== Detecting File Movement on Windows

Windows provides a native API to watch a directory for changes. However, one major issue with this API is that it is unable to detect file movement. The API can emit events for file creation, removal, and in-place renames. However, file movement from one directory to another is simply detected as a pair of file-create and file-remove events.

This prevents it from being able to be used directly as the watcher for the application. When used as the watcher for the application, the application is unable to preserve tags on a file when the user moves a file to a different folder. This is a major issue for many existing tag-based file managers as well - they often lack the ability to track file movement, have unorthodox solutions that affect user usability, or make it the user's responsibility to manually update tags after file movement.

To solve this issue, I implemented an asynchronous event handler that takes Windows' native events as input, and automatically resolves file movement by checking the file paths of the received events.

=== Structure

#figure(
    image("res/watcher-flow.png", width: 50%),
    caption: [Diagram showing the flow of a Windows event from the watcher to the output],
)

The final watcher makes heavy use of concurrent programming. The basic structure of the watcher is as follows:

- An instance of `ReadDirectoryChangesWatcher` from the `notify` crate, spawning native operating system events and sending them in a separate async task.
- An event handler that takes native OS events and processes them, finally sending them to the output receiver.

=== Event Handler Algorithm

The event handler receives new events in an infinite loop. It performs a different action depending on the type of event received.

When a delete event is received, it may correspond to either a file movement or a file deletion. The algorithm stores this event in a list, and adds to the event an expiry date. If the path is determined to be a rename event before the expiry time, then the algorithm sends a rename event. Otherwise, the path expires and is treated as a delete event, which the algorithm sends to the output.

When a create event is received, it may correspond to either a file movement or a file creation. The algorithm goes through the list of recently-deleted paths and checks if any path has the same file name as this create event. If a matching file name is found, it marks the path as a rename event, then sends a rename event to the output. Otherwise, the algorithm returns the create event as-is.

If the list of recently-deleted paths is empty, the infinite loop blocks indefinitely while waiting for a new event from the `notify` watcher. If the list is not empty, the infinite loop will wait for the new event but timeout on the next earliest expiry time in the list. If a timeout occurs, it removes the associated path from the list and restarts the loop.

The full code for the event handler is included as an appendix at @code-dir-watcher.

== Extension 2 - Searching based on file path

Allow searching for files using their path, so users can use the application just like any typical file manager.

Not yet implemented.

== Extension X - Audio sample categorisation

Use deep learning to categorise audio files, then automatically tag them.

Not yet implemented.

== Extension X - Query simplification

Simplify plain text query before converting to sql. Should use Disjunctive normal form: https://en.wikipedia.org/wiki/Disjunctive_normal_form

Not yet implemented.

// == Use Cases
//
// == Extension 1 - TODO
//
// == Extension 2 - TODO
//
// = Testing
//
// = Evaluation
//
// = Conclusion
//
// = Literature review
//
// = Background
//
// = Your other achievements to date

#pagebreak()
