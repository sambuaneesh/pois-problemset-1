// Problem 3: Hard-Core Predicates for DLP

= Problem 3: Hard-Core Predicates for DLP

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Context:* Consider the Discrete Logarithm Problem (DLP) #link(<dlp>)[(see Appendix B.1)] with one-way function $f(x) = g^x mod p$ in $ZZ_p^*$ for a prime $p$, where $(p-1) = s dot 2^r$ for some odd $s$ #link(<group-structure>)[(see Appendix B.2)].
  
  *Tasks:*
  + Prove the MSB (most significant bit) is a hard-core predicate for DLP
  + Prove the $(r+1)^"th"$ LSB is a hard-core predicate
  + Design a provably secure PRG assuming DLP is hard in $ZZ_p^*$
]

#v(0.8em)

== Background: Hard-Core Predicates

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Definition:* A predicate $B : X -> {0,1}$ is *hard-core* for a one-way function $f$ if:
  - $B(x)$ is efficiently computable given $x$
  - Given only $f(x)$, no efficient algorithm can predict $B(x)$ with probability significantly better than $1/2$
  
  Formally: For all PPT adversaries $A$:
  $ Pr[A(f(x)) = B(x)] <= 1/2 + "negl"(n) $
]

For DLP: Given $y = g^x mod p$, hard-core predicates are bits of $x$ that cannot be efficiently computed from $y$.

#v(1em)

== Part (a): MSB is Hard-Core for DLP

*Claim:* The most significant bit of $x$ is a hard-core predicate for $f(x) = g^x mod p$.

*Proof by Reduction:*

Suppose there exists an efficient algorithm $A$ that, given $y = g^x mod p$, predicts $"MSB"(x)$ with advantage $epsilon > "negl"(n)$:
$ Pr[A(g^x) = "MSB"(x)] >= 1/2 + epsilon $

We show this would break DLP:

*Step 1: Relating MSB to magnitude*

For $x in {0, 1, ..., p-2}$ (the valid range of discrete logs):
$ "MSB"(x) = cases(
  0 "if" x < (p-1)/2,
  1 "if" x >= (p-1)/2
) $

*Step 2: Using the group structure*

Key property: If $y = g^x$, then $y dot g^k = g^(x+k mod (p-1))$

This means we can "shift" the discrete log by any known amount.

*Step 3: Binary search using MSB oracle*

Given $y = g^x$, we can find $x$ using $A$:

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  1. Query $A(y)$ to get $"MSB"(x)$ — determines if $x$ is in upper or lower half
  2. Shift: compute $y' = y dot g^(-"(p-1)"/4)$ and query $A(y')$
  3. Each query narrows the range by half
  4. After $O(log p)$ queries, we recover $x$ exactly
]

*Conclusion:* If MSB is predictable, DLP is solvable in polynomial time. By contrapositive, if DLP is hard, MSB is hard-core. $square$

#v(1em)

== Part (b): The $(r+1)^"th"$ LSB is Hard-Core

*Setup:* Let $p - 1 = s dot 2^r$ where $s$ is odd. We prove the $(r+1)^"th"$ least significant bit of $x$ is hard-core.

*Why $(r+1)^"th"$ specifically?*

The first $r$ LSBs of $x$ can actually be computed efficiently from $y = g^x mod p$! Here's why:

#block(
  fill: rgb("#fff3e0"),
  inset: 12pt,
  radius: 4pt,
)[
  *Computing low-order bits:* Since $|ZZ_p^*| = p - 1 = s dot 2^r$:
  - $y^s = g^(x dot s) = (g^s)^x$
  - The element $g^s$ has order exactly $2^r$ (a power of 2)
  - This allows computing $x mod 2^r$ via the Pohlig-Hellman algorithm efficiently
  
  Therefore, bits $0, 1, ..., r-1$ are *not* hard-core!
]

*Proof that $(r+1)^"th"$ LSB is hard-core:*

The $(r+1)^"th"$ LSB corresponds to $floor(x / 2^r) mod 2$, i.e., the LSB of the "hard part" $floor(x / 2^r)$.

*Reduction:* Suppose adversary $A$ predicts this bit with advantage $epsilon$.

We can write $x = x_0 + 2^r dot x_1$ where:
- $x_0 = x mod 2^r$ (computable via Pohlig-Hellman #link(<pohlig-hellman>)[(see Appendix B.3)])
- $x_1 = floor(x / 2^r)$ is in ${0, 1, ..., s-1}$

The $(r+1)^"th"$ LSB is precisely $x_1 mod 2$.

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key insight:* Computing $y' = y dot g^(-x_0) = g^(2^r dot x_1)$, we get:
  $ (y')^(1/2^r) = g^(x_1) $
  (where $1/2^r$ is computed $mod (p-1)$, possible since $gcd(2^r, p-1)/2^r$ divides evenly)
  
  The LSB of $x_1$ being predictable from $g^(x_1)$ would allow binary search to find $x_1$, solving DLP in the subgroup of order $s$.
]

Since DLP in the subgroup of odd order $s$ is assumed hard (this is where the actual DLP hardness lies), the $(r+1)^"th"$ bit is hard-core. $square$

#v(1em)

== Part (c): PRG Construction from DLP

Using the hard-core predicate, we construct a *Blum-Micali style PRG*:

=== Construction

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *PRG $G$:* Given seed $x_0 in ZZ_p^*$, output $n$ pseudorandom bits:
  
  ```
  for i = 1 to n:
      y_i = g^(x_(i-1)) mod p     // One-way function
      b_i = MSB(x_(i-1))          // Hard-core bit
      x_i = y_i                   // Update state (treat y as next x)
  output b_1 || b_2 || ... || b_n
  ```
]

More precisely, define the iteration as:
$ x_(i+1) = g^(x_i) mod p $
$ b_i = "MSB"(x_i) $

Output: $b_1, b_2, ..., b_n$

=== Why This Works

#table(
  columns: (auto, 1fr),
  inset: 10pt,
  align: left,
  fill: (col, _) => if col == 0 { rgb("#f5f5f5") } else { white },
  [*Property*], [*Justification*],
  [Expansion], [Seed of $log p$ bits → $n$ output bits (for any polynomial $n$)],
  [Efficiency], [Each step requires one modular exponentiation],
  [Security], [Each bit $b_i$ is hard-core for the function $f(x) = g^x mod p$],
)

=== Security Proof (Sketch)

*Claim:* The output is computationally indistinguishable from random.

*Proof by hybrid argument:*

Define hybrids $H_0, H_1, ..., H_n$ where:
- $H_0$: Real PRG output $(b_1, b_2, ..., b_n)$
- $H_k$: First $k$ bits are truly random, rest from PRG
- $H_n$: All $n$ bits are truly random

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key step:* Adjacent hybrids $H_(k-1)$ and $H_k$ are indistinguishable because distinguishing them requires predicting $b_k = "MSB"(x_(k-1))$ from $g^(x_(k-1))$, which contradicts the hard-core property.
]

By transitivity: $H_0 approx_c H_n$, so the PRG output is pseudorandom. $square$

=== Alternative: Using $(r+1)^"th"$ LSB

The same construction works with the $(r+1)^"th"$ LSB:
$ b_i = "bit"_(r+1)(x_i) $

This may be preferable in some settings as the LSB can be slightly more efficient to extract.

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Summary:* The Blum-Micali PRG based on DLP:
  - *Security:* Reduces to hardness of DLP
  - *Efficiency:* One exponentiation per output bit
  - *Output:* Can generate arbitrarily many pseudorandom bits from a short seed
]
