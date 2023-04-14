#import "meta.typ": title, author

#set document(title: title, author: author)
#set page(paper: "a4")

#show link: underline
#set par(justify: true)
#set text(font: "New Computer Modern", size: 11.5pt)
#set heading(numbering: "1.")

#include "00-cover.typ"
#include "00-abstract.typ"

// Start showing page numbers at the outline
#set page(numbering: "1")

#outline(indent: true)

#pagebreak()

// Start showing headers after the outline
#set page(header: block(inset: (bottom: 5pt), stroke: (bottom: 1pt), title + h(1fr) + author))

#include "01-introduction.typ"
#include "02-literature-review.typ"
#include "03-requirements-analysis.typ"
#include "04-design.typ"
#include "05-implementation.typ"

#include "99-appendices.typ"

#bibliography("bibliography.bib", style: "chicago-author-date")
