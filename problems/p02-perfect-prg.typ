#import "../preamble.typ": *
// Problem 2: Perfect Pseudo-Random Generators

= Problem 2: Perfect Pseudo-Random Generators <p02>

#difficulty("Intermediate") #tag("PRG") #tag("InformationTheory")

#scenario-box("The Infinite Compression Machine")[
  *Intel Report:* A startup claims they have invented a "Perfect Random Number Generator" that takes a 100-bit seed and outputs a TRULY random 1000-bit stream, indistinguishable from natural noise.

  *Your Mission:* Prove mathematically why this claim is impossible (hint: can you create information from nothing?).
]

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Task:* Provide a definition for perfect pseudo-random generators $G : {0,1}^n -> {0,1}^(n+1)$. Furthermore, prove that such perfect PRGs do not exist.
]

#v(0.8em)

== Definition of a Perfect PRG

A *perfect pseudo-random generator* (PRG) would be a deterministic function:
$ G : {0,1}^n -> {0,1}^(n+1) $

that satisfies the following property:

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Perfect Indistinguishability:* The output distribution of $G$ is *identical* (not just computationally indistinguishable) to the uniform distribution over ${0,1}^(n+1)$.
  
  Formally: For a seed $s$ chosen uniformly at random from ${0,1}^n$:
  $ G(s) equiv U_(n+1) $
  where $U_(n+1)$ denotes the uniform distribution over ${0,1}^(n+1)$.
]

In other words, no algorithm (even with unlimited computational power) can distinguish between:
- A string sampled from $G(U_n)$ — output of the PRG on a random seed
- A string sampled uniformly from ${0,1}^(n+1)$

#v(1em)

== Proof: Perfect PRGs Cannot Exist

We prove this using a *counting argument* (pigeonhole principle).

=== Setup

- *Domain (seeds):* ${0,1}^n$ has exactly $2^n$ elements
- *Codomain (outputs):* ${0,1}^(n+1)$ has exactly $2^(n+1) = 2 dot 2^n$ elements
- $G$ is a *deterministic* function

=== The Counting Argument

Since $G$ is a function from a set of size $2^n$ to a set of size $2^(n+1)$:

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key Observation:* $G$ can produce *at most* $2^n$ distinct outputs (one for each possible seed).
]

But the codomain has $2^(n+1)$ possible strings. Therefore:

$ |"Image"(G)| <= 2^n < 2^(n+1) = |{0,1}^(n+1)| $

This means:
- At least $2^(n+1) - 2^n = 2^n$ strings in ${0,1}^(n+1)$ are *never* output by $G$
- These strings have probability $0$ under $G(U_n)$
- But under the uniform distribution $U_(n+1)$, every string has probability $1/2^(n+1) > 0$

=== Conclusion

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  The output distribution of $G$ *cannot* be identical to $U_(n+1)$ because:
  
  - Under $U_(n+1)$: Every string has probability $1/2^(n+1)$
  - Under $G(U_n)$: At least half the strings have probability $0$
  
  Therefore, *perfect PRGs do not exist*.
]

=== Visual Intuition

#align(center)[
  #table(
    columns: (1fr, 1fr),
    inset: 12pt,
    align: center,
    fill: (col, _) => if col == 0 { rgb("#e3f2fd") } else { rgb("#fff3e0") },
    [*Seeds: ${0,1}^n$*], [*Outputs: ${0,1}^(n+1)$*],
    [$2^n$ elements], [$2^(n+1) = 2 times 2^n$ elements],
    [All used as inputs], [Only $2^n$ can be reached],
  )
]

#v(0.5em)

Since $G$ is deterministic and "stretches" $n$ bits into $n+1$ bits, it simply cannot cover the entire output space. The expansion creates a gap that makes perfect indistinguishability impossible.

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Why Computational PRGs Work:* In practice, we relax the requirement to *computational indistinguishability* — no *efficient* (polynomial-time) algorithm can distinguish. This is achievable because we only need to fool limited adversaries, not omniscient ones.
]

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: Compression vs Expansion]
  #v(0.3em)
  
  *The Fundamental Trade-off:* You cannot create "something from nothing" with perfect fidelity. If you expand $n$ bits to $n+1$ bits deterministically, you *necessarily* lose coverage.
  
  *Intuitive Analogy:* Think of it like fitting 100 people into 50 chairs:
  - With 100 people (outputs) and 50 chairs (seeds), some "outputs" must remain empty
  - No rearrangement can make everyone sit — there simply aren't enough chairs
  
  *The Cryptographic Insight:* This is why cryptographic PRGs rely on *computational* security:
  - The "missing" $2^n$ outputs exist, but finding them efficiently is hard
  - It's like a treasure hidden in a haystack — it exists, but searching is impractical
  
  *Real-World Parallel:* This same principle appears in:
  - *Data compression*: Perfect lossless compression of random data to a smaller size is impossible (pigeonhole)
  - *Hash functions*: Collisions must exist when hashing large inputs to fixed-size outputs
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: Counting Arguments in Cryptography]
  #v(0.3em)
  
  This counting/pigeonhole argument appears throughout cryptography:
  
  - *P24 (2-time Perfect Secrecy):* We'll prove no scheme can be "2-time perfectly secure" using a similar counting argument
  - *P10 (Key Reuse):* Why reusing keys in certain modes breaks security
  - *Hash Collisions:* If output is 256 bits, $2^{256}+1$ inputs guarantee a collision
  
  *The Meta-Pattern:* Whenever domain and codomain have different sizes, counting arguments reveal fundamental impossibilities. *Perfect* security requires enough "space" (entropy); *computational* security lets us cheat with hardness assumptions.
]
