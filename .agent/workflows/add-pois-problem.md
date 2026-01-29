---
description: How to add a new POIS problem to the answer book
---

# POIS Answer Book - Adding New Problems

This workflow describes how to add new problems to the Principles of Information Security answer book.

## Directory Structure

```
quiz-1/
├── main.typ           ← Main entry point (compile this)
├── appendix.typ       ← Prerequisites & background concepts
└── problems/
    ├── p01-security-obscurity.typ
    ├── p02-perfect-prg.typ
    ├── p03-hardcore-dlp.typ
    ├── p04-modified-substitution.typ
    ├── p05-cpa-attacks.typ
    └── pXX-new-problem.typ   ← New problems go here
```

## Adding a New Problem

### Step 0: Read the Appendix Registry (ALWAYS DO THIS FIRST)
// turbo
```bash
cat /home/stealthspectre/IIITH/POIS/quiz-1/.agent/appendix-registry.md
```

This shows all existing appendix concepts with their labels. Use existing labels when possible; only add new entries if a concept doesn't already exist.

### Step 1: Determine the next problem number
Look at `problems/` directory to find the next available number (e.g., if p06 exists, create p07).

### Step 2: Create the problem file
Create `problems/pXX-short-name.typ` with this structure:

```typst
// Problem XX: [Title]

= Problem XX: [Title]

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Question/Scenario:* [Problem statement here]
]

#v(0.8em)

== Part (a): [Part Title]

*Question:* [Specific question]

*Answer:*

[Answer content with explanations, tables, callout boxes as needed]

// Use these styling patterns:
// - Definition box: #block(fill: rgb("#e8f4e8"), inset: 12pt, radius: 4pt)[...]
// - Info box: #block(fill: rgb("#e3f2fd"), inset: 12pt, radius: 4pt)[...]
// - Warning box: #block(fill: rgb("#fff3e0"), inset: 12pt, radius: 4pt)[...]
// - Key insight: #block(stroke: (left: 2pt + rgb("#4a90d9")), inset: (left: 10pt, y: 5pt))[...]
// - Success/result: #block(stroke: (left: 2pt + rgb("#4CAF50")), ...)[...]
// - Important warning: #block(stroke: (left: 2pt + rgb("#d9534f")), ...)[...]
```

### Step 3: Link to appendix (if needed)
If the problem references concepts that need explanation, use:

```typst
#link(<label-name>)[(see Appendix X.X)]
```

Available appendix labels:
- Classical ciphers: `<shift-cipher>`, `<substitution-cipher>`, `<vigenere-cipher>`
- Number theory: `<dlp>`, `<group-structure>`, `<pohlig-hellman>`
- Crypto concepts: `<one-way-functions>`, `<hard-core-predicates>`, `<prg>`, `<security-notions>`
- Proof techniques: `<reduction>`, `<hybrid-argument>`
- Principles: `<kerckhoffs>`

### Step 4: Update main.typ
Add these lines before the `#pagebreak()` near the end:

```typst
#problem-separator()

#include "problems/pXX-short-name.typ"
```

### Step 5: Update appendix (if new concepts needed)
If the problem introduces new prerequisite concepts, add them to `appendix.typ`:

1. Add a new section with a label:
```typst
== X.Y New Concept Name <new-concept-label>

[Explanation of the concept...]
```

2. **Update the appendix registry** at `.agent/appendix-registry.md` with the new entry

3. Then reference it from the problem file using `#link(<new-concept-label>)[...]`

## Answer Writing Guidelines

1. **Start with a problem box**: Always wrap the question in a gray `luma(245)` block
2. **Structure clearly**: Use `== Part (a):` for sub-questions
3. **Explain prerequisites inline OR link to appendix**: Don't assume knowledge
4. **Use callout boxes**: Highlight key insights, conclusions, and important notes
5. **Include tables**: For comparisons and summaries
6. **Show math clearly**: Use Typst math mode `$ ... $` for equations
7. **End with key takeaway**: Summarize the main insight in a callout box

## Compilation

// turbo
```bash
cd /home/stealthspectre/IIITH/POIS/quiz-1
typst watch main.typ
```

The PDF will auto-regenerate when any included file changes.

## Example: Adding Problem 6

1. Create `problems/p06-example-topic.typ` with content
2. Edit `main.typ` and add before `#pagebreak()`:
   ```typst
   #problem-separator()
   #include "problems/p06-example-topic.typ"
   ```
3. If needed, add new appendix entries in `appendix.typ`
4. Verify compilation with `typst compile main.typ`
