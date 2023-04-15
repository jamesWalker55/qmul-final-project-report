= Design

This section discusses the components that make up the application and how they interact with each other. I will firstly go over each of the main software components, and then give an overview of how these components interact with each other. Following this, I will talk about my decision to use SQLite for storing tags, as well as discuss the user interface design.

== Components

The following components make up the application:

- Rust backend for file operations, database access and cross-platform compatibility
- Vue frontend for the graphical user interface
- SQLite database for storing files and tags

The Rust backend is responsible for file operations, database access and cross-platform compatibility. The Vue frontend is responsible for the graphical user interface. The SQLite database stores tags assigned to files by users. These components are explained in more detail below.

=== Rust Backend

The Rust backend is responsible for file operations, database access and cross-platform compatibility. The backend is implemented using the Rust programming language and the Tauri framework. It is divided into many modules for code organisation.

The query module is responsible for parsing user queries and converting them into SQL queries. It contains two further submodules for the lexing and conversion to SQL respectively. This is further discussed in @query-introduction.

The repository module is responsible for interacting with the SQLite database. It contains functions for opening a database connection, executing SQL queries, and closing a database connection. It also provides high-level abstractions over the connection to provide functions for registering file paths, as well as adding or removing tags from file paths.

The scan and diff modules are responsible for listing files in filesystem. Since the application may be opened and closed frequently, it needs to be able to keep track of the files in the file system after the application has been closed. The application achieves this is through a syncing operation when the user starts a new session with the application. The application scans the folder for files using the scan module, and determines which files are created, deleted, or removed since the previous session using the diff module.

The watch module is responsible for real-time tracking of files in a folder. This is part of an extension to the application. The module is used to track changes to a folder while the application is open, allowing the user to modify files freely while the application is open and keep any tags on files intact. This is further discussed on @watcher-introduction.

=== Vue Frontend

The Vue frontend is responsible for the graphical user interface. It is implemented using the Vue JavaScript framework, TailwindCSS for styling, and Vite for building and optimising the frontend.

The frontend is created using the build tool Vite, it operates on a single HTML file and recursively checks any linked stylesheets and JavaScript files. This includes the Vue frontend framework and the TailwindCSS library.

The interface contains elements for displaying the application's toolbar, search, main content area and side panels. These elements are populated with data from the Rust backend using Tauri's command and event systems.

The toolbar contains buttons for opening repositories, which are directories with a centralised database that tracks tags with files. The toolbar also contain additional features in the application, such as a folder filter panel and an audio preview extension. The main content area contains a list of items, as well as basic information about each file such as the file path and its tags.

The frontend uses TailwindCSS for consistent styling across all HTML renderers on different platforms. TailwindCSS is built on the modern-normalize framework, which aims to normalise styles across various browsers on different operating systems @cornes_2020_preflight. This allows the application to retain the same appearance across different operating systems.

=== SQLite Database

The SQLite database stores tags assigned to files by users. The database is implemented using the SQLite 3 library and its full-text search extension. The SQL schema is included as an appendix at @code-database-schema.

The "items" table contains several columns - an autoincrementing ID, the path of the file, a list of tags, and an additional list of metadata tags for the application's internal usage. The path column is used to store the relative path of the file to the root of the repository. The tag name column is used to store a list of tags assigned to the file. The metadata tags are used for the query module to construct accurate SQL statements, this is further discussed in @query-introduction.

The "items_fts" table is a virtual table using SQLite's FTS5 full-text search extension. It allows quick indexing and querying of any text-based columns. In this case, the virtual table is used to index and search the tag name column on the "items" table.

The database is accessed by the Rust backend using the `rusqlite` Rust crate. Functions are provided for opening and closing a database connection, executing SQL queries, as well as registering custom functions provided by my own code.

=== User Interface Design

#figure(
    image("res/frontend.png", width: 70%),
    caption: [Current user interface, 15 April 2023.],
)

The user interface is designed to be simple and easy-to-use. It consists of a toolbar, a search bar, the main content area, and a properties panel. The toolbar contains buttons for opening repositories, and toggling options and extensions for the application. The search bar allows the user to input arbitrary queries. The main content area contains a list of files and directories, as well as information about each file. The properties panel displays the list of tags assigned to the selected files, and allows the user to assign new tags to them.

The application is designed to be used with a mouse and keyboard. The toolbar buttons and main content list can be clicked using the mouse. Files and directories can also be opened by double-clicking them with the mouse. An additional context menu is available by right-clicking on items in the list. Keyboard shortcuts are provided for convenience, such as pressing Enter on the query bar to switch focus to the file list, pressing arrow keys in the file list to navigate to the next / previous item.

When tagging files, the user uses a sidebar that displays information about the selected file in the main content area. In the sidebar, users can edit the list of tags for the selected file. If the user has selected multiple files, the sidebar will show common tags between all selected files, and any new tags will be added to all selected files.

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
