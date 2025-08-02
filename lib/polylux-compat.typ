// Compatibility layer for Polylux functionality
// Minimal implementation for basic slide functionality

#let subslide = counter("subslide")
#let logical-slide = counter("logical-slide")

#let polylux-slide(body) = {
  logical-slide.step()
  subslide.update(1)
  body
}