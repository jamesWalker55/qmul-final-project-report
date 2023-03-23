= Design

This section discusses the components that make up the application and how they interact with each other. I will firstly go over each of the main software components, and then give an overview of how these components interact with each other. Following this, I will talk about my decision to use SQLite for storing tags, as well as discuss the user interface design.

== Components

The following components make up the application:

- Rust backend for file operations, database access and cross-platform compatibility
- Vue frontend for the graphical user interface
- SQLite database for storing files and tags

The Rust backend is responsible for file operations, database access and cross-platform compatibility. The Vue frontend is responsible for the graphical user interface. The SQLite database stores tags assigned to files by users. These components are explained in more detail below.

=== Rust Backend

The Rust backend is responsible for file operations, database access and cross-platform compatibility. The backend is implemented using the Rust programming language and the Tauri framework.

The file operations module is responsible for listing and reading files in filesystem. Since the application writes to a database and not to files directly, this module is mainly focused on read operations.

The database access module is responsible for interacting with the SQLite database. It contains functions for opening a database connection, executing SQL queries, and closing a database connection. This module also implements helper functions for inserting tags into the database and retrieving tags from the database.

The cross-platform compatibility module is responsible for providing platform-specific functionality. This includes functions for opening an operating system specific file explorer, getting the path of common directories such as the home directory, and checking if a path is valid on the current platform.

=== Vue Frontend

The Vue frontend is responsible for the graphical user interface. It is implemented using the Vue JavaScript framework and TailwindCSS for styling.

The frontend consists of a single HTML file which loads the Vue JavaScript library and the TailwindCSS stylesheet.

The interface contains elements for displaying the application's toolbar, search and main content area. These elements are populated with data from the Rust backend using Tauri's command system.

The toolbar will contains buttons for opening repositories, which are directories with a centralised database that tracks tags with files. The toolbar will also contain operations for tagging files, and basic file operations such as renaming and deleting files. The main content area contains a list of items, which can be either files and directories, as well as previews and information about each file.

The frontend uses TailwindCSS for consistent styling across all HTML renderers on different platforms.

=== SQLite Database

The SQLite database stores tags assigned to files by users. The database is implemented using the SQLite 3 library and its full-text search extension. Please refer to [Database Schema] for the SQL schema.

The "items" table contains three columns - an autoincrementing ID, the path of the file, and a list of tags. The path column is used to store the relative path of the file to the root of the repository. The tag name column is used to store a list of tags assigned to the file.

The "items_fts" table is a virtual table using SQLite's FTS5 full-text search extension. It allows quick indexing and querying of any text-based columns. In this case, the virtual table is used to index and search the tag name column on the "items" table.

The database is accessed by the Rust backend using the `rusqlite` Rust crate. Functions are provided for opening a database connection, executing SQL queries, and closing a database connection.

=== User Interface Design

#figure(
    image("res/screenshot.png"),
    caption: [Work-in-progress UI, 26 November 2022.],
)

The user interface is designed to be simple and easy-to-use. It consists of a toolbar, a search bar and the main content area. The toolbar contains buttons for opening files and directories, tagging files, renaming files and deleting files. The search bar allows the user to input arbitrary queries. The main content area contains a list of files and directories, as well as previews and information about each file.

The application is designed to be used with a mouse and keyboard. The toolbar buttons and main content list can be clicked using the mouse. Files and directories can also be opened by double-clicking them with the mouse. Keyboard shortcuts are provided for focusing on the search bar (Ctrl+F) and tagging files (Ctrl+T).

When tagging files, the user is presented with a sidebar that displays information about the selected file in the main content area. In the sidebar users can edit the list of tags for the selected file. If the user has selected multiple files, the sidebar will show common tags between all selected files, and any new tags will be added to all selected files.

The user interface is designed to be consistent across all platforms. The application should look and feel the same on Windows, macOS and Linux systems.

== Searching for Items

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
