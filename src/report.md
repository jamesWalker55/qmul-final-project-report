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

## Aim

<!-- This project is related to Personal Information Management (PIM). Particularly,  -->

This project aims to alleviate the management and retrieval of large collections of files. [@JonesPIMBook]

Digital file management is important to many people's lives. Regular users need need to store family photos, digital artists may keep a folder of reference images and concept art, and music producers may maintain a collection of audio samples for future use. With a large collection of files, information retrieval can become difficult as files get placed in deeply-nested folder structures.

The aim of this project is to implement a tag-based file manager. The software must achieve two things: it must be able to tag files then let the user query for files using tags; it must be well-integrated with the file system - not overriding any existing folder hierarchies, and tracking file movement.

<!-- The solution should use a combination of tags and folder structure. This means that files can be tagged, and can also be browsed using a folder structure. If a file is moved to a different folder, the tags for that file should also be moved to the new file. -->

Many existing solutions only focus on tags and do not expect the user to browse the files with a file browser, often overriding a folder's existing structure, renaming files or generating many metadata files that clog up the browser view. [Tag Spaces](https://www.tagspaces.org/) renames the user's files to a space-separated list of tags. [Tabbles](https://tabbles.net/) does not track file movement, so tags are destroyed when files are moved to a new location. [Stagsi](https://stagsi.com/) stops tracking a file if it has been renamed by the user. [Hydrus](https://github.com/hydrusnetwork/hydrus) renames all files to their MD5 hash and moves them to a single folder.

<!-- Users can enforce a logical structure of files by having a folder hierarchy. However, a folder structure will also limits the ways a user can search for files. If a collection of photos was grouped into folders by the year, then into subfolders by the month, the user will not be able to easily search this collection by other factors like the number of people in the photo or the location the photo was taken. As the folder hierarchy grows more complex, so does the effort needed to maintain the hierarchy. -->

<!-- One reason for tackling this issue is personal motivation. I maintain a large collection (~200,000 files) of audio samples, where each sample may belong to multiple categories at the same time. For example, a kick drum audio sample may be placed in the path `SampleRadar - 808 Samples/Kicks/F#-01.wav`, where "SampleRadar - 808 Samples" is the name of the product, and "F#" indicates the musical key of the sample. This limits my ability to retrieve files from the collection and affects how I interact and use this collection for my work - I cannot search this collection directly by a sample's musical key, because the outermost layer of the folder structure is organised by the product name. -->

## Objectives

## Research Questions

## Report Structure

# Literature Review

The programming language used

## Rust

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

# Requirements Analysis

# Bibliography
