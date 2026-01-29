#import "../preamble.typ": *
// Problem 7: Weak Primes for DLP

= Problem 7:  Unsuitable Primes for DLP <p07>

#difficulty("Advanced") #tag("Attack") #tag("NumberTheory")

#scenario-box(" The Smooth Prime Disaster")[
  *Intel Report:* We found a server using Diffie-Hellman with a huge prime $p$. However, the factorization of $p-1$ consists of only tiny primes (it's "smooth").

  *Your Mission:* Show how to break this system by solving the Discrete Log problem piece by piece (Pohlig-Hellman) instead of all at once.
]

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Question:* Let $p$ be a prime and consider the discrete logarithm problem in the group $FF_p^*$, which has order $p - 1$. Explain which primes $p$ are unsuitable for discrete-logarithm-based cryptography due to the Pohlig-Hellman attack #link(<pohlig-hellman>)[(see Appendix B.3)]. In particular, characterize the factorization of $p - 1$ that makes the discrete logarithm problem efficiently solvable.
]

#v(0.8em)

== Background: The Pohlig-Hellman Attack

The Pohlig-Hellman algorithm exploits the *factorization structure* of the group order to solve DLP efficiently when the order has only small prime factors.

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key Insight:* If $|G| = p - 1 = product_(i=1)^k q_i^(e_i)$ where all $q_i$ are "small", then:
  
  1. Solve DLP separately in each subgroup of order $q_i^(e_i)$
  2. Combine solutions using the Chinese Remainder Theorem
  
  *Complexity:* $O(sum_i e_i (log n + sqrt(q_i)))$ instead of $O(sqrt(p))$ for generic algorithms.
]

#v(1em)

== Characterization of Unsuitable Primes

=== Definition: Smooth Numbers

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *B-smooth:* An integer $n$ is called *$B$-smooth* if all its prime factors are $<= B$.
  
  *Example:* $60 = 2^2 times 3 times 5$ is 5-smooth, but not 4-smooth.
]

=== The Vulnerability Condition

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *A prime $p$ is UNSUITABLE for DLP-based cryptography if $p - 1$ is $B$-smooth for relatively small $B$.*
  
  More precisely, if all prime factors of $p - 1$ are polynomial in $log p$, the DLP can be solved in polynomial time.
]

#v(0.5em)

=== Why Smooth $p - 1$ is Dangerous

Let $p - 1 = q_1^(e_1) times q_2^(e_2) times ... times q_k^(e_k)$.

The Pohlig-Hellman algorithm:

#table(
  columns: (auto, 1fr),
  inset: 10pt,
  align: left,
  fill: (col, _) => if col == 0 { rgb("#f5f5f5") } else { white },
  [*Step*], [*Operation*],
  [1], [For each prime power $q_i^(e_i)$ dividing $p-1$:],
  [], [— Project to subgroup of order $q_i^(e_i)$: compute $y' = y^((p-1)/q_i^(e_i))$],
  [], [— Solve DLP in this subgroup (order $q_i^(e_i)$): find $x_i = x mod q_i^(e_i)$],
  [2], [Combine using CRT: $x equiv x_i mod q_i^(e_i)$ for all $i$],
)

*Complexity Analysis:*

- Solving DLP in subgroup of order $q^e$: $O(e(log p + sqrt(q)))$ using baby-step giant-step
- If largest prime factor $q_"max" = O("poly"(log p))$, then total time is polynomial!

#v(1em)

== Precise Characterization

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Theorem:* The DLP in $FF_p^*$ can be solved in time $O(sqrt(q_"max") dot "poly"(log p))$ where $q_"max"$ is the *largest prime factor* of $p - 1$.
]

This leads to the following classification:

#align(center)[
#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: left,
  fill: (_, row) => if row == 0 { rgb("#1a365d") } else if calc.rem(row, 2) == 0 { rgb("#f7fafc") } else { white },
  table.header(
    [#text(fill: white)[*Factorization of $p-1$*]], 
    [#text(fill: white)[*Security*]], 
    [#text(fill: white)[*Verdict*]]
  ),
  [$p - 1 = 2 times q$ (large prime $q$)], [DLP hard: $O(sqrt(q)) approx O(sqrt(p))$], [#text(fill: rgb("#4CAF50"))[*SAFE*]],
  [$p - 1$ has large prime factor $>=$ $p^(1/3)$], [DLP still hard], [#text(fill: rgb("#4CAF50"))[*SAFE*]],
  [$p - 1 = 2^k$ (power of 2)], [DLP trivial: $O(k^2)$], [#text(fill: rgb("#d9534f"))[*UNSAFE*]],
  [$p - 1$ is $B$-smooth, $B = O(log p)$], [DLP poly-time], [#text(fill: rgb("#d9534f"))[*UNSAFE*]],
  [$p - 1$ is $B$-smooth, $B = O(p^epsilon)$], [DLP subexponential], [#text(fill: rgb("#FF9800"))[*WEAK*]],
)
]

#v(1em)

== Examples

=== Example 1: UNSAFE Prime

Let $p = 257 = 2^8 + 1$, so $p - 1 = 256 = 2^8$.

- Largest prime factor: $q_"max" = 2$
- DLP complexity: $O(8 times (log 257 + sqrt(2))) = O(8)$ — trivial!

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *This prime is completely unsuitable.* The DLP can be solved immediately.
]

=== Example 2: SAFE Prime

A *safe prime* is a prime $p$ such that $q = (p-1)/2$ is also prime.

Let $p = 23$, so $p - 1 = 22 = 2 times 11$.

- Largest prime factor: $q_"max" = 11$
- DLP complexity: $O(sqrt(11)) approx O(3)$ operations in subgroup

For cryptographic sizes (e.g., $p approx 2^{2048}$):
- $p - 1 = 2q$ where $q$ is a 2047-bit prime
- DLP complexity: $O(sqrt(q)) approx O(2^{1024})$ — infeasible!

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Safe primes are ideal for DLP-based cryptography.* They maximize the difficulty of Pohlig-Hellman.
]

=== Example 3: WEAK Prime (Smooth)

Let $p - 1 = 2^{10} times 3^5 times 5^3 times 7^2 times 11 times 13$.

All prime factors are $<= 13$, so $p - 1$ is 13-smooth.

- DLP can be solved by combining solutions from 6 small subgroups
- Total complexity: polynomial in $log p$

#v(1em)

== Summary: Selecting Safe Primes

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Requirements for DLP-based Cryptography:*
  
  1. *Choose $p$ such that $p - 1$ has at least one LARGE prime factor*
     - "Large" means $>= p^(1/3)$ or comparable to $sqrt(p)$
  
  2. *Ideal: Use SAFE PRIMES where $p = 2q + 1$ with $q$ prime*
     - This ensures largest factor of $p-1$ is $q approx p/2$
     - Pohlig-Hellman gives no advantage over generic algorithms
  
  3. *Alternative: Use groups of prime order*
     - Choose a prime-order subgroup of $FF_p^*$ (e.g., Schnorr groups)
     - Work in subgroup of order $q$ where $q | (p-1)$ is large prime
]

#v(0.5em)

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key Takeaway:* The security of the discrete logarithm problem in $FF_p^*$ depends critically on the *largest prime factor* of $p - 1$. If $p - 1$ is smooth (all factors small), the Pohlig-Hellman attack makes DLP trivially solvable. Always use primes where $p - 1$ has a large prime factor — preferably safe primes of the form $p = 2q + 1$.
]

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: Divide and Conquer Attacks]
  #v(0.3em)
  
  *The Core Vulnerability:* If a large problem can be broken into independent smaller problems, its hardness is determined by the *largest small piece*, not the total size.
  
  *Pohlig-Hellman Strategy:*
  1. *Project* the problem into small subgroups (using $y^((p-1)/q)$)
  2. *Solve* easily in each small world
  3. *Combine* results (CRT) to conquer the large world
  
  *Analogy:* Trying to guess a 10-digit PIN is hard ($10^{10}$). But if the system tells you if the *first* 5 digits are correct, then the *last* 5, it becomes two 5-digit problems ($10^5 + 10^5$), which is trivial.
  
  *Real-World Impact:* This is why we use "Safe Primes" ($p=2q+1$) in Diffie-Hellman and RSA key generation.
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: Subgroup Attacks]
  #v(0.3em)
  
  The "small subgroup" vulnerability appears in many contexts:
  
  - *Small Subgroup Confinement Attack:* Forcing a key into a small subgroup to exhaustively search it.
  - *Lim-Lee Primes:* Generating primes to resist these attacks.
  - *Curve25519:* Designed with cofactor 8 to avoid subgroup issues.
  
  *Connections:*
  - #link(<p03>)[*P3 (Hard-Core DLP):*] Assumes DLP is hard. P7 tells us *when* it is hard.
  - #link(<p16>)[*P16 (Constructions):*] Building crypto from groups requires choosing groups carefully.
  - #link(<p15>)[*P15 (Polynomials):*] CRT is a "polynomial" version of combining results, similar to Pohlig-Hellman.
]
