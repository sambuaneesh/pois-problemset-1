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
// VISUAL ENHANCEMENT HELPERS
// ============================================================================

// Theorem box - for key theorems and lemmas
#let theorem-box(title, content) = {
  block(
    fill: rgb("#e8f4fc"),
    stroke: (left: 3pt + rgb("#3182ce")),
    inset: 12pt,
    radius: (right: 4pt),
    width: 100%,
  )[
    #text(weight: "bold", fill: rgb("#1a365d"))[📐 #title]
    #v(0.3em)
    #content
  ]
}

// Definition box - for formal definitions
#let definition-box(title, content) = {
  block(
    fill: rgb("#e8f5e9"),
    stroke: (left: 3pt + rgb("#43a047")),
    inset: 12pt,
    radius: (right: 4pt),
    width: 100%,
  )[
    #text(weight: "bold", fill: rgb("#2e7d32"))[📖 #title]
    #v(0.3em)
    #content
  ]
}

// Warning/Attack box - for security attacks and warnings
#let attack-box(title, content) = {
  block(
    fill: rgb("#ffebee"),
    stroke: (left: 3pt + rgb("#e53935")),
    inset: 12pt,
    radius: (right: 4pt),
    width: 100%,
  )[
    #text(weight: "bold", fill: rgb("#c62828"))[⚠️ #title]
    #v(0.3em)
    #content
  ]
}

// Insight box - for key insights
#let insight-box(content) = {
  block(
    fill: rgb("#fff8e1"),
    stroke: (left: 3pt + rgb("#ffa000")),
    inset: 12pt,
    radius: (right: 4pt),
    width: 100%,
  )[
    #text(weight: "bold", fill: rgb("#e65100"))[💡 Key Insight]
    #v(0.3em)
    #content
  ]
}

// Answer/Result box - for final answers
#let answer-box(content) = {
  block(
    fill: rgb("#e8f5e9"),
    stroke: 1pt + rgb("#43a047"),
    inset: 12pt,
    radius: 4pt,
    width: 100%,
  )[
    #text(weight: "bold", fill: rgb("#2e7d32"))[✅ Answer]
    #v(0.3em)
    #content
  ]
}

// Quick reference card
#let quick-ref(title, items) = {
  block(
    fill: rgb("#f5f5f5"),
    stroke: 1pt + rgb("#9e9e9e"),
    inset: 12pt,
    radius: 4pt,
    width: 100%,
  )[
    #text(weight: "bold", size: 11pt)[📋 #title]
    #v(0.3em)
    #items
  ]
}

// Security status indicators
#let secure = text(fill: rgb("#43a047"), weight: "bold")[✅ SECURE]
#let insecure = text(fill: rgb("#e53935"), weight: "bold")[❌ INSECURE]
#let partial = text(fill: rgb("#fb8c00"), weight: "bold")[⚠️ PARTIAL]


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

