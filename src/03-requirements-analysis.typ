= Requirements Analysis

This chapter covers the requirements identified for my application. The following requirements were obtained through a review of existing tagging software and other file management systems, and through online sources such as blogs and discussion forums.

== Functional Requirements

1. The system should allow users to tag files with arbitrary tags.
2. The system should provide a search function which would enable users to search for files based on their tags. This would make it easier for users to find the files they are looking for.
3. The system should preserve any existing directory tree structures, avoiding automatic renaming or moving of files.
4. The system should be able to handle a large number of files, such that the software remains performant in tagging and searching for large numbers of files.
5. The system should be easy to use, such that users can use it without any prior knowledge of tagging or file management.
6. The system should be able to tag any type of file, including but not limited to images, videos, text files, PDFs.
7. The system should be cross-platform and work on Windows, macOS and Linux systems.
8. The system should have a graphical user interface for tagging files and searching for files using tags.
9. The system should allow tags to be assigned to multiple files at once, rather than individually tagging each file one-by-one. This would reduce the amount of time needed for tag assignment, particularly for large numbers of files.

The following requirements are extensions to the project and not mandatory as base functions of the system.

8. The system should be able to handle transferring of tags between different devices or systems. This would allow users to preserve their tags when transferring across multiple systems, and would also allow files to be stored on cloud backup services such as Dropbox or Google Drive.
9. The system should provide tagging suggestions based on the content of the file being tagged. This would help users save time when tagging files by automating the task of tag-assignment
10. The system should display previews of each file, including thumbnails for image files and extension icons for unrecognised file types.

== Non-functional Requirements

1. The system should be able to execute and complete searches within 1 seconds for large file collections up to 10000 files.
2. The system should have a response time of less than 500ms for all file operations such as opening, renaming and tagging files.
3. The application's memory usage should be below 50MB for small collections of up to 1000 files. For larger collections above 10000 files, the application's memory usage should not exceed 100MB.
4. The source code should be well-documented such that it is easy to understand and maintain.
5. All user input should be validated both on the frontend and backend to ensure data integrity and security.
6. The application's graphical user interface should be consistent across all platforms, providing a familiar experience for users regardless of their platform choice.

#pagebreak()