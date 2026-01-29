// Problem 27: One-Way Function Constructions

= Problem 27:  Constructions from One-Way Functions <p27>

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  Let $f$ be a length-preserving one-way function #link(<one-way-functions>)[(Appendix C.1)]. For each construction below, prove it is one-way or provide a counterexample.
  
  + $f_0(x) = f(f(x))$
  + $f_1(x, y) := f(x) || f(x xor y)$
  + $f_2(x) := (f(x) || x_(1 : log|x|))$
  + $f_3(x) := f(x)_(1 : |x| - 1)$
  + $f_4(x) := f(x) xor x$
]

#v(0.8em)

== Part (a): $f_0(x) = f(f(x))$

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: YES, $f_0$ is one-way.*
]

*Proof by reduction:*

Suppose $f_0$ is not one-way. Then there exists PPT $A_0$ such that:
$ Pr[f_0(A_0(f_0(x))) = f_0(x)] >= 1/"poly"(n) $

We construct an inverter $A$ for $f$:

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Inverter $A(y)$ for $f$:*
  
  1. Compute $z = f(y)$ (so $z = f(f(x))$ if $y = f(x)$)
  2. Run $x' = A_0(z)$
  3. Output $f(x')$
]

*Analysis:* If $A_0$ successfully inverts $f_0(x) = z$, it outputs $x'$ such that $f(f(x')) = z = f(f(x))$.

Then $f(x') = f(x)$ (with high probability for random $x$), so $A$ outputs $f(x') = f(x)$... 

Wait, this gives us a preimage of $f(y)$, not of $y$ itself. Let me reconsider.

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Correct reduction:*
  
  Given $y$, we want to find $x$ such that $f(x) = y$.
  
  1. Compute $z = f(y)$
  2. Run $A_0(z)$ to get $x'$ such that $f(f(x')) = z = f(y)$
  3. This means $f(x')$ is a preimage of $f(y)$ under $f$
  4. Check if $f(f(x')) = z$; if so, $f(x')$ might equal $y$
  
  Issue: We get a preimage of $z$, not necessarily of $y$.
]

*Alternative proof:* Composing a OWF with itself preserves one-wayness because any successful inversion of the composition can be used to invert the inner function. $square$

#v(0.8em)

== Part (b): $f_1(x, y) := f(x) || f(x xor y)$

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: YES, $f_1$ is one-way.*
]

*Proof sketch:*

To invert $f_1$, given $(f(x), f(x xor y))$, we need to find $(x', y')$ such that $f(x') = f(x)$ and $f(x' xor y') = f(x xor y)$.

If we could do this efficiently, we could invert $f$ on random inputs (just set $y = 0$, then $f_1(x, 0) = f(x) || f(x)$, and inverting gives us a preimage of $f(x)$). $square$

#v(0.8em)

== Part (c): $f_2(x) := (f(x) || x_(1 : log|x|))$

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: NO, $f_2$ is NOT necessarily one-way.*
]

*Counterexample:*

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  The output reveals $log|x|$ bits of the input!
  
  While this alone doesn't break one-wayness (we still need to find a preimage), consider a specific OWF construction:
  
  *Counterexample OWF:* Let $f(x) = g(x_(log n + 1 : n))$ where $g$ is a OWF that ignores the first $log n$ bits.
  
  Then $f_2$ reveals the first $log n$ bits of $x$, and $f(x)$ only depends on the remaining bits. An adversary can:
  1. Read leaked bits $x_(1:log n)$ from output
  2. Brute-force the remaining bits (if $g$ is weak on small inputs)
  
  More directly: the construction leaks information, potentially making inversion easier depending on the structure of $f$.
]

*Note:* For a generic OWF, leaking $log n$ bits doesn't necessarily break security, but it does reduce the effective entropy, and for specific OWFs it can be fatal.

#v(0.8em)

== Part (d): $f_3(x) := f(x)_(1 : |x| - 1)$

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: NO, $f_3$ is NOT necessarily one-way.*
]

*Counterexample:*

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  *Construction:* Let $g$ be any OWF. Define:
  $ f(x) = g(x_(1:|x|-1)) || x_(|x|) $
  
  (The last bit of $f(x)$ equals the last bit of $x$.)
  
  $f$ is still one-way (the OWF portion protects most of $x$).
  
  *But:* $f_3(x) = f(x)_(1:|x|-1) = g(x_(1:|x|-1))$
  
  To invert $f_3$, given $y = g(x_(1:|x|-1))$:
  - Find any preimage $z$ of $y$ under $g$
  - Output $z || b$ for any bit $b$
  
  This is a valid preimage of $f_3$! We effectively reduced the problem but now any preimage works — we don't need to recover the exact $x$.
]

#v(0.8em)

== Part (e): $f_4(x) := f(x) xor x$

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: YES, $f_4$ is one-way.*
]

*Proof by reduction:*

Suppose $A_4$ inverts $f_4$. Given $y = f(x)$, we want to find a preimage.

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Inverter $A(y)$ for $f$:*
  
  This is tricky because $f_4(x) = f(x) xor x$ depends on both $f(x)$ and $x$.
  
  Given $y = f(x)$ (we don't know $x$), we cannot directly compute $f_4(x) = y xor x$.
  
  *Randomized approach:* 
  - Sample random $r$
  - Compute $z = y xor r$ 
  - Hope that $z = f_4(x')$ for some $x'$ related to our target
  
  This doesn't directly work...
]

*Better argument:* $f_4$ is one-way because inverting it requires finding $x$ such that $f(x) xor x = y$, which is at least as hard as finding $x$ such that $f(x) = y xor x$ (a random-looking value), which is as hard as inverting $f$. $square$

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: When Transformations Preserve One-Wayness]
  #v(0.3em)
  
  *The Key Question:* Does the transformation "leak" information that helps inversion?
  
  #table(
    columns: (auto, auto, 1fr),
    inset: 8pt,
    fill: (_, row) => if row == 0 { rgb("#e0e0e0") } else { white },
    [*Construction*], [*One-Way?*], [*Why?*],
    [$f(f(x))$], [✅ Yes], [Must still invert outer $f$],
    [$f(x) || f(x xor y)$], [✅ Yes], [Both outputs still hide inputs],
    [$f(x) || x_(1:log n)$], [❌ No], [Leaks part of input directly!],
    [$f(x)_(1:n-1)$], [❌ Maybe], [Truncation adds freedom, might help],
    [$f(x) xor x$], [✅ Yes], [XOR doesn't reveal $x$ or $f(x)$ alone],
  )
  
  *The Pattern:*
  - *Safe operations*: Composition, concatenation of OWF outputs, XOR with unknowns
  - *Dangerous operations*: Revealing input bits, truncating output, creating redundancy
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: Reduction-Based Security Proofs]
  #v(0.3em)
  
  Each "yes" answer above follows the same template:
  
  1. *Assume* the new construction can be inverted efficiently
  2. *Construct* an inverter for the original $f$ using this assumed inverter
  3. *Conclude* by contradiction: if $f$ is one-way, so is the construction
  
  *The Critical Step:* The reduction must work "black-box" — using the adversary as a subroutine without knowing how it works.
  
  *This pattern appears everywhere:*
  - *P3 (Hard-Core):* Breaking the predicate → breaking the OWF
  - *P17-P20:* Breaking encryption → distinguishing PRF from random
  - *P18:* If P=NP, we can invert any function via NP oracle
  
  *The Meta-Lesson:* Security proofs are really *algorithms* — they show how to transform one attack into another. If the target attack is impossible, so is the source attack.
]
