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

// Style links with attractive pill-style appearance (preserves clickability)
#show link: it => {
  text(fill: rgb("#2c5282"), weight: "medium", size: 9pt)[
    #box(
      fill: rgb("#e8f4fc"),
      inset: (x: 5pt, y: 2pt),
      radius: 3pt,
      stroke: 0.5pt + rgb("#3182ce"),
    )[#it]
  ]
}

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

// Problem separator - uses pagebreak for each problem
#let problem-separator() = {
  pagebreak()
}

// Prerequisite reference helper - creates a styled linked reference to appendix
#let prereq(label-name, display-text) = {
  box(
    fill: rgb("#f0e6ff"),
    inset: (x: 5pt, y: 2pt),
    radius: 3pt,
  )[
    #set text(size: 9pt, fill: rgb("#6b46c1"))
    #link(label(label-name))[↗ #display-text]
  ]
}

// ============================================================================
// TITLE PAGE
// ============================================================================

#set page(numbering: none)

#v(1fr)

#align(center)[
  #block(
    fill: gradient.linear(rgb("#1a365d"), rgb("#2c5282"), angle: 90deg),
    inset: 30pt,
    radius: 12pt,
    width: 85%,
  )[
    #text(size: 28pt, weight: "bold", fill: white)[Principles of Information Security]
    #v(0.5em)
    #line(length: 60%, stroke: 1pt + rgb("#bee3f8"))
    #v(0.5em)
    #text(size: 16pt, fill: rgb("#bee3f8"))[Problem Set - I]
    #v(0.3em)
    #text(size: 12pt, fill: rgb("#a3d0f0"))[Complete Answer Book]
  ]
  
  #v(2em)
  
  #text(size: 10pt, fill: rgb("#718096"))[28 Problems • Comprehensive Solutions • With Appendix]
  
  #v(1em)
  
  #text(size: 9pt, fill: rgb("#a0aec0"))[Monsoon 2025-26]
]

#v(1fr)

#pagebreak()

// ============================================================================
// TABLE OF CONTENTS
// ============================================================================

#set page(numbering: "1", number-align: center)
#counter(page).update(1)

#align(center)[
  #text(size: 18pt, weight: "bold", fill: rgb("#1a365d"))[Table of Contents]
  #v(0.3em)
  #line(length: 40%, stroke: 0.8pt + rgb("#3182ce"))
]

#v(1em)

#outline(
  title: none,
  indent: 1.5em,
  depth: 1,
)

#pagebreak()

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

#problem-separator()

#include "problems/p19-xor-prf.typ"

#problem-separator()

#include "problems/p20-block-cipher-modes.typ"

#problem-separator()

#include "problems/p21-prf-xor-input.typ"

#problem-separator()

#include "problems/p22-otp-nonzero.typ"

#problem-separator()

#include "problems/p23-cpa-construction.typ"

#problem-separator()

#include "problems/p24-2time-impossible.typ"

#problem-separator()

#include "problems/p25-cbc-stateful.typ"

#problem-separator()

#include "problems/p26-negligibility.typ"

#problem-separator()

#include "problems/p27-owf-constructions.typ"

#problem-separator()

#include "problems/p28-prf-variants.typ"

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

