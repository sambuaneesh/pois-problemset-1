// Problem 9: PRG Constructions

= Problem 9:  PRG or Not? <p09>

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Setup:* Let $G : {0,1}^(2n) -> {0,1}^(2n+1)$ be a pseudorandom generator (PRG) #link(<prg>)[(see Appendix C.3)]. For each construction below, determine whether $G' : {0,1}^(2n) -> {0,1}^(2n+1)$ is necessarily a PRG, regardless of which PRG $G$ is used.
]

#v(0.8em)

== Background: PRG Definition

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  A function $G : {0,1}^n -> {0,1}^(ell(n))$ with $ell(n) > n$ is a *PRG* if for all PPT distinguishers $D$:
  $ |Pr[D(G(U_n)) = 1] - Pr[D(U_(ell(n))) = 1]| <= "negl"(n) $
  
  where $U_k$ denotes the uniform distribution over ${0,1}^k$.
]

#v(1em)

== Part (a): $G'(x) := G(pi(x))$ where $pi$ is a Bijection

*Construction:* $pi : {0,1}^(2n) -> {0,1}^(2n)$ is a poly$(n)$-time computable bijection, but $pi^(-1)$ may NOT be poly-time computable.

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: YES, $G'$ is a PRG.*
]

*Proof by reduction:*

Suppose $G'$ is not a PRG. Then there exists a PPT distinguisher $D$ such that:
$ |Pr[D(G'(U_(2n))) = 1] - Pr[D(U_(2n+1)) = 1]| > "non-negl"(n) $

But $G'(U_(2n)) = G(pi(U_(2n)))$.

*Key observation:* Since $pi$ is a bijection, $pi(U_(2n))$ is *also* uniformly distributed over ${0,1}^(2n)$!

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Why?* A bijection is a one-to-one correspondence. When the input is uniform, each output value is hit by exactly one input, so the output is also uniform.
  
  Formally: For any $y in {0,1}^(2n)$:
  $ Pr[pi(U_(2n)) = y] = Pr[U_(2n) = pi^(-1)(y)] = 1/(2^(2n)) $
]

Therefore:
$ G'(U_(2n)) = G(pi(U_(2n))) equiv G(U_(2n)) $

So if $D$ distinguishes $G'(U_(2n))$ from $U_(2n+1)$, then $D$ also distinguishes $G(U_(2n))$ from $U_(2n+1)$.

This contradicts that $G$ is a PRG. $square$

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Note:* We don't need $pi^(-1)$ to be efficiently computable. The reduction only uses $pi$ in the forward direction, and the analysis only uses that $pi$ is a bijection.
]

#v(1em)

== Part (b): $G'(x || y) := G(x || (x xor y))$ where $|x| = |y| = n$

*Construction:* Split the $2n$-bit seed into two $n$-bit halves, then apply $G$ to $x || (x xor y)$.

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: YES, $G'$ is a PRG.*
]

*Proof:*

Define the mapping $phi : {0,1}^(2n) -> {0,1}^(2n)$ by:
$ phi(x || y) = x || (x xor y) $

*Claim:* $phi$ is a bijection.

*Proof of claim:* The inverse is:
$ phi^(-1)(a || b) = a || (a xor b) $

Check: $phi^(-1)(phi(x || y)) = phi^(-1)(x || (x xor y)) = x || (x xor (x xor y)) = x || y$ $checkmark$

Since $phi$ is a bijection, by the same argument as Part (a):
$ G'(U_(2n)) = G(phi(U_(2n))) equiv G(U_(2n)) $

Therefore $G'$ is a PRG. $square$

#v(1em)

== Part (c): $G'(x || y) := G(x || 0^n) xor G(0^n || y)$ where $|x| = |y| = n$

*Construction:* Evaluate $G$ on two different inputs and XOR the results.

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: NO, $G'$ is NOT necessarily a PRG.*
]

*Counterexample:*

Let $G$ be *any* PRG. Define a new PRG $hat(G)$ by:
$ hat(G)(s) = G(s) xor (s || 0) $

Note: $hat(G)$ is still a PRG because XORing with a fixed function of the seed doesn't help a distinguisher (the seed is unknown).

Now apply the $G'$ construction to $hat(G)$:

$ G'(x || y) &= hat(G)(x || 0^n) xor hat(G)(0^n || y) \
&= [G(x || 0^n) xor (x || 0^n || 0)] xor [G(0^n || y) xor (0^n || y || 0)] $

The XOR of the "extra" terms produces:
$ (x || 0^(n+1)) xor (0^n || y || 0) = (x || y || 0) $

#block(
  fill: rgb("#fff3e0"),
  inset: 12pt,
  radius: 4pt,
)[
  *Problem:* The output $G'(x || y)$ now contains $(x || y || 0)$ XORed in!
  
  A distinguisher can:
  1. Receive output $z in {0,1}^(2n+1)$
  2. Check if the last bit is $0$
  3. Real PRG output: last bit is always $0$ → biased!
  4. Random string: last bit is $0$ with probability $1/2$
]

More directly: For any $x, y$, the last bit of $G'(x || y)$ equals:

$ "last bit of" G(x||0^n) xor "last bit of" G(0^n||y) xor 0 $

But we can construct $hat(G)$ so this is always $0$, breaking pseudorandomness.

*Simpler counterexample:* Let $G(s) = s || ("parity of" s)$.

Then $G(x || 0^n) xor G(0^n || y)$ has predictable structure. $square$

#v(1em)

== Part (d): $G'(x || y) := G(x || y) xor (x || 0^(n+1))$ where $|x| = |y| = n$

*Construction:* XOR the PRG output with the first half of the seed (padded with zeros).

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: NO, $G'$ is NOT necessarily a PRG.*
]

*Counterexample:*

Define a valid PRG $G$ as follows. Let $H$ be any PRG with the same parameters. Define:
$ G(x || y) = H(x || y) xor (x || 0^(n+1)) $

Since $H$ is a PRG and XORing with a function of the seed doesn't help distinguish (the adversary doesn't know the seed), $G$ is also a PRG.

Now compute $G'$:
$ G'(x || y) &= G(x || y) xor (x || 0^(n+1)) \
&= [H(x || y) xor (x || 0^(n+1))] xor (x || 0^(n+1)) \
&= H(x || y) $

Wait, this gives us back $H$, which IS a PRG. Let me reconsider...

*Correct counterexample:*

Let $G(s) = s || "MSB"(s)$ where $s in {0,1}^(2n)$ and MSB is the most significant bit.

This is a valid PRG (the output $s || "MSB"(s)$ is pseudorandom when $s$ is random).

Now:
$ G'(x || y) = G(x || y) xor (x || 0^(n+1)) = (x || y || "MSB"(x||y)) xor (x || 0^(n+1)) $

$ = (x xor x) || (y || "MSB"(x||y)) xor (0^(n+1)) = 0^n || y || "MSB"(x||y) $

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  *The first $n$ bits of $G'(x || y)$ are always $0^n$!*
  
  A distinguisher simply checks if the first $n$ bits are all zeros:
  - Real $G'$ output: always yes
  - Random $(2n+1)$-bit string: probability $1/(2^n)$
]

This is easily distinguishable. $square$

#v(1em)

== Summary Table

#align(center)[
#table(
  columns: (auto, 1fr, auto),
  inset: 10pt,
  align: (center, left, center),
  fill: (_, row) => if row == 0 { rgb("#1a365d") } else if calc.rem(row, 2) == 0 { rgb("#f7fafc") } else { white },
  table.header(
    [#text(fill: white)[*Part*]], 
    [#text(fill: white)[*Construction*]], 
    [#text(fill: white)[*PRG?*]]
  ),
  [(a)], [$G'(x) = G(pi(x))$, $pi$ bijection], [#text(fill: rgb("#4CAF50"))[*YES* $checkmark$]],
  [(b)], [$G'(x||y) = G(x || (x xor y))$], [#text(fill: rgb("#4CAF50"))[*YES* $checkmark$]],
  [(c)], [$G'(x||y) = G(x||0^n) xor G(0^n||y)$], [#text(fill: rgb("#d9534f"))[*NO* ✗]],
  [(d)], [$G'(x||y) = G(x||y) xor (x||0^(n+1))$], [#text(fill: rgb("#d9534f"))[*NO* ✗]],
)
]

#v(0.5em)

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key Insights:*
  
  - *Bijections preserve uniformity:* Composing with a bijection maintains pseudorandomness (parts a, b)
  - *XORing parts of seed into output is dangerous:* Can create predictable patterns (part d)
  - *Combining PRG evaluations:* XORing outputs of the *same* PRG on related inputs can leak structure (part c)
]

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: Rigorous Definitions Save Us]
  #v(0.3em)
  
  *The Core Lesson:* Intuition ("it looks random") is terrible at cryptography.
  - Part (c) *looks* complex (XORing two PRG outputs), but fails completely.
  - Part (d) *looks* like a one-time pad, but applying it to the seed itself reveals the structure.
  
  *The Distinguisher Game:*
  Think of a distinguisher as a "pattern detector."
  - "If I see a 0 at the end, I shout FAKE." (Part c)
  - "If the first $n$ bits are 0, I shout FAKE." (Part d)
  
  *Robust Design:* A secure construction must pass *every possible* statistical test. We prove this by *reduction*: "If you can distinguish $G'$, you can distinguish $G$."
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: Input Manipulation Attacks]
  #v(0.3em)
  
  Attacks often come from manipulating inputs to cancel out security guarantees:
  
  - *Part (c):* $0^n$ padding aligned perfectly to cancel out.
  - *Part (d):* XORing the seed cancels the pseudorandomness derived *from* that seed.
  
  *Connections:*
  - #link(<p05>)[*P5 (CPA):*] Attacker chooses messages to create recognizable ciphertexts.
  - #link(<p19>)[*P19 (XOR PRF):*] Input $(x, x)$ causes output cancellation ($0$).
  - #link(<p21>)[*P21 (Input XOR):*] Correlated inputs enable attacks.
  
  *The takeaway:* Never let an attacker control inputs that are algebraically related to the key or internal state!
]
