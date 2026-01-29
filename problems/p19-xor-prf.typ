// Problem 19: XOR of PRF Values is NOT a PRF

= Problem 19: XOR of PRF Outputs

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Task:* Let $cal(F) : {0,1}^n times {0,1}^n -> {0,1}^n$ be a PRF #link(<prf>)[(Appendix C.6)] and let $cal(G)(k, (x, y)) = cal(F)(k, x) xor cal(F)(k, y)$. Prove that $cal(G)$ is *not* a PRF.
]

#v(0.8em)

== Understanding the Construction

$cal(G)$ takes a key $k$ and a *pair* of inputs $(x, y)$ and outputs the XOR of the PRF values at $x$ and $y$:
$ cal(G)_k (x, y) = cal(F)_k (x) xor cal(F)_k (y) $

The input space for $cal(G)$ is ${0,1}^n times {0,1}^n = {0,1}^(2n)$ (pairs of $n$-bit strings).

#v(0.8em)

== The Attack

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: $cal(G)$ is NOT a PRF.*
]

*Key observation:* There is an exploitable algebraic structure in $cal(G)$.

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  *Structural flaw:*
  
  For ANY input $(x, x)$ (where both components are equal):
  $ cal(G)_k (x, x) = cal(F)_k (x) xor cal(F)_k (x) = 0^n $
  
  This holds for ALL keys $k$ and ALL values of $x$!
]

#v(0.8em)

== Distinguishing Attack

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Distinguisher $D$ with oracle access to $O$ (either $cal(G)_k$ or random $R : {0,1}^(2n) -> {0,1}^n$):*
  
  1. Choose any $x in {0,1}^n$
  2. Query $O(x, x)$
  3. If the result is $0^n$, output "real $cal(G)$"
  4. Otherwise, output "random"
]

#v(0.8em)

== Analysis

*Case 1: Oracle is $cal(G)_k$*

$ cal(G)_k (x, x) = cal(F)_k (x) xor cal(F)_k (x) = 0^n $

The output is *always* $0^n$. The distinguisher outputs "real" with probability 1.

*Case 2: Oracle is truly random function $R$*

$ Pr[R(x, x) = 0^n] = 1/(2^n) $

The output is $0^n$ with probability $1/2^n$ (negligible).

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Distinguishing advantage:*
  $ |1 - 1/(2^n)| = 1 - "negl"(n) approx 1 $
  
  This is overwhelming! The construction is completely broken. $square$
]

#v(0.8em)

== Alternative Attack (Using Three Queries)

Another attack exploits the XOR structure more generally:

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Attack using the XOR property:*
  
  Query three pairs: $(x, y)$, $(y, z)$, $(x, z)$
  
  Check if: $cal(G)(x, y) xor cal(G)(y, z) = cal(G)(x, z)$
  
  *Why this works for $cal(G)_k$:*
  $ cal(G)(x, y) xor cal(G)(y, z) &= [cal(F)(x) xor cal(F)(y)] xor [cal(F)(y) xor cal(F)(z)] \
  &= cal(F)(x) xor cal(F)(z) = cal(G)(x, z) $
  
  *For a random function:* This relation holds with probability $1/2^n$.
]

#v(0.8em)

== Key Insight

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Why XOR breaks PRF security:*
  
  The XOR operation introduces *algebraic structure* that a truly random function wouldn't have:
  
  1. *Self-cancellation:* $cal(G)(x, x) = 0$
  2. *Transitivity:* $cal(G)(x, y) xor cal(G)(y, z) = cal(G)(x, z)$
  3. *Symmetry:* $cal(G)(x, y) = cal(G)(y, x)$
  
  Any of these can be used to distinguish $cal(G)$ from a random function.
]
