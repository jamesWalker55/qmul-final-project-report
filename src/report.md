# Abstract {-}

(all reports have this)

# TOC {-}

TOC should be after abstract.

# Introduction

## Background

Computer users interact with digital files on a daily basis. This includes storing files, organising files, and retrieving files. The act of managing files and retrieving information is fundamental and necessary for general computer usage and many computer-based knowledge work. With modern systems and increased computer usage, the number of digital files on a user's system has increased significantly [@dinneen2020ubiquitous].

This is related to the field of Personal Information Management (PIM). PIM is concerned with the management of digital files on the computer, and how people store, organise, and retrieve information to complete tasks. The increasing number of digital files on computer systems has made it more important than ever to investigate effective methods of managing digital files.

The directory tree structure is the de facto standard for data storage. Since its usage in early operating systems such as the OS/360 by IBM, most operating systems nowadays including Microsoft Windows, macOS and Linux distributions use directory trees as the data storage method. In such a system, filenames are used to uniquely identify files, and files can be placed within directories or folders.

The most common way of storing data on a computer is by using a directory tree structure. Organising files in a directory tree is analogous to sorting paper documents in real life - users can organise files by placing them into folders and further subfolders. While this is an intuitive way of organising files due to its similarities to organisation in real life, it is not an efficient way of organising and recalling files.

Storage of files using a directory tree is trivial, since users can store files anywhere they wish. The main challenge arises when the user has a large amount of files, it can become difficult to organise and retrieve them. Users have to spend time to search through folders and subfolders, looking for the file they want. This makes file management a time-consuming task.

## Problem Statement

Current file management systems are not efficient when it comes to managing a large number of files. Trying to search for a particular file can be a very time-consuming process. The main reason for this is that these systems are based on a hierarchical structure which makes it difficult to search for files based on their content [@DeVocht2012]. This problem is compounded when the users have to deal with a large number of files which can be difficult to organise consistently and structurally.

There are many methods available for users to search for files. This can include search functions, browsing through folders, or even looking through the recent documents list. However, these methods can be time-consuming and often give imprecise results that fail to find the file the user wants. This is a major problem for users who have to deal with large numbers of files.

Another major problem with current file management systems is that they are not flexible when it comes to organising files. This is because they are based on a hierarchical structure which can be inflexible and difficult to use. This can make it difficult for users to organise their files in a way that is suitable for them.

## Aim

<!-- This project is related to Personal Information Management (PIM). Particularly,  -->

The project aims to investigate and develop a tag-based file manager. The system would allow users to assign tags to their files, and then search for those files based on those tags. The aim of this project is to develop a file management system which is more efficient than current systems, and which enables users to organise their files in a way that is suitable for them.

Compared to a hierarchical directory structure, a tag-based approach would allow users to organise their files in a more flexible and efficient way. Users would be able to assign arbitrary tags to their files then search for those files using those tags. This lets users avoid the time-consuming task of classifying files and browsing folders, for example deciding which single folder to place a file into [@dinneen2020ubiquitous]. This would also enable users to search for files based on their content, and would make it easier for users to manage their files.

Users would still be able to organise their files into folders if they so choose. However, the system would not impose any strict structure on users and would allow them to store their files in any way they want. This is in contrast to existing tagging software which often override any existing hierarchical file structure and do not allow any hierarchical organisation.

The system should provide a search function which would enable users to search for files based on their tags. This would make it easier for users to find the files they are looking for. The system should also be able to handle a large number of files, such that the software remains performant in tagging and searching for large numbers of files.

The system should also be easy to use, such that users can use it without any prior knowledge of tagging or file management. This is in contrast to existing tagging software which often have a steep learning curve, and require users to have some knowledge of tagging before they can be used effectively.

## Objectives

The objectives of the project are as follows:

- To identify existing challenges related to PIM and file management.
- To compare and evaluate existing tagging software available to users.
- To understand the needs of users when performing file management tasks.
- To gain an understanding of concepts related to PIM.
- To investigate the challenges related to file management.
- To develop a system to allow users to manage and search files using tags.
- To implement a user interface that is easy to learn and efficient to use.
- To evaluate the effectiveness of the prototype system through user testing.
- To evaluate the system against existing software systems.
- To conclude on the effectiveness of the system and to come up with recommendations for further work.

## Research Questions

The research questions for this project are as follows:

- How effective are existing solutions when it comes to managing a large number of files?
- What do users need from a file management system in order to manage their files effectively?
- Can a tag-based approach be used to improve the efficiency of file management?

<!-- ## Project Structure

(The following is auto generated)

Section two explores the literature related to PIM and file management. Section three discusses the existing solutions that are available to users. Section four looks at the needs of users when performing file management tasks. Section five presents the development of the prototype system. Section six looks at the evaluation of the prototype system. And finally, section seven provides the conclusion and recommendations for future work. -->

# Literature Review

In this section, we will review the existing literature related to file management, tagging, and personal information management. This will include a review of the challenges related to file management, an evaluation of existing solutions, and an investigation of the needs of users when performing file management tasks.

## Personal Information Management

Personal Information Management (PIM) is a field of research which is concerned with the management of digital files on the computer. This includes how people store, organise, and retrieve information to complete tasks. PIM is a relatively new field, and has only been studied extensively in the last few years. PIM is focused on how people organise, maintain and retrieve information, and on methods that can improve these tasks. This is not limited to digital files, but can also include paper documents for example.

One of the aims of PIM is for people to have the right information in the right place, in the right form and with enough completeness and quality to meet the current need [@jones2007personal]. However this is not the case for most people. Often the necessary information may not be found by the user, or the information may arrive at an unsuitable time such that it cannot be used.

@jones2010keeping mentions the idea of "keeping found things found", in which people store information in multiple location and multiple applications. If this is performed inconsistently, the information people need is scattered widely, which makes it even more difficult to maintain and organise information. This is known as information fragmentation [@jones2007personal].

## File Management

File management can be defined as the process of storing, retrieving and manipulating files on a computer system. This includes tasks such as creating, copying, moving and deleting files. File management is a fundamental task for users when using computers.

Most modern operating systems use directory trees to store data within files. A directory tree is a hierarchical structure in which each node represents either a file or folder. In this type of structure, filenames are used to uniquely identify each file within the system. Users can create directories or folders to group together related files.

While current methods for managing digital files are adequate for small workloads, they can become less effective with larger file collections. With larger collections, file hierarchies tend to have deeper structures [@henderson2009empirical]. This lead to file name duplication [@henderson2011document], and longer times spent to retrieve files [@bergman2010effect]. Large hierarchies also require the user to make many navigational decisions with many subdirectories per directory [@hicks-2008-organizing].

There are many methods that can be used to help deal with large file collections. These include using automated organisational methods, and providing users with better tools for managing their files. Automated methods can be used to help users organise their files into a more manageable structure. This may include grouping files based on content or context using artificial intelligence algorithms.

## Tagging

A tag is a label or keyword that can be attached to an item. One benefit of using tags to categorise items is that items can be easily found and classified. This can be useful for many tasks, such as information retrieval and content organisation.

One benefit of tagging over hierarchical systems is that it is more flexible. This is because tags can be arbitrarily named depending on the user's needs, and then assigned to multiple items at once. Items do not have to fit into predefined categories.

Tagging rose into popularity through its usage in many websites in Web 2.0 [@smith2007tagging]. Tagging is now widely-used, and can be found in many social media websites and online services. One example of this is category tags in news websites and blogs.

Tagging has also been used to help users organise their files on the computer. There are some tools available that allow users to tag their files, and then search for them using those tags. This provides a more flexible way of organising files compared to traditional hierarchical directory structures. It also makes it easier for users to find the files they are looking for since they can search using any combination of tags.

Tagging has many advantages over traditional methods for managing digital files. The most significant advantage is that it enables users to search for files based on their content, rather than just their filename or location. This makes it much easier for users to find the files they are looking for. Another advantage of tagging is that it does not require any specific structure or organisation, which may make it easier for users to manage their files.

There are also some disadvantages associated with tagging. One of the main disadvantages is that manual tagging can be a time-consuming process, particularly if the user has a large number of files. Another disadvantage is that automatic tagging systems are not always accurate, and can often assign incorrect tags to files.

## Existing Tagging Software

There are many software solutions for using tags for file management. Some of them are standalone applications, while some may be integrated into the operating system.

<!-- TODO: Include a cool table here -->

<!-- See table \ref{tagging-software-comparison}.

Table: Comparison of existing tagging software \label{tagging-software-comparison}

Software|Features|Limitations
-|-|-
a|a|a -->

### Windows' Native Tagging System

All Windows versions since Windows 7 has built-in tagging functionality. However this functionality is well-hidden and difficult to access. On files that support tags, a field for a list of tags is available on the "Properties > Details" popup panel.

Windows also provides a method for searching for files based on tags. On the search bar in Windows Explorer, the syntax `tag:<tagname>` can be used to search for files containing a specific tag.

The main advantage of this solution is that it is integrated into Windows, requiring no additional software. This makes it easy for users to get started with the system, and makes it easy to use since users are likely already familiar with File Explorer and Windows Search.

The main issue with Windows' native tagging system is that not all filetypes support tags. For example, tags cannot be applied to PNG image files and various audio formats including WAV and MP3. This is a significant limitation given that PNG, WAV, MP3 and other formats are commonly-used, users are likely to have many files of these types.

Another issue with Windows' tagging system is that users can only assign tags to each file at a time. It is not possible to assign a single tag to multiple files at the same time. With a large number of files, tagging each file will become a very time-consuming process.

One more issue is the speed of Windows' search functionality. Windows does not cache or index the tags contained in each file. This means that the system needs to scan each file for the specific tag the user requested when performing a search. The time required to search for files grows proportionally with the number of files the user has.

### TagSpaces

TagSpaces is an open source application which runs on Windows, macOS and Linux.

It provides basic features such as assigning tags to files, and searching files based on tags. TagSpaces tags files by directly renaming the file with a prefix containing the tags to be assigned, wrapped with square brackets.

One benefit of this approach is that it is able to track file movement. Files that are moved using the file default program can still be found by TagSpaces since the tags are part of the filename. This also means that a file's tags are viewable using any file manager by simply viewing the filename.

One issue with TagSpaces is that renaming files can break links between applications and files. For files that act as dependencies for other application, this method cannot be used. For example, an audio file `cat.wav` may get renamed to `[animal recorded short purr] cat.wav`. Any third-party applications that are linked to the `cat.wav` file will now be unable to find the file and give an error.

Another issue with TagSpaces is that the filenames can get very long as users assign more tags to files. With a large number of tags on a file, the original filename will be prefixed by a large amount of text, making it difficult to view the original file name using file managers. For example, a file name like `[photo 2019 holiday uk london beach sunny clouds sea me dan jason burger beer sunglasses pub] IMG_7690.png` would easily get truncated in file managers, the user will not be able to view the full file name without resizing the entire window.

### Tabbles

Tabbles is a desktop application that only runs on Windows systems. It comes in several variants: individual, cloud, and LAN. The different versions differ in how tags are shared between users on the same network or users connected to the cloud.

Tabbles tags files using a backing database, separate from the files being tagged. When the user moves a file to a different folder, a background service is used to detect such file movements and update the database to use the new path.

It provides many features. It allows grouping tags into a hierarchy, creating auto-tag rules, and tagging of entire folders for example.

One advantage of Tabbles is its auto-tagging feature. This feature allows for automatic assignment of tags to files based on specific file conditions. This helps the user save time when organising and managing files by automating the task of tag-assignment.

One issue with the software is that tags are not transferrable between computers. Tags are stored in a database that is associated with the system. This makes it very difficult to transfer tags if the user needs to upgrade their operating system and reinstall their system, or if the user wishes to upload their files to cloud backup.

From personal testing, another one of the issues is its slow performance. The application takes a long time to execute searches. When loading a large list of files, it slows down significantly as it scans each file to generate image previews.

<!-- TODO: Analyse more software! -->

Rust is a programming language designed by Graydon Hoare. It is designed to be memory-safe while still being performant [@balasubramanian2017system]. This is enforced by the Rust compiler, which checks memory-safety rules during compilation.

Rust is increasingly adopted by companies and projects such as Microsoft, Amazon, Cloudflare, and Facebook [@davison_2022_adoption]. It has also been integrated into the Linux kernel [@proven_2022_rust].

I have no prior experience in low-level languages like C++ and Rust. The Rust language's memory-safety features and commercial support make it a good choice for the final project, as well as a good low-level language for improving my skill set and future career paths.

## Tauri

Tauri is a Rust framework that allows developing desktop applications using web technologies like HTML, CSS, JavaScript for the frontend, while using Rust for the backend [@tauricontributors_2022_tauriappstauri].

Rust is a relatively new language compared to other languages. It has many user interface libraries, however most of them are in the early stages of development and not yet fully-featured [@shivshank_2022_are].

Tauri uses web technologies for implementing user interfaces. This allows developers to use widgets and components from frontend frameworks such as Vue and React - developers are not limited to a small subset of widgets implemented by the library author.

## Vue

**(TODO)**

Vue is a JavaScript frontend framework by Evan You. It allows the developer to break down user interfaces into smaller parts called components, and enables efficient rendering of these components by only updating parts of the components that have been modified.

Compared to other frontend frameworks such as React, Vue has two-way binding - it allows inner (child) components and outer (parent) components to communicate in both directions, whereas React only allows parents components to communicate with child components and not the other way around. This enables the development of more flexible components and **(TODO)** [@patel_2018_react]

I chose Vue as the frontend framework because I find it to be more structured and flexible compared to React. Vue was also the framework used in one of the university modules I am studying.

## SQLite

SQLite is "a small, fast, self-contained, high-reliability, full-featured, SQL database engine", being one of the most used database engines in the world [@sqlite_2019_sqlite].

Compared to other SQL engines, SQLite is a serverless database engine that operates on a single database file. This makes it suitable for developing a desktop application as it

## Existing programs review

# Project Analysis

# Design

# Implementation

## Extension 1 - TODO

## Extension 2 - TODO

# Testing

# Evaluation

# Conclusion

# Bibliography
