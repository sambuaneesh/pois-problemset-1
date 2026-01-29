// Visual Enhancement Helpers (Preamble)

// Scenario Box (Mission Briefing)
#let scenario-box(title, content) = {
  block(
    fill: rgb("#2d3748"),
    stroke: (left: 4pt + rgb("#a0aec0")),
    inset: 12pt,
    radius: (right: 4pt),
    width: 100%,
  )[
    #text(weight: "bold", fill: white, font: "DejaVu Sans Mono")[🕵️ MISSION: #title]
    #v(0.5em)
    #text(fill: rgb("#e2e8f0"), font: "DejaVu Sans Mono")[#content]
  ]
}

// Difficulty Badges
#let difficulty(level) = {
  if level == "Beginner" {
    box(fill: rgb("#c6f6d5"), inset: (x: 6pt, y: 3pt), radius: 3pt, stroke: rgb("#2f855a"))[
      #text(size: 9pt, weight: "bold", fill: rgb("#22543d"))[🟢 Beginner]
    ]
  } else if level == "Intermediate" {
    box(fill: rgb("#feebc8"), inset: (x: 6pt, y: 3pt), radius: 3pt, stroke: rgb("#c05621"))[
      #text(size: 9pt, weight: "bold", fill: rgb("#7b341e"))[🟡 Intermediate]
    ]
  } else if level == "Advanced" {
    box(fill: rgb("#fed7d7"), inset: (x: 6pt, y: 3pt), radius: 3pt, stroke: rgb("#c53030"))[
      #text(size: 9pt, weight: "bold", fill: rgb("#822727"))[🔴 Advanced]
    ]
  }
}

// Topic Tags
#let tag(name) = {
  box(fill: rgb("#edf2f7"), inset: (x: 6pt, y: 3pt), radius: 3pt, stroke: rgb("#cbd5e0"))[
    #text(size: 8pt, weight: "bold", fill: rgb("#4a5568"))[\##name]
  ]
}
