#import "../preamble.typ": *
// Problem 13: PRF Extension and Counter Mode

= Problem 13:  Weakly-Secure PRF and Counter Mode <p13>

#difficulty("Advanced") #tag("Protocol") #tag("CTR")

#scenario-box("The Resettable Counter")[
  *Intel Report:* An enemy radio uses CTR mode. The protocol says "Pick a random IV". However, their "random" number generator resets to 0 every time the radio is turned on.

  *Your Mission:* Explain why this "randomness failure" is catastrophic for CTR mode (reused nonces), unlike CBC mode where it might just leak the first block equality.
]

#v(1em)

#align(center)[
  #block(stroke: 1pt + rgb("#2c5282"), inset: 10pt, radius: 5pt, fill: rgb("#ebf8ff"))[
    *Visualizing Counter Mode Encryption*
    #v(0.5em)
    #grid(
      columns: (auto, auto, auto, auto, auto),
      column-gutter: 10pt,
      align: center + horizon,
      [Nonce $||$ Ctr], [$arrow.r$], [PRF $F_k$], [$arrow.r$], [Pad Block],
      [], [], [], [$arrow.b$], [$plus.o$],
      [], [], [], [], [Plaintext $m_i$],
      grid.cell(colspan: 5)[#line(length: 100%, stroke: 0.5pt + gray)],
      [Nonce $||$ Ctr+1], [$arrow.r$], [PRF $F_k$], [$arrow.r$], [Pad Block],
      [], [], [], [$arrow.b$], [$plus.o$],
      [], [], [], [], [Plaintext $m_(i+1)$]
    )
  ]
]

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
  *Weakly-Secure PRF* #link(<prf>)[(see Appendix C.6)]*:* A PRF $F : cal(K) times X -> Y$ is *weakly-secure* if it is indistinguishable from a random function when the adversary is restricted to querying on *distinct, uniformly random* inputs (rather than adversarially chosen inputs).
  
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

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: Random vs. Unique Nonces]
  #v(0.3em)
  
  *Two ways to use CTR mode:*
  
  1.  *Randomized (Implicit IV):* Pick random $"IV"$.
      - Pros: Stateless (don't need to remember anything).
      - Cons: Need large $"IV"$ space ($2^{128}$) to avoid birthday collisions.
  
  2.  *Stateful (Explicit Counter):* Maintain a counter $C$. For next message, use $C+1$.
      - Pros: No collisions ever! Information-theoretically distinct.
      - Cons: Must maintain state. If computer crashes/resets, you might reuse nonces (Catastrophic!).
  
  *This problem analyzes Type 1.* It shows that with enough space ("super-poly"), random is as good as unique.
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: The "Weak PRF" Trick]
  #v(0.3em)
  
  A "Weak PRF" is only secure on *random* inputs. Standard PRF is secure on *adversarial* inputs.
  
  *Transforming Weak → Strong:*
  - If you have a Weak PRF, how to build a full encryption scheme?
  - Use *randomized* inputs (like CTR mode)! The randomization forces the inputs to be (mostly) uniformly random, which is exactly where the Weak PRF is secure.
  
  *Connections:*
  - #link(<p05>)[*P5 (CPA):*] CPA security requires handling *chosen* (adversarial) plaintexts.
  - #link(<p20>)[*P20 (Dropped Blocks):*] CTR mode's specific structure also helps with error resilience.
  - #link(<p25>)[*P25 (Stateful CBC):*] Chained modes have different IV requirements (must be unpredictable, not just unique).
]
