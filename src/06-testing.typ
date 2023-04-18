= Testing

== Software Testing

Testing of the application involved implementing unit tests for each application module, as well as integration tests for testing how the different modules integrate together. As of writing, 130 unit and integration tests have been implemented. The test output is included in the appendix at @test-output.

=== Unit tests

Unit tests were implemented for each module in the Rust backend. The tested modules include: `diff.rs` for diffing file trees, `repo.rs` for the repository definition, `scan.rs` for scanning a given folder, `sql.rs` for escaping strings to be inserted into SQL queries, `parser.rs` for the parser part of the query transpiler, and `convert.rs` for the codegen part of the query transpiler.

=== Integration tests

Integration tests were implemented to test how different modules would work together. The integration tests were implemented in `query_repo.rs` with a mock repository to assert that the results of the query transpiler were as expected when used in an actual SQLite connection.

== User Testing

User testing was performed in two forms. The first form involved giving a group of participants the software and a task, and finally completing a survey. The second form involved a public release of the software to gather feedback and suggestions about the software.

=== User Trials

A group of five users were given the software and tasked to tag files in a given folder. A brief introduction of the software was given, and a link to the manual described in @manual-website was provided. I will discuss the results of the survey in this section.

#figure(
  image("res/survey-q1.png", width: 70%),
  caption: [Responses to the question "How was your experience using the program?"],
)

None of the individuals involved in the survey felt the program was difficult to use, the responses ranged from "medium" to "very easy". This indicates that the user interface is generally user-friendly and understandable.

#figure(
  image("res/survey-q2.png", width: 70%),
  caption: [Responses to the question "How easy was it to use tagrepo's search engine to find files?"],
)

Most of the users felt it was easy to use the search engine to search for files.

One user noted that they had expected the search bar to be used to search by file name, not by tag. When a new repository is created and the user has not assigned any tags yet, tag searches on the query bar will yield no results. In order to search for files, one must use prefixed operators such as `in:my_folder` to search for files without using tags. This design decision may be beneficial if the user rarely searches by file name, for example in repositories that are well-tagged. However, this design can become inconvenient in less well-tagged repositories as users rely more on searching by file names, and must prefix each search term with the text `in:`.

#figure(
  image("res/survey-q3.png", width: 70%),
  caption: [Responses to the question "How satisfied are you with the speed and responsiveness of tagrepo?"],
)

Most of the users felt the software was quick and responsive. This is helped by the implementation of the virtual list and reduced data transfer described in @optimise-item-list.

#figure(
  image("res/survey-q5.png", width: 70%),
  caption: [Responses to the question "How do you feel tagrepo compares to existing file management solutions?"],
)

#figure(
  image("res/survey-q6.png", width: 70%),
  caption: [Responses to the question "Do you often have trouble finding the files you need?"],
)

#figure(
  image("res/survey-q4.png", width: 70%),
  caption: [Responses to the question "Would you recommend this program to others? Why or why not?"],
)

While the responses to the questions are generally positive, one of the responses highlight the fact that this software solves the issue of file organisation in a specific way that may not be applicable to all users. However, for users who are dealing with file management issues, the software can provide an efficient solution.

== Public Feedback <public-feedback>

#let quote(content) = {
  set text(fill: luma(25%), style: "italic")
  block(inset: (left: 24pt), content)
}

The software was posted online and I received feedback and suggestions from online users. The software was well-received, most of the responses I received were suggestions for new features and use cases.

One common suggestion was to introduce hierarchies of saved searches, in that they are organised similar to folders. The difference from folders is that a single file can appear in multiple hierarchies at the same time, and these hierarchies may be dynamically populated. One example of this may be having two different hierarchies for a personal photo collection: one hierarchy would be organised according to the persons that appear in the photo, and another one would be organised by the year the photo was taken.

#quote[
  I see this as a tool for not only searching data, but also for organizing and presenting it. Create multiple simultaneous alternative hierarchies for the same data. And do so both dynamically or statically. As tags are added, or new hierarchies the same data may appear in different hierarchies at the same time. Different views of the structure deduced form the tagged data.
]

Another suggestion was to enable real-time synchronisation between systems. This would allow the same tags to be accessed from multiple systems at the same time, for example on a desktop computer and on a mobile device. The current design of the repository relies on a SQLite database which is a binary data format. If any synchronisation errors occur on multiple devices, it is impossible to resolve conflicts in a binary database compared to using a plain-text tag storage method. One possible solution would be to support multiple tagging methods in the software, one being the currently-used SQLite database method, and another being a plain-text method that creates a sidecar file next to the file being tagged.

Many of the suggested features were out of scope for this software, such as image de-duplication and tag detection from videos. These use cases could be supported with the implementation of a plugin system that allows users to write their own scripts and integration with external programs. This will be further discussed in @future-work-plugins.

The feedback reflects that the design of the software has potential and can be further developed in many ways.

#pagebreak()
