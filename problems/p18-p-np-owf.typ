#import "../preamble.typ": *
// Problem 18: P ≠ NP and One-Way Functions

= Problem 18:  P ≠ NP vs One-Way Functions <p18>

#difficulty("Advanced") #tag("Theory") #tag("Complexity")

#scenario-box("The Hardness Gap")[
  *Intel Report:* A mathematician proved $P != "NP"$. He claims this means our cryptography is safe forever.

  *Your Mission:* Debunk this. Show that even if some problems are hard in the *worst case*, they might be easy on *average* (breaking crypto).
]

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Task:* Show that the existence of one-way functions #link(<one-way-functions>)[(Appendix C.1)] implies $P != "NP"$ #link(<p-np>)[(Appendix H.1)]. 
  
  Conversely, assume $P != "NP"$. Show that there exists a function $f$ that is:
  - Computable in polynomial time
  - Hard to invert in the *worst case* #link(<hardness>)[(H.3)] (i.e., for all PPT #link(<ppt>)[(H.2)] algorithms $A$, $Pr_(x arrow.l {0,1}^n) [f(A(f(x))) = f(x)] != 1$)
  
  but $f$ is *not* a one-way function.
]

#v(0.8em)

== Part 1: One-Way Functions Imply P ≠ NP

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Claim:* If one-way functions exist, then $P != "NP"$.
]

*Proof by contrapositive:*

Assume $P = "NP"$. We show that no one-way function can exist.

Let $f : {0,1}^n -> {0,1}^*$ be any polynomial-time computable function.

*Define the language:*
$ L_f = {(y, i, b) : exists x "such that" f(x) = y "and the" i"-th bit of" x "is" b} $

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key observation:* $L_f in "NP"$
  
  Given $(y, i, b)$, the witness is $x$ such that $f(x) = y$ and $x_i = b$.
  
  Verification: Check that $f(x) = y$ (polynomial time) and $x_i = b$.
]

If $P = "NP"$, then $L_f in P$. This means we can decide in polynomial time whether there exists a preimage with a specific bit value.

*Inverting $f$ using the P = NP assumption:*

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Inverter $I(y)$:*
  
  For $i = 1$ to $n$:
  1. Query: Is $(y, i, 0) in L_f$?
  2. If yes, set $x_i = 0$
  3. If no, set $x_i = 1$ (assuming a preimage exists)
  
  Output $x = x_1 x_2 ... x_n$
]

This runs in polynomial time and correctly inverts $f$ whenever $y$ has a preimage.

*Conclusion:* If $P = "NP"$, every polynomial-time function can be inverted in polynomial time, so no OWF exists.

By contrapositive: *OWF exists $arrow.r.double$ P ≠ NP*. $square$

#v(1em)

== Part 2: P ≠ NP Does NOT Imply OWF

We now show the converse is *not* true: $P != "NP"$ does not necessarily imply OWFs exist.

=== Understanding the Distinction

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *One-Way Function (OWF)* #link(<one-way-functions>)[(Appendix C.1)]*:* Requires *average-case* hardness.
  
  For all PPT $A$: $Pr_(x arrow.l {0,1}^n)[f(A(f(x))) = f(x)] <= "negl"(n)$
  
  *P ≠ NP:* Only guarantees *worst-case* hardness.
  
  There exists *some* input on which inversion fails.
]

=== Construction of Worst-Case Hard but NOT One-Way Function

Assume $P != "NP"$. Then there exists an NP-complete language $L$ (e.g., SAT).

*Construction:*

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  Define $f : {0,1}^* -> {0,1}^*$ as follows:
  
  For input $x = (phi, w)$ where $phi$ is a Boolean formula and $w$ is a potential witness:
  
  $ f(phi, w) = cases(
    (phi, 1) & "if" w "is a satisfying assignment for" phi,
    (phi, 0) & "otherwise"
  ) $
]

=== Analysis

*$f$ is polynomial-time computable:*

Given $phi$ and $w$, we can check in polynomial time whether $w$ satisfies $phi$ (just evaluate the formula).

*$f$ is worst-case hard to invert:*

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  Consider the output $(phi, 1)$ for a satisfiable formula $phi$.
  
  To invert, we must find a satisfying assignment $w$ for $phi$.
  
  Since $P != "NP"$, there is no polynomial-time algorithm that can find satisfying assignments for *all* satisfiable formulas.
  
  Therefore, $f$ is *worst-case* hard to invert.
]

*$f$ is NOT one-way (fails average-case):*

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  *Attack on average-case:*
  
  For a random input $(phi, w)$:
  - Compute $f(phi, w) = (phi, b)$
  - If $b = 0$: Simply output $(phi, 0^n)$ — this is a valid preimage!
  - If $b = 1$: Output $(phi, w)$ — we already have the witness!
  
  Wait, but we don't know $w$ when inverting...
  
  *Correct analysis:* Given $y = (phi, b)$, we need to find $(phi, w)$ such that $f(phi, w) = y$.
  
  - If $b = 0$: Any $w$ that is NOT a satisfying assignment works. Almost all $w$ are non-satisfying (for random $phi$), so just output $(phi, 0^n)$.
  - If $b = 1$: We need to find a satisfying assignment. This is hard for SOME formulas, but random satisfiable formulas are EASY!
]

*Why random instances are easy:*

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  For a *random* Boolean formula $phi$ (or random instance of an NP problem):
  
  - Most formulas are either trivially unsatisfiable or have many satisfying assignments (easy to find one)
  - The "hard" instances form a negligible fraction of all instances
  - Algorithms like DPLL, WalkSAT, etc., solve random instances efficiently with high probability
  
  Therefore: $Pr_(x arrow.l {0,1}^n)[A "inverts" f(x)] = 1 - "negl"(n)$ for an appropriate $A$
  
  But this is exactly what OWF security forbids!
]

#v(1em)

== Summary

#table(
  columns: (auto, 1fr),
  inset: 10pt,
  align: left,
  fill: (col, _) => if col == 0 { rgb("#e0e0e0") } else { white },
  [*Statement*], [*Status*],
  [OWF exists $arrow.r.double$ P ≠ NP], [TRUE — proven above],
  [P ≠ NP $arrow.r.double$ OWF exists], [UNKNOWN — widely believed but unproven],
)

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key Insight:*
  
  - *P ≠ NP* is about *worst-case* complexity: some instances are hard
  - *OWF* requires *average-case* hardness: random instances must be hard
  
  The gap between worst-case and average-case hardness is fundamental. NP-complete problems can have hard worst-case instances but easy random instances (like SAT).
  
  Whether P ≠ NP implies OWF existence remains one of the deepest open questions in cryptography and complexity theory!
]

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *The constructed $f$:*
  - Poly-time computable ✓
  - Worst-case hard to invert ✓ (follows from P ≠ NP)
  - NOT one-way ✓ (random instances are easy)
  
  This demonstrates that P ≠ NP alone does not give us cryptographic security!
]

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: The Two Kinds of Hardness]
  #v(0.3em)
  
  *This is perhaps the most fundamental distinction in theoretical cryptography:*
  
  #table(
    columns: (1fr, 1fr),
    inset: 10pt,
    fill: (col, _) => if col == 0 { rgb("#e3f2fd") } else { rgb("#ffebee") },
    [*Worst-Case Hard*], [*Average-Case Hard (Crypto)*],
    [Some inputs are hard], [Random inputs are hard],
    [Enough for complexity theory], [Required for cryptography],
    [NP-completeness gives this], [We don't know how to get this from P≠NP],
    [SAT, TSP, 3-coloring], [Factoring, DLP, lattice problems],
  )
  
  *The Intuitive Gap:*
  - *Worst-case:* "There's a needle in this haystack that's impossible to find"
  - *Average-case:* "If you pick a random piece of hay, it LOOKS like a needle — you can't tell them apart"
  
  Cryptography needs the second! If most inputs are easy, an attacker just tries random inputs until one works.
  
  *Real-World Analogy:*
  - *Worst-case locks:* Some locks in the world are unpickable → Not useful for YOUR door
  - *Average-case locks:* A randomly manufactured lock is almost certainly unpickable → Useful!
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: The Hardness Assumptions of Cryptography]
  #v(0.3em)
  
  Modern cryptography is built on *specific* average-case hardness assumptions, not just P≠NP:
  
  - *Factoring:* Given $n = p dot q$, finding $p, q$ is hard on average
  - *DLP (P3, P7):* Given $g^x$, finding $x$ is hard on average
  - *Lattice problems:* Finding short vectors in high-dimensional lattices
  
  *The Research Frontier:*
  - Can we base cryptography on P≠NP alone? (Open problem!)
  - Lattice cryptography: offers worst-case to average-case reductions (closest we have)
  
  *Connections:*
  - *P14 (Hard-Core Predicates):* Extracting bits that are guaranteed hard on average
  - *P27 (OWF Constructions):* Building OWFs while preserving average-case hardness
  - *P26 (Negligibility):* The quantitative definition of "almost always hard"
]
