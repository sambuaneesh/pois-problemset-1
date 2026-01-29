#import "../preamble.typ": *
// Problem 21: F(k,x) XOR x is a PRF

= Problem 21:  PRF XORed with Input <p21>

#difficulty("Intermediate") #tag("Design") #tag("Feistel")

#scenario-box("The Self-Masking Function")[
  *Intel Report:* We found a crypto function that "masks itself". It takes input $x$, computes a secret function $F(x)$, and then mixes $x$ back in: $H(x) = F(x) xor x$.

  *Your Mission:* Determine if leaking the input $x$ into the output destroys the security of $F$. Is this safe, or does it leak information?
]

#v(1em)

#align(center)[
  #block(stroke: 1pt + rgb("#2c5282"), inset: 10pt, radius: 5pt, fill: rgb("#ebf8ff"))[
    *Visualizing the Construction (Feistel-like)*
    #v(0.5em)
    #grid(
      columns: (auto, auto, auto),
      column-gutter: 15pt,
      align: center + horizon,
      [Input $x$], [], [],
      [$arrow.b$], [], [],
      [#circle(radius: 4pt, fill: black)], [$arrow.r$], [PRF $F_k$],
      [$arrow.b$], [], [$arrow.b$],
      [$plus.o$], [$arrow.l$], [Result],

      [$arrow.b$], [], [],
      [Output], [], []
    )
  ]
]

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Task:* Let $cal(F) : {0,1}^n times {0,1}^n -> {0,1}^n$ be a PRF #link(<prf>)[(Appendix C.6)]. Prove that $cal(H)(k, x) = cal(F)(k, x) xor x$ is also a PRF.
]

#v(0.8em)

== Understanding the Construction

$cal(H)$ takes the PRF output and XORs it with the input:
$ cal(H)_k (x) = cal(F)_k (x) xor x $

*Question:* Does XORing with the input preserve pseudorandomness?

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: YES, $cal(H)$ is a PRF.*
]

#v(0.8em)

== Proof by Reduction

*Claim:* If $cal(F)$ is a PRF, then $cal(H)$ is also a PRF.

*Proof:* We show that any distinguisher $D_H$ for $cal(H)$ can be converted into a distinguisher $D_F$ for $cal(F)$ with the same advantage.

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Reduction $D_F$ with oracle access to $O$ (either $cal(F)_k$ or random $R$):*
  
  1. When $D_H$ queries $x$:
     - Query $O(x)$ to get $y$
     - Return $y xor x$ to $D_H$
  2. Output whatever $D_H$ outputs
]

#v(0.8em)

=== Analysis of the Reduction

*Case 1: $O = cal(F)_k$ (real PRF)*

$D_F$ returns $cal(F)_k (x) xor x = cal(H)_k (x)$ to $D_H$.

This perfectly simulates $cal(H)_k$ for $D_H$.

$ Pr[D_F^(cal(F)_k) = 1] = Pr[D_H^(cal(H)_k) = 1] $

*Case 2: $O = R$ (random function)*

$D_F$ returns $R(x) xor x$ to $D_H$.

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key observation:* If $R : {0,1}^n -> {0,1}^n$ is a truly random function, then $R'(x) := R(x) xor x$ is *also* a truly random function!
  
  *Why:* For any fixed $x$, the value $R(x)$ is uniformly random in ${0,1}^n$. Therefore:
  $ R(x) xor x "is also uniformly random in" {0,1}^n $
  
  Moreover, for different inputs $x != x'$:
  - $R(x)$ and $R(x')$ are independent (by definition of random function)
  - Therefore $R(x) xor x$ and $R(x') xor x'$ are also independent
]

So $D_H$'s view when $O = R$ is exactly what it would see when given oracle access to a truly random function.

$ Pr[D_F^R = 1] = Pr[D_H^(R') = 1] $

where $R'$ is a truly random function.

#v(0.8em)

=== Completing the Proof

By the above analysis:

$ "Adv"_"PRF"^cal(F) (D_F) &= |Pr[D_F^(cal(F)_k) = 1] - Pr[D_F^R = 1]| \
&= |Pr[D_H^(cal(H)_k) = 1] - Pr[D_H^(R') = 1]| \
&= "Adv"_"PRF"^cal(H) (D_H) $

Since $cal(F)$ is a PRF:
$ "Adv"_"PRF"^cal(H) (D_H) = "Adv"_"PRF"^cal(F) (D_F) <= "negl"(n) $

Therefore $cal(H)$ is also a PRF. $square$

#v(0.8em)

== Why This Works (Intuition)

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *XOR with a known value preserves randomness:*
  
  If $Y$ is uniformly random in ${0,1}^n$ and $x$ is any fixed value, then $Y xor x$ is also uniformly random in ${0,1}^n$.
  
  *Proof:* The function $y |-> y xor x$ is a bijection on ${0,1}^n$. Applying a bijection to a uniform distribution gives a uniform distribution.
  
  *Contrast with Problem 19:* There, we XORed *two PRF outputs* (introducing algebraic structure: $cal(F)(x) xor cal(F)(x) = 0$). Here, we XOR with the *input*, which doesn't create any such structure.
]

#v(0.8em)

== Summary

#align(center)[
#table(
  columns: (1fr, auto),
  inset: 10pt,
  align: left,
  fill: (_, row) => if row == 0 { rgb("#1a365d") } else if calc.rem(row, 2) == 0 { rgb("#f7fafc") } else { white },
  table.header(
    [#text(fill: white)[*Construction*]], 
    [#text(fill: white)[*PRF?*]]
  ),
  [$cal(G)(k, (x,y)) = cal(F)(k, x) xor cal(F)(k, y)$], [#text(fill: rgb("#d9534f"))[*NO*] (Problem 19)],
  [$cal(H)(k, x) = cal(F)(k, x) xor x$], [#text(fill: rgb("#4CAF50"))[*YES*] (This problem)],
)
]

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key difference:* XORing PRF outputs together creates exploitable algebraic relations. XORing a PRF output with its input just applies a bijection, preserving pseudorandomness.
]

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: Structure Preservation]
  #v(0.3em)
  
  *The Core Concept:* A "permutation" (bijection) shuffles probability mass without destroying uniformity.
  
  - If $Y$ is uniform, then $pi(Y)$ is uniform.
  - Here, the map $y |-> y xor x$ is a bijection (specifically, a permutation of ${0,1}^n$).
  
  *Why this matters:* We often "mask" values in crypto using this principle.
  - $"Enc"(m) = k xor m$ (One-Time Pad) uses the same principle: $m |-> m xor k$ is a bijection for fixed $k$.
  - This construction shows that "masking with the input" is safe *if* you already have a random function of that input!
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: The Even-Mansour Cipher]
  #v(0.3em)
  
  This structure looks very similar to block cipher constructions:
  
  - *Even-Mansour:* $E(x) = P(x xor k_1) xor k_2$
  - *Feistel Networks:* $L_{i+1} = R_i; R_{i+1} = L_i xor F(R_i)$ — XORing function output with other half!
  
  *Connections:*
  - #link(<p19>)[*P19 (XOR PRF):*] Shows the danger of XORing *outputs* ($F(x) xor F(x)$ cancels).
  - #link(<p04>)[*P4 (Substitution):*] Shows that composing simple permutations doesn't always add security.
  - #link(<p12>)[*P12 (PRF Const):*] Shows how to build larger PRFs from smaller ones.
]
