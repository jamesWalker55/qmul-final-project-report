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

Investigate and develop a tag-based file manager.

- Assign tags to files
- Search for files based on tags
- Should be easy to use for new users
  - UX is one of the focus of this project.

------

Digital file management is fundamental to computer usage.

- Required for workers or casual users
- Number of digital files is increasing - storage space increasing

Current systems are inefficient for managing a large number of files:

- Hierarchical structures (directory trees) - difficult to search for files [@henderson2009empirical] [@hicks-2008-organizing].
- Less flexible for organising and retrieving files [@henderson2011document].

# Project Objectives

Research:

- Identify challenges in PIM
- Evaluate existing tagging software
- Gain an understanding of PIM concepts
- Understand the needs of users when managing files
- Investigate challenges related to file management

------

Implementation:

- Develop a system - allow managing and searching files with tags
- Implement UI - easy to learn, and efficient

Evaluation:

- Evaluate effectiveness of system through user testing
- Evaluate system against existing software
- Come up with recommendations for further work

# Programme of Study

<!-- A1: Knowledge and skills related to the key field of software engineering, including the ability to design, implement and test algorithms and larger programmes in a rigorous and principled way, and detailed understanding of the software development life-cycle, relevant methodologies and tools. -->

A1: Must design, implement and test software to ensure it meets objectives - appropriate methodologies and tools _(e.g. design patterns, test-driven development)_

<!-- A2: Knowledge and skills related to the key field of computer systems, including understanding of the principles of computer architecture, operating systems and networks, and the ability to use specific techniques for small-scale implementations. -->

A2: Understand operating systems for software integration - small-scale implementation techniques _(e.g. dynamic programming, unit testing, benchmarking)_

<!-- A3: Knowledge and skills related to the key field of applications, including understanding of some of the major application areas in the sciences, medicine, industry and commerce, and the ability to grasp and apply appropriate usability principles and techniques for these areas. -->

A3: Understand the needs of users - appropriate usability principles and techniques _(e.g. participatory design, data collection)_

------

<!-- B1: Analyse and solve technical problems effectively, both individually and as part of a design team -->

<!-- B2: Understand and apply technical project management techniques and skills -->

B2: Follow a plan, including timeline, milestones, objectives; use risk registers

<!-- B3: Demonstrate awareness and understanding of the mathematical, scientific and engineering foundations of the discipline of computer science -->

B3: Project uses appropriate mathematics and engineering techniques - requires understanding of algorithms, data structures, software engineering principles

<!-- B4: Demonstrate awareness and understanding of the historical, social, professional, industrial and ethical context of the discipline of computer science -->

B4: Consider the ethical implications when developing the system _(e.g. user privacy and data security)_

------

<!-- B5: Communicate technical detail effectively to a variety of audiences, both through production of well-written technical reports and through oral presentation / demonstration -->

B5: Final project report and presentation: should be clear and concise - requires understanding of technical details to present them effectively

<!-- C1: Connect information and ideas within the broader context of the discipline of computer science -->

<!-- TODO: Simplify the rest -->
C1: The project integrates various concepts from the field of computer science, such as operating systems, algorithms and user experience. This requires the use of appropriate techniques to ensure that the various components of the system are integrated correctly.

<!-- C2: Acquire and apply knowledge in a critical way, evaluating its reliability and relevance, in order to investigate and solve unfamiliar problems -->

C2: The project investigates existing solutions to file management, as well as develops a new system to manage and search files using tags. This requires the use of critical thinking to evaluate the reliability and relevance of the knowledge acquired in order to solve the unfamiliar problems associated with the project.

------

<!-- C3: Explain complex technical concepts clearly in a variety of settings, to a variety of audiences, using a variety of media -->

C3: The project requires the communication of complex technical concepts, such as algorithms and data structures, to a variety of audiences, both through the production of a report and through the presentation of the project. This requires the use of appropriate communication techniques to ensure that the technical concepts are explained in an effective manner.

<!-- C4: Develop a strong sense of intellectual and professional integrity -->

C4: The project requires the use of ethical principles, such as user privacy and data security, in order to ensure that the system is developed in a responsible manner.

<!-- C5: Think and work creatively, using information and experience as the basis for decision-making -->

C5: The project involves the development of a system to manage and search files using tags. This requires the use of creativity and innovation to develop a system which is different from existing solutions.

# Why is this a Engineering/Computing problem?

We develop a tag-based file manager.

- Desktop application, interfaces with the underlying operating system
- Built using engineering principles and computing technologies
- Design system architecture such that it...
  - Allows assignment and quick searching of tags on files
  - Handle large numbers of files
- User interface should be easy to use, related to UX

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

- Personal Information Management (PIM) - a field of research, concerned with how people store, organise, and retrieve information to complete tasks [@jones2007personal].
- File management - the process of storing, retrieving and manipulating files on a computer system.
- Tagging - assigning labels to an item, enable users to search for files based on their content.

------

Previous approaches

- Directory trees
  - Used by most modern operating systems
  - File name duplication [@henderson2011document]
  - Deep structures require users to make many navigational decisions [@hicks-2008-organizing]
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

------

![Mockups](src/slice2.png){ width=90% }

------

![Mockups](src/slice3.png){ width=90% }

------

![Mockups](src/slice1.png){ width=90% }

------

![Current state](src/screenshot.png){ width=100% }

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
