// Problem 13: PRF Extension and Counter Mode

= Problem 13: Weakly-Secure PRF and Counter Mode

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Setup:* Let $F$ be a PRF defined over $(cal(K), X, Y)$, where $X = {0, ..., N-1}$ and $Y = {0,1}^n$, where $N$ is super-polynomial. For poly-bounded $ell >= 1$, consider the PRF $F'$ defined over $(cal(K), X, Y^ell)$ as follows:
  
  $ F'(k, x) := (F(k, x), F(k, x+1 mod N), ..., F(k, x + ell - 1 mod N)) $
  
  *Tasks:*
  + Show that $F'$ is a weakly-secure PRF.
  + Prove that randomized counter mode is CPA secure.
]

#v(0.8em)

== Background: Weakly-Secure PRF

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Weakly-Secure PRF:* A PRF $F : cal(K) times X -> Y$ is *weakly-secure* if it is indistinguishable from a random function when the adversary is restricted to querying on *distinct, uniformly random* inputs (rather than adversarially chosen inputs).
  
  This is weaker than standard PRF security, but sufficient for many applications.
]

#v(1em)

== Part (a): $F'$ is a Weakly-Secure PRF

*Claim:* If $F$ is a PRF, then $F'$ is a weakly-secure PRF.

*Proof by reduction:*

Suppose $F'$ is not weakly-secure. Then there exists a PPT distinguisher $D$ that can distinguish $F'_k$ from a random function $R : X -> Y^ell$ with non-negligible advantage, even when queries are uniformly random and distinct.

We construct a distinguisher $D_F$ that breaks the PRF security of $F$:

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Distinguisher $D_F$ with oracle access to $O$ (either $F_k$ or random $R_F$):*
  
  1. When $D$ queries on random distinct input $x in X$:
     - Query $O(x), O(x+1 mod N), ..., O(x + ell - 1 mod N)$
     - Return $(O(x), O(x+1), ..., O(x + ell - 1))$ to $D$
  2. Output whatever $D$ outputs
]

*Analysis:*

*Case 1: $O = F_k$ (real PRF)*

$D_F$ perfectly simulates $F'_k (x)$ for each query.

*Case 2: $O = R_F$ (random function)*

Each $R_F (x + i mod N)$ is an independent random value in ${0,1}^n$.

The key question: Does the output look like a random function over $Y^ell$?

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Potential collision issue:* If two queries $x$ and $x'$ are such that their ranges overlap, i.e., $x + i equiv x' + j mod N$ for some $i, j in {0, ..., ell - 1}$, then the outputs share a common value.
  
  A truly random function $R : X -> Y^ell$ would have independent outputs, but our simulation produces correlated outputs when ranges overlap.
]

*Why this is okay for weak security:*

Since queries are *random and distinct*, and $N$ is *super-polynomial*:

$ Pr["two ranges overlap"] <= (q^2 dot ell^2) / N $

where $q$ is the number of queries (polynomial). Since $N$ is super-polynomial and $ell$ is polynomial, this probability is *negligible*.

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *With overwhelming probability, all query ranges are disjoint.*
  
  When ranges are disjoint, the outputs are independent random values, perfectly matching a random function.
]

*Conclusion:*

$ |Pr[D_F^(F_k) = 1] - Pr[D_F^(R_F) = 1]| >= |Pr[D^(F'_k) = 1] - Pr[D^R = 1]| - "negl"(n) $

If $D$ has non-negligible advantage, so does $D_F$, contradicting that $F$ is a PRF. $square$

#v(1em)

== Part (b): Randomized Counter Mode is CPA Secure

=== Randomized Counter Mode (CTR) Construction

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Encryption scheme $cal(E) = ("Gen", "Enc", "Dec")$:*
  
  - *Gen:* Sample $k arrow.l cal(K)$ uniformly
  
  - *Encryption* $"Enc"_k (m_1, ..., m_ell)$: where each $m_i in {0,1}^n$
    1. Sample random starting point $r arrow.l X = {0, ..., N-1}$
    2. Compute $c_i = m_i xor F(k, r + i - 1 mod N)$ for $i = 1, ..., ell$
    3. Output $(r, c_1, ..., c_ell)$
  
  - *Decryption* $"Dec"_k (r, c_1, ..., c_ell)$:
    1. Compute $m_i = c_i xor F(k, r + i - 1 mod N)$ for $i = 1, ..., ell$
    2. Output $(m_1, ..., m_ell)$
]

=== CPA Security Proof

*Claim:* If $F$ is a PRF and $N$ is super-polynomial, then randomized counter mode is CPA-secure.

*Proof:*

We prove this using a hybrid argument.

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Hybrid 0 (Real world):* Adversary interacts with $"Enc"_k$ using the real PRF $F_k$.
  
  *Hybrid 1:* Replace $F_k$ with a truly random function $R : X -> {0,1}^n$.
  
  *Hybrid 2 (Ideal world):* Ciphertexts are completely random.
]

*Hybrid 0 $approx$ Hybrid 1:*

By PRF security of $F$, no PPT adversary can distinguish $F_k$ from a random function $R$.

Any distinguisher between Hybrid 0 and Hybrid 1 can be converted to a PRF distinguisher for $F$.

*Hybrid 1 $approx$ Hybrid 2:*

In Hybrid 1, for each encryption query with random $r$:
$ c_i = m_i xor R(r + i - 1) $

Since $R$ is a random function and $r$ is random:
- Each $R(r + i - 1)$ is uniformly random (if not queried before)
- The key question: Are the values $R(r), R(r+1), ..., R(r + ell - 1)$ fresh?

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Collision analysis:* What's the probability that two encryption queries have overlapping counter ranges?
  
  For $q$ encryption queries, each using $ell$ consecutive counters starting from random $r_j$:
  
  $ Pr["some overlap"] <= (q^2 dot ell^2) / N = "negl"(n) $
  
  since $N$ is super-polynomial.
]

*Conditioning on no collisions:*

When counter ranges don't overlap:
- Each $R(r_j + i)$ is an independent random value
- $c_i = m_i xor R(r_j + i)$ is uniformly random (one-time pad!)
- The ciphertext reveals nothing about the message

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *In the no-collision case, CTR mode is perfectly secret!*
  
  Since collisions happen with negligible probability, Hybrid 1 $approx$ Hybrid 2.
]

*CPA Security Conclusion:*

By the hybrid argument:
$ "Adv"_"CPA"(A) <= "Adv"_"PRF"(B) + (q^2 ell^2)/N $

Both terms are negligible, so the scheme is CPA-secure. $square$

#v(1em)

== Summary

#table(
  columns: (auto, 1fr),
  inset: 10pt,
  align: left,
  fill: (col, _) => if col == 0 { rgb("#e0e0e0") } else { white },
  [*Result*], [*Key Insight*],
  [$F'$ is weakly-secure PRF], [Random, distinct queries cause disjoint counter ranges with overwhelming probability],
  [CTR mode is CPA-secure], [Random nonces + super-poly domain size → negligible collision probability → OTP-like security],
)

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key Takeaway:* The super-polynomial size of $N$ is crucial! It ensures that even with polynomially many queries, the probability of counter range overlaps is negligible. This allows us to treat each encryption as if it uses fresh random pad values.
]
