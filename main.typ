// POIS Problem Set I - Main Entry Point
// This is the file to compile: typst compile main.typ
// Or watch: typst watch main.typ

// ============================================================================
// DOCUMENT SETUP & STYLING
// ============================================================================

#set document(title: "POIS Problem Set I - Answers", author: "")
#set page(margin: (x: 2cm, y: 1.8cm), numbering: "1", number-align: center)
#set text(font: "New Computer Modern", size: 11pt)
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.65em)

// Custom styling for level-1 headings (Problems)
#show heading.where(level: 1): it => {
  v(0.5em)
  block(width: 100%)[
    #set text(size: 14pt, weight: "bold", fill: rgb("#1a365d"))
    #it.body
    #v(0.3em)
    #line(length: 100%, stroke: 0.8pt + rgb("#3182ce"))
  ]
  v(0.5em)
}

// Custom styling for level-2 headings (Parts)
#show heading.where(level: 2): it => {
  v(0.8em)
  block[
    #set text(size: 12pt, weight: "bold", fill: rgb("#2d3748"))
    #it.body
  ]
  v(0.4em)
}

// ============================================================================
// HELPER FUNCTIONS (available to all included files)
// ============================================================================

// Problem separator function
#let problem-separator() = {
  v(1.5em)
  align(center)[
    #box(width: 80%)[
      #align(center)[
        #text(fill: rgb("#a0aec0"))[◆ ◆ ◆]
      ]
    ]
  ]
  v(1em)
}

// Prerequisite reference helper - creates a small linked reference to appendix
#let prereq(label-name, display-text) = {
  text(size: 9pt, fill: rgb("#3182ce"))[
    #link(label(label-name))[[↗ #display-text]]
  ]
}

// ============================================================================
// TITLE PAGE
// ============================================================================

#align(center)[
  #block(
    fill: gradient.linear(rgb("#1a365d"), rgb("#2c5282"), angle: 90deg),
    inset: 20pt,
    radius: 8pt,
    width: 100%,
  )[
    #text(size: 20pt, weight: "bold", fill: white)[Principles of Information Security]
    #v(0.3em)
    #text(size: 14pt, fill: rgb("#bee3f8"))[Problem Set - I | Answer Book]
  ]
]

#v(1.5em)

// ============================================================================
// PROBLEMS - Add new problems here by including their files
// ============================================================================

#include "problems/p01-security-obscurity.typ"

#problem-separator()

#include "problems/p02-perfect-prg.typ"

#problem-separator()

#include "problems/p03-hardcore-dlp.typ"

#problem-separator()

#include "problems/p04-modified-substitution.typ"

#problem-separator()

#include "problems/p05-cpa-attacks.typ"

#problem-separator()

#include "problems/p06-negligible.typ"

#problem-separator()

#include "problems/p07-weak-primes-dlp.typ"

#problem-separator()

#include "problems/p08-key-distribution.typ"

#problem-separator()

#include "problems/p09-prg-constructions.typ"

#problem-separator()

#include "problems/p10-2time-security.typ"

#problem-separator()

#include "problems/p11-variable-length.typ"

#problem-separator()

#include "problems/p12-prf-constructions.typ"

#problem-separator()

#include "problems/p13-counter-mode.typ"

#problem-separator()

#include "problems/p14-hardcore-predicates.typ"

#problem-separator()

#include "problems/p15-polynomial-cpa.typ"

#problem-separator()

#include "problems/p16-crypto-constructions.typ"

#problem-separator()

#include "problems/p17-eav-cpa-security.typ"

#problem-separator()

#include "problems/p18-p-np-owf.typ"

// ============================================================================
// To add a new problem:
//   1. Read: .agent/appendix-registry.md (check existing concepts)
//   2. Create: problems/pXX-new-problem.typ with the problem content
//   3. Add here:
//        #problem-separator()
//        #include "problems/pXX-new-problem.typ"
//   4. Update appendix-registry.md if new concepts added
// ============================================================================

#pagebreak()

// Appendix with prerequisite concepts
#include "appendix.typ"

