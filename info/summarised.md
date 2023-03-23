The following is a paper by a researcher developing TagRepo, a tag-based file manager:

------
1 Introduction
This project aims to develop a tag-based file manager, allowing users to assign tags to their files and search for them. The aim is to create a system which is more efficient than current systems, allowing users to organise their files in a way that is suitable for them. The research questions for the project focus on understanding existing solutions, the needs of users when performing file management tasks, and the effectiveness of a tag-based approach.

2.1 Personal Information Management: Personal Information Management (PIM) is a field of research which is concerned with the management of digital files on the computer. PIM aims to have the right information in the right place, but this is not the case for most people. Information fragmentation is a common occurrence when using multiple locations and applications.

2.2 File Management: File management is the process of storing, retrieving and manipulating files on a computer system. Most modern operating systems use directory trees to store data within files. With larger collections, file hierarchies tend to have deeper structures and require the user to make many navigational decisions. Automated methods can be used to help users organise their files.

2.3 Tagging: A tag is a label or keyword which can be attached to an item. This enables users to search for files based on their content, rather than just their filename or location. Tagging is widely-used, and can be found in many social media websites and online services. There are many software solutions for using tags for file management.

2.4 Existing Programs Review: Windows has built-in tagging functionality, but not all filetypes support tags and only one tag can be assigned to each file at a time. TagSpaces tags files by directly renaming the file with a prefix containing the tags. Tabbles tags files using a backing database, and provides features such as grouping tags into a hierarchy and creating auto-tag rules.

3 Requirements Analysis
This section identifies the functional and non-functional requirements of the project. It lists the functional requirements such as allowing users to tag files with arbitrary tags, providing a search function, preserving existing directory tree structures, handling a large number of files, being easy to use, being cross-platform, having a graphical user interface for tagging and searching, and allowing tags to be assigned to multiple files. The non-functional requirements include executing and completing searches within 1 second, having a response time of less than 500ms for all file operations, having a memory usage below 50MB for small collections and below 100MB for larger ones, having well-documented source code, validating all user input, and having a consistent graphical user interface across all platforms.

4 Design
This section discusses the components of the application and how they interact with each other. It explains that the application consists of a Rust backend for file operations, database access and cross-platform compatibility, a Vue frontend for the graphical user interface, and a SQLite database for storing files and tags. It further explains that the Rust backend is responsible for file operations, database access and cross-platform compatibility, the Vue frontend is responsible for the graphical user interface, and the SQLite
------
