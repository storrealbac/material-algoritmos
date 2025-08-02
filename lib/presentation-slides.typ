#import "polylux-compat.typ": *

#let _presentation-outer-margin = 3mm
#let _presentation-inner-margin = 11mm
#let _presentation-top-margin = 10mm
#let _presentation-bottom-margin = 11mm

#let presentation-green = rgb(0, 150, 130)
#let presentation-blue = rgb(70, 100, 170)
#let green = presentation-green
#let blue = presentation-blue
#let black70 = rgb(64, 64, 64)
#let brown = rgb(167, 130, 46)
#let purple = rgb(163, 16, 124)
#let cyan = rgb(35, 161, 224)
#let lime = rgb(140, 182, 60)
#let yellow = rgb(252, 229, 0)
#let orange = rgb(223, 155, 27)
#let red = rgb(162, 34, 35)

#let presentation-title = state("presentation-title", [])
#let presentation-subtitle = state("presentation-subtitle", [])
#let presentation-institute = state("presentation-institute", [])
#let presentation-show-page-count = state("presentation-show-page-count", false)

//=================
// Helper functions
//=================

#let presentation-rounded-block(radius: 3mm, body) = {
  block(
    stroke: 0pt,
    // Workaround for https://github.com/typst/typst/issues/2533
    radius: (
      top-right: radius,
      bottom-left: radius,
    ),
    clip: true,
    body,
  )
}

#let presentation-list-marker = move(dy: 0.125em, presentation-rounded-block(
    radius: 0.15em,
    rect(
      // The latex documentclass uses a size of 1ex, but type only supports em.
      width: 0.5em,
      height: 0.5em,
      fill: presentation-green,
    ),
  ))

#let presentation-theme(
  title: none,
  subtitle: none,
  short-title: none,
  institute: none,
  date: none,
  aspect-ratio: "16-9",
  show-page-count: false,
  body,
) = {

  // Use power point page sizes, as they differ from default typst page sizes.
  set page(width: 25.4cm, height: 14.29cm, margin: 0pt)
  set text(font: ("Roboto", "Ubuntu Sans", "DejaVu Sans"))
  set list(marker: presentation-list-marker)

  presentation-title.update(title)
  presentation-subtitle.update(subtitle)
  
  presentation-institute.update(institute)
  presentation-show-page-count.update(show-page-count)

  body
}

#let title-slide() = {
  show: polylux-slide

  // Top half
  pad(left: _presentation-inner-margin, right: 0mm, top: _presentation-top-margin)[
    // presentation logo
    #place(right, dy: 30mm, dx: -5mm)[
      #image("../assets/presentation/logo.png", width: 110mm)
    ]

    #place(dy: 20mm, text(weight: "bold", size: 45pt, text(blue,"Algoritmos y complejidad")))
    
    #place(dy: 50mm, text(weight: "bold", size: 30pt, context presentation-title.get()))
    
    // Subtitle
    #place(dy: 70mm)[
      #set text(size: 16pt, fill: rgb("#6b7280"))
      #set par(leading: 0.5em)
      #context presentation-subtitle.get()
    ]

    #place(dy: 115mm, dx: 160mm)[
      #text(weight: "bold", size: 17pt, "Sebastián Torrealba")
    ]
  ]
  
  // Asegurar que la slide termine correctamente
  pagebreak(weak: false)
}
#let slide(title: [], body) = {
  show: polylux-slide
  set block(above: 0pt)
  grid(
    rows: (12mm, 1fr, _presentation-bottom-margin),
    // Title bar
    block(width: 100%, height: 20mm, inset: (x: _presentation-inner-margin))[
      #grid(columns: (auto, 1fr))[
        #set text(24pt, weight: "bold")
        // We need a block here to force the grid to take the full height of the surrounding block
        #block(height: 100%)[
          #align(left + bottom, title)
        ]
      ][
        #align(right + bottom)[
          #image("../assets/presentation/inf_utfsm.png", width:60mm)
        ]
      ]
    ],
    // Content block
    block(width: 100%, height: 100%, inset: (x: _presentation-inner-margin, top: 15.5mm))[
      #set text(18pt)
      // Default value, but had to be changed for layout
      #set block(above: 1.2em)
      #body
    ],
    // Footer
    align(bottom, block(width: 100%, inset: (x: _presentation-outer-margin))[
        #set block(above: 0pt)
        #set text(size: 9pt)
        #line(stroke: rgb("#d8d8d8"), length: 100%)
        #block(width: 100%, height: 100%)[
          #align(horizon + center)[
              #context counter(page).display()
          ]
        ]
      ]),
  )
}

#let split-slide(title: [], body-left, body-right) = {
  let body = grid(columns: (1fr, 1fr), gutter: 2em, body-left, body-right)
  slide(title: title, body)
}

#let presentation-color-block(title: [], color: [], body) = {
  // 80% is a rought heuristic, that produces the correct result for all predefined colors.
  // Might be adjusted in the future
  let title-color = if luma(color).components().at(0) >= 80% {
    black
  } else {
    white
  }
  presentation-rounded-block()[
    #block(
      width: 100%,
      inset: (x: 0.5em, top: 0.3em, bottom: 0.4em),
      fill: gradient.linear(
        (color, 0%),
        (color, 87%),
        (color.lighten(85%), 100%),
        dir: ttb,
      ),
      text(fill: title-color, title),
    )
    #set text(size: 15pt)
    #block(inset: 0.5em, above: 0pt, fill: color.lighten(85%), width: 100%, body)
  ]
}

#let presentation-info-block(title: [], body) = {
  presentation-color-block(title: title, color: presentation-green, body)
}

#let presentation-example-block(title: [], body) = {
  presentation-color-block(title: title, color: presentation-blue, body)
}

#let presentation-alert-block(title: [], body) = {
  presentation-color-block(title: title, color: red.lighten(10%), body)
}