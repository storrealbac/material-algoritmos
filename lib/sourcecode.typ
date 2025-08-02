// Simple sourcecode implementation to replace codelst
#let sourcecode(body) = {
  block(
    fill: rgb("#f8f8f8"),
    stroke: rgb("#e0e0e0") + 1pt,
    radius: 4pt,
    inset: 12pt,
    width: 100%,
    {
      set text(font: ("Fira Code", "Ubuntu Mono", "DejaVu Sans Mono"))
      set text(size: 0.85em)
      body
    }
  )
}