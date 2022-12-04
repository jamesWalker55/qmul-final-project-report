# Project Aims

<!-- • The project aims to investigate and develop a tag-based file manager which will allow users to assign tags to their files and search for them based on those tags.
• This approach would be more efficient than current file management systems and would allow users to organise their files in a way that is suitable for them.
• The system should provide a search function which allows users to search for files based on their tags.
• The system should also be able to handle a large number of files and be easy to use for users with no knowledge of tagging or file management. -->


<!-- • Investigates and develops a tag-based file manager to enable efficient file management.
• Allows users to assign tags to their files, and then search for them based on those tags.
• Flexible and efficient compared to hierarchical directory structure.
• Search function to enable users to search for files based on their tags.
• Ability to handle a large number of files.
• Easy to use without prior knowledge of tagging or file management. -->

<!-- - The act of managing digital files is fundamental to computer usage, and the increasing number of digital files has made it more important to investigate effective methods of managing digital files.
- Current file management systems are not efficient when it comes to managing a large number of files.
  - These systems are based on a hierarchical structure (directory tree) which makes it difficult to search for files based on their content.
  - They are also not flexible when it comes to organising and retrieving files.
- Investigate and develop a tag-based file manager which allows users to assign tags to their files and search for those files based on those tags.
  - Provides a search function which enables users to search for files based on their tags.
  - Make the system easy to use for users with no prior knowledge of tagging or file management. -->

Digital file management is fundamental to computer usage.

- The increasing number of digital files has made it more important to investigate effective methods of managing digital files.

Current file management systems are inefficient for managing a large number of files. [@henderson2009empirical] [@henderson2011document] [@bergman2010effect] [@hicks-2008-organizing]

- They are based on a hierarchical structure (directory tree) which makes it difficult to search for files based on their content.
- They are also not flexible when it comes to organising and retrieving files.

------

Investigate and develop a tag-based file manager.

- Allows users to assign tags to their files; provides a search function to search for files based on their tags.
- Make the system easy to use for users with no prior knowledge of tagging or file management - UI is one of the focus of this project.

# Project Objectives

Research:

- To identify existing challenges related to PIM and file management.
- To compare and evaluate existing tagging software available to users.
- To gain an understanding of concepts related to PIM.
- To understand the needs of users when performing file management tasks.
- To investigate the challenges related to file management.

------

Implementation:

- To develop a system to allow users to manage and search files using tags.
- To implement a user interface that is easy to learn and efficient to use.

Evaluation:

- To evaluate the effectiveness of the prototype system through user testing.
- To evaluate the system against existing software systems.
- To conclude on the effectiveness of the system and to come up with recommendations for further work.

# Programme of Study

(TODO)

# Why is this a Engineering/Computing problem?

We develop a tag-based file manager.

- Desktop application, interfaces with the underlying operating system
- Built using engineering principles and computing technologies
- Design system that allows assignment and quick searching of tags on files
- Handle large numbers of files
- User interface should be easy to use, UX

------

Concepts in engineering and computing:

- Requirements gathering
  - Entity-relationship modelling
  - Use cases
- Backend language: Rust
  - Operating system (file operations, file tracking)
  - File systems
  - Object-oriented programming
  - Multi-threading, concurrency
  - Efficient programming (dynamic programming, recursion, complexity)

------

Concepts in engineering and computing:

- Database: SQLite
  - Database management systems
  - Database schemas
  - Database design
- Web technologies: JavaScript, Vue
  - Client-side programming
  - Web frameworks
  - HTML, CSS
  - UX, User Interface design
- Testing: Unit, integration, user
  - Automated testing
  - Performance testing
  - Usability testing

# Literature Review Findings

<!--
- How have others approached this, or a related, problem in the past?
- What lessons can be learned from what has been done before?
- Convince your supervisor that you have gained some knowledge about the background to the problem.
- Cite information sources / provide a list of references (add to the last slide)

> Literature review findings, this is a very important slide because what I want you to do is take a literature review and condense it into three or four bullet points, say exactly what your key findings are, what are the key challenges, and then this leads nicely to the next slide...
-->

Concepts

- Personal Information Management (PIM) - a field of research, concerned with how people store, organise, and retrieve information to complete tasks.
- File management - the process of storing, retrieving and manipulating files on a computer system.
- Tagging - assigning labels to an item, enable users to search for files based on their content.

------

Previous approaches

- Directory trees
  - Used by most modern operating systems
  - File name duplication
  - Deep structures require users to make many navigational decisions
- Tagging
  - Windows built-in tagging - doesn't support all filetypes, tagging interface is difficult to access.
  - TagSpaces - directly renames the file with a prefix containing the tags, causes issues with other software.
  - Tabbles - tags files using a backing database, but is not portable and locked to the system.

------

Lessons learnt

- Tagging may be more efficient than directory trees
- Many ways to implement tagging, depending on the use case.
- Additional features such as tag hierarchies, auto-tag rules to improve UX.
- Must support arbitrary filetypes, avoid modifying the existing file structure.

# What is your proposed solution?

<!--
- How will you solve the problem stated on the previous slides?
- Give an design overview of the structure of the solution.

> this leads nicely to the next slide, which is based on those challenges, the proposed solution for my project is this, or my implementation or experimentation is going to be designed in this way.
>
> Again, it's just an overview of the structure of the solution or the implementation work you're going to do. We're not expecting you to have all of this completed is just to give an idea to your assessors exactly what you intend to implement or whatever your practical element is.
-->

I will develop a tag-based file manager that allows users to assign tags to their files and search for them.

Structure / Implementation

- Rust backend
  - For file operations, database access and cross-platform compatibility.
  - Responsible for creating, reading, and updating files and tags.
- Vue frontend
  - For the graphical user interface and cross-platform compatibility.
  - Provides a user-friendly interface for tagging and searching files.
- SQLite database
  - For storing files and tags, and searching for files given a user query.

------

Functionality

- A folder can be designated as a "repository"
  - Similar to repositories in version-tracking software like Git
- The software is able to assign, search and manage tags for all files within a repository
  - Tags are not tied to the operating system, so the tags can be transferred between systems by moving the folder
- Keep track of files and tags using a database for each repository
  - Keeps existing file structure intact, avoid breaking compatibility with other software
- UI should be designed to be accessible and easy to use
- Provide a flexible and powerful search function

# How will you evaluate your solution?

<!--
- State the evaluation/validation method and how this method has been used before.
- Why this method and not another?
- What are the benefits and risks of this method?

> Also, I want you to start thinking about your evaluation, how are you going to evaluate your system in the second semester?
>
> Start thinking about that now.
>
> I know this has not included the interim report, but it's very important you start thinking about that now because it's a good opportunity to have this information on this slide, which you can then discuss with your supervisors.
> -->

I will use 3 methods:

- Performed with university students, friends, etc:
  - Heuristic evaluation
  - Observational user study
- Performed online through forums, social media:
  - Questionnaires

------

Heuristic evaluation

- Finds usability problems with a software
- Performed using people who also know what heuristic evaluation is
  - e.g. Students studying in QMUL
- Advantages
  - Fast and cheap
  - Small number of people required (3-5 people)
  - Tends to find many problems
- Issues
  - Doesn't use actual users
  - Not task focused, only finds general interface problems

------

Observational user study

- Present users with a task to perform, and observe how they perform the task
- Performed using actual users
- Advantages
  - Finds usability problems related to specific tasks
  - Uses actual users
- Issues
  - More time consuming to set up

------

Questionnaires

- Distribute software to users, then ask for feedback using a form
- Performed using actual users
  - e.g. Online users
- Advantages
  - Cheap and easy to distribute (e.g. online Google forms)
  - You can build a picture based on respondent data
- Issues
  - Quality of responses depend on the questions you ask
  - The answers don’t provide a lot of context

# Project Planning

Done|Deadline|Milestone
-|--|-----------
X|October|Build any mini-project using Rust, Tauri and Vue to learn the framework and libraries
.|December|Initial implementation of database backend, using sqlite
.|February|More work on the backend implementation, early prototype of the application (focus on functionality rather than UI)
.|March|Polished prototype, minimal viable product
.|April-May|Project extensions and finalised software

# Risk Register

<!--
> Risk register is all to do with risk assessment for your project.
>
> There's a few videos you need to watch. There's a video about risk categories and there's a video about risk management. In this video, if you watch this video, there's an example of how to create a risk register for your project. What are the risks that you need to be aware of and what risks that you need to, how will you mitigate some of those risks to your project? So that's what you need to include. Again, you must watch this video, otherwise you will not be able to create a risk register.
-->

\tiny

Risk|Impact|Likelihood|Rating|Preventative actions
---|---|-|-|-----
Cannot finish initial implementation by March|Cannot complete draft report with sufficient information|Low|High|Break down project into basic functionality and extensions, focus solely on basic functionality before moving onto extensions
Fail to find any users for testing|Cannot complete project evaluation|Low|High|Start finding users for testing as soon as initial implementation is complete

# References
