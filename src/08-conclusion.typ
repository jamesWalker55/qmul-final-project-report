= Conclusion

== Future Work <future-work>

=== Audio Sample Categorisation

Audio sample categorisation is a task where given an audio file, the goal is to classify it into one or more categories, such as genre, instrument, and mood. This task can be used in various applications, such as automated music recommendation and music search.

In the context of this project, audio sample categorisation can be used to automatically tag and categorise audio samples. This feature can be found in many popular audio sample management software, such as Algonaut Atlas 2 @sherbourne_2022_algonaut and Waves Cosmos @rogersonpublished_2022_waves.

The audio sample categorisation task is challenging due to the wide variety of possible audio files that can be encountered. This means that the model must be able to handle a wide range of audio files with varying lengths and characteristics. Some common approaches for audio sample categorisation include deep learning techniques such as convolutional and recurrent neural networks.

To implement this extension, I would make use of modern machine learning techniques. The first step would be to collect a dataset of annotated audio samples with data I can derive tags from, such as genre and instrument labels. Due to the large number of samples typically involved in training a neural network, I would likely use an existing dataset rather than manually tagging a dataset.

After obtaining the dataset, I can then use the dataset to train a convolutional or recurrent neural network model. The model would be trained to classify each audio sample into one or more categories. I would use modern deep learning tools such as PyTorch and TensorFlow to train the model.

Finally, I would use the model to classify audio samples into the desired categories. The output of the model can be used to automatically generate tags for the audio samples. The generated tags can then be used to search for files with the software's query bar, as with other user-assigned tags.

=== Query Simplification

This extension relates to simplifying the generated SQL statement produced by the parser described in @query-introduction.

Queries expressed in the query bar can be arbitrarily complicated due to the nature of user-submitted inputs. The software currently translates the plain-text query into an SQL statement without any optimisation. In SQLite, FTS terms are the most expensive to compute due to their internal implementation. Therefore, the number of FTS terms in the resulting SQL query should be minimised.

The following example query contains tags (`a`, `b`, `c`) and path (`in:1`, `in:2`) terms, the output SQL query contains three separate FTS terms in total.

```sql
-- The plain-text query
(a in:1 | b in:1) c

-- The generated SQL WHERE clause
WHERE (
  (
    (i.id IN (SELECT id FROM tag_query('a'))
      AND i.path LIKE '1%')
    OR
    (i.id IN (SELECT id FROM tag_query('b'))
      AND i.path LIKE '1%')
  )
  AND
  i.id IN (SELECT id FROM tag_query('C'))
)
```

To optimise the query, we can convert the input query into conjunctive normal form (CNF) and disjunctive normal form (DNF) @büning1999propositional. These forms flatten any nested groupings in the query, and represent the query as either an AND or ORs, or an OR of ANDs. Depending on the query submitted by the user, either the CNF or DNF form will contain the least amount of query terms.

For instance, the query expressed above can be converted into DNF, which yields the following SQL statement with only two FTS terms:

```sql
-- The plain-text query in DNF
a c in:1 | b c in:1

-- The generated SQL WHERE clause
WHERE (
  (i.id IN (SELECT id FROM tag_query('a AND c'))
    AND i.path LIKE '1%')
  OR
  (i.id IN (SELECT id FROM tag_query('b AND c'))
    AND i.path LIKE '1%')
)
```

Further work on the software will include implementation of CNF and DNF algorithms to simplify the user-provided query before converting to an SQL statement.

=== Plugin System <future-work-plugins>

As seen in the discussion on public feedback at @public-feedback, the software could potentially be used for many diverse use cases. However, it is infeasible to implement features for all possible use cases in a single program.

One approach would be to implement a plugin system for the software, such that users are able to create their own scripts for their own particular use case. This is a popular approach taken by many existing software such as Blender, Visual Studio Code, Google Chrome and many more.

The plugin system should allow editing of file tags stored in the repository, as well as calling external programs to provide integration with other software. This would enable many of the diverse use cases discussed in @public-feedback.

There are many choices for choosing a programming language as the scripting interface for the software. One popular choice is Lua, which is used as the plugin system for Neovim. Lua is a fast and lightweight language @pall_2012_luajit that has good integration with many languages including C and Rust, this has made it a good choice for a plugin system language.

#pagebreak()
