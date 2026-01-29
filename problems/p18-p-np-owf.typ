// Problem 18: P ≠ NP and One-Way Functions

= Problem 18: P ≠ NP vs One-Way Functions

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Task:* Show that the existence of one-way functions implies $P != "NP"$. 
  
  Conversely, assume $P != "NP"$. Show that there exists a function $f$ that is:
  - Computable in polynomial time
  - Hard to invert in the *worst case* (i.e., for all PPT algorithms $A$, $Pr_(x arrow.l {0,1}^n) [f(A(f(x))) = f(x)] != 1$)
  
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
  *One-Way Function (OWF):* Requires *average-case* hardness.
  
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
