// The cover page

#import "meta.typ": title, author, programme_of_study, supervisor, submission_date

#let cover_divider_line_width = 3pt
#set text(1.2em)

#grid(
  columns: (1fr, cover_divider_line_width, 1fr),
  column-gutter: 1em,
  [
    School of Electronic Engineering and Computer Science
    #v(1fr)

    Final Year

    Undergraduate Project 2022/23

    #image("res/logo.png")
  ],
  line(length: 100%, angle: 90deg, stroke: cover_divider_line_width),
  [
    *Final Report*

    #v(1fr)

    *Programme of study:*

    #programme_of_study

    #v(1fr)

    #text(1.4em)[
      #underline[*Project Title:*]

      *#title*
    ]

    #v(1fr)

    *Supervisor:*

    #supervisor

    #v(1fr)

    *Student Name:*

    #author

    #v(1fr)

    Date: #submission_date
  ],
)

#pagebreak()
