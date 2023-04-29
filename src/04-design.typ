= Design

== Components

#figure(
    image("res/components.png", width: 80%),
    caption: [Components of the application],
)

The application is made up of several components. The Rust backend is responsible for file operations, database access and cross-platform compatibility. The Vue frontend is responsible for the graphical user interface. The SQLite database stores tags assigned to files by users. These components are explained in more detail below.

=== Rust Backend

The Rust backend is responsible for file operations, database access and cross-platform compatibility. The backend is implemented using the Rust programming language and the Tauri framework. It is divided into many modules for code organisation.

The query module is responsible for parsing user queries and converting them into SQL queries. This is further discussed in @query-introduction.

The repository module is responsible for interacting with the SQLite database. It contains the repository model definition, as well as functions for managing connections and high-level abstractions for managing database contents.

The scan and diff modules are responsible for listing files in filesystem. Since the application may be opened and closed frequently, it needs to be able to keep track of the files in the file system after the application has been closed. The application achieves this through a syncing operation on application startup, it scans the folder for files using the scan module and determines which files are created, deleted, or removed since the previous session using the diff module.

The watch module is responsible for real-time tracking of files in a folder. The module is used to track changes to a folder while the application is open, allowing the user to modify files freely while the application is open and keep any tags on files intact. This is further discussed on @watcher-introduction.

=== Vue Frontend

The Vue frontend is responsible for the graphical user interface. It is implemented using the Vue JavaScript framework, TailwindCSS for styling, and Vite for building and optimising the frontend.

The frontend is created using the build tool Vite, it operates on a single HTML file and recursively checks any linked stylesheets and JavaScript files. This includes the Vue frontend framework and the TailwindCSS library.

The frontend uses TailwindCSS for consistent styling across all HTML renderers on different platforms. TailwindCSS is built on the modern-normalize framework, which aims to normalise styles across various browsers on different operating systems @cornes_2020_preflight. This allows the application to retain the same appearance across different operating systems.

=== SQLite Database

The SQLite database stores tags assigned to files by users. The database is implemented using the SQLite 3 library and its full-text search extension. The SQL schema is included as an appendix at @code-database-schema.

The "items" table contains several columns - an autoincrementing ID, the path of the file, a list of tags, and a list of metadata tags for query generation. The path column is used to store the relative path of the file to the root of the repository. The tag name column is used to store a list of tags assigned to the file. The metadata tags are used for the query module to construct accurate SQL statements, this is further discussed in @query-introduction.

The "items_fts" table is a virtual table using SQLite's FTS5 full-text search extension. It allows quick indexing and querying of any text-based columns. The virtual table indexes and searches the tag column on the "items" table.

The database is accessed from Rust using the `rusqlite` crate. It provides functions for opening and closing a database connection, executing SQL queries, as well as registering custom functions provided by my own code.

=== User Interface Design

#figure(
    image("res/frontend.png", width: 70%),
    caption: [Current user interface, 15 April 2023.],
)

The user interface is designed to be simple and easy-to-use. It consists of a toolbar, a search bar, the main content area, and a properties panel. The toolbar contains common actions and options for the application. The search bar allows the user to input arbitrary queries. The main content area contains a list of files and information about each file. The properties panel displays tags assigned to the selected files and allows the user to assign new tags to them.

The application is designed to be used with a mouse and keyboard. The toolbar buttons and main content list can be navigated using the mouse. Keyboard shortcuts are provided for convenience, such as pressing Enter on the query bar to switch focus to the file list, pressing arrow keys in the file list to navigate to the next / previous item.

The sidebar is used for tagging files selected in the main content area. Users can edit the list of tags for the selected file. If multiple files are selected, the sidebar shows common tags between all selected files, any new tags will be added to all selected files.

The user interface is designed to be consistent across all platforms. The application should look and feel the same on Windows, macOS and Linux systems.

== Searching for Items <sec-searching-for-items>

The application is designed to be a file manager. It should allow users to search for files using tags, but at the same time should not disregard the actual file structure of the underlying file tree. Therefore, users should be able to search for files not only using tags, but also using file attributes such as the file path.

The application uses SQLite's FTS5 full-text search extension to facilitate searching files by tag. When combined with other SQL conditions, the following is one example of such query:

```sql
SELECT i.id, i.path, i.tags, i.meta_tags
FROM items i
INNER JOIN
    tag_query tq ON tq.id = i.id
WHERE
    tag_query = '(a NOT b)'
    AND i.path LIKE 'samples/%';
```

The query searches for items that are under the path `samples/` and have the tag `"a"` but don't have the tag `"b"`.

To keep the software accessible and usable to as many users as possible, the software should not expect users to enter SQL queries directly since most computer users do not have experience in SQL. For more complex queries, the resulting SQL statement would become difficult to write and to understand.

As such, the application provides a plain-text query language that gets converted into SQL behind the scenes. The above query may be expressed in this new query language as follows:

```
a -b in:samples/
```

Terms such as `a` and `b` are treated as tag names, while terms with the prefix `in:` are file path queries. Terms that do not have any operators between them are implicitly joined with an `AND` group. Additional operators such as `|` and `-` allow grouping terms using boolean `OR` and `NOT` queries.

The application should convert the above plain-text query into the same SQL statement above when executing the query.

#pagebreak()
