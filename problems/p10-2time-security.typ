// Problem 10: 2-Time Perfect Security

= Problem 10:  2-Time Perfectly Secure Encryption <p10>

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Definition:* An encryption scheme $("Gen", "Enc", "Dec")$ over message space $cal(M)$ and ciphertext space $cal(C)$ is *2-time perfectly secure* #link(<perfect-secrecy>)[(see Appendix C.8)] if for any $(m_1, m_2) in cal(M) times cal(M)$ and $(m'_1, m'_2) in cal(M) times cal(M)$ such that $m_1 != m_2$ and $m'_1 != m'_2$, and for any $c_1, c_2 in cal(C)$:
  $ Pr["Enc"(K, m_1) = c_1 and "Enc"(K, m_2) = c_2] = Pr["Enc"(K, m'_1) = c_1 and "Enc"(K, m'_2) = c_2] $
  
  *Encryption Scheme over $ZZ_23$:*
  - *Gen:* Sample two elements $a arrow.l ZZ_23$ and $b arrow.l ZZ_23$
  - *Enc$((a, b), m)$:* Output $c = a dot m + b mod 23$
  - *Dec$((a, b), c)$:* Compute $m = (c - b) dot a^(-1) mod 23$ if $a$ is invertible; otherwise output error
  
  *Tasks:*
  + Prove that for any message $m in ZZ_23$: $Pr["Dec"(K, "Enc"(K, m)) = m] = 22/23$
  + Prove that this scheme is 2-time secure
]

#v(0.8em)

== Part (a): Correctness Probability is $22/23$

*Claim:* For any $m in ZZ_23$, $Pr["Dec"(K, "Enc"(K, m)) = m] = 22/23$.

*Proof:*

The key $K = (a, b)$ is sampled uniformly from $ZZ_23 times ZZ_23$.

Given message $m$:
1. Encryption computes: $c = a dot m + b mod 23$
2. Decryption computes: $m' = (c - b) dot a^(-1) = (a dot m + b - b) dot a^(-1) = a dot m dot a^(-1) = m$

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *But wait!* Decryption requires $a^(-1)$ to exist, which happens if and only if $gcd(a, 23) = 1$.
  
  Since $23$ is prime, $a^(-1)$ exists $<=>$ $a != 0$.
]

*Probability analysis:*

$ Pr["Dec"(K, "Enc"(K, m)) = m] = Pr[a != 0] $

Since $a$ is sampled uniformly from $ZZ_23 = {0, 1, 2, ..., 22}$:
$ Pr[a != 0] = 22/23 $

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Conclusion:* $Pr["Dec"(K, "Enc"(K, m)) = m] = 22/23$ $checkmark$
]

*Note:* When $a = 0$, we have $c = b$ regardless of $m$, and decryption fails because $0$ has no multiplicative inverse in $ZZ_23$.

#v(1em)

== Part (b): The Scheme is 2-Time Secure

*Claim:* The encryption scheme is 2-time perfectly secure.

*Proof:*

We need to show that for any $(m_1, m_2)$ and $(m'_1, m'_2)$ with $m_1 != m_2$ and $m'_1 != m'_2$, and any $c_1, c_2$:
$ Pr["Enc"(K, m_1) = c_1 and "Enc"(K, m_2) = c_2] = Pr["Enc"(K, m'_1) = c_1 and "Enc"(K, m'_2) = c_2] $

*Setting up the equations:*

For the key $(a, b)$, the event ${"Enc"(K, m_1) = c_1 and "Enc"(K, m_2) = c_2}$ means:
$ a dot m_1 + b &equiv c_1 mod 23 \
a dot m_2 + b &equiv c_2 mod 23 $

*Solving for $(a, b)$:*

Subtracting the equations:
$ a dot (m_1 - m_2) equiv c_1 - c_2 mod 23 $

Since $m_1 != m_2$ and $23$ is prime, $(m_1 - m_2)$ has a multiplicative inverse in $ZZ_23$.

Therefore:
$ a equiv (c_1 - c_2) dot (m_1 - m_2)^(-1) mod 23 $

Once $a$ is determined, $b$ is uniquely determined:
$ b equiv c_1 - a dot m_1 mod 23 $

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key observation:* For any $c_1, c_2$ and any pair $(m_1, m_2)$ with $m_1 != m_2$, there exists *exactly one* key $(a, b) in ZZ_23 times ZZ_23$ such that:
  $ "Enc"((a,b), m_1) = c_1 "and" "Enc"((a,b), m_2) = c_2 $
]

*Computing the probability:*

$ Pr["Enc"(K, m_1) = c_1 and "Enc"(K, m_2) = c_2] = ("number of valid keys")/("total keys") = 1/(23^2) $

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *This probability is $1/23^2$ regardless of the choice of $(m_1, m_2)$ (as long as $m_1 != m_2$)!*
]

*Applying to both message pairs:*

For $(m_1, m_2)$ with $m_1 != m_2$:
$ Pr["Enc"(K, m_1) = c_1 and "Enc"(K, m_2) = c_2] = 1/(23^2) $

For $(m'_1, m'_2)$ with $m'_1 != m'_2$:
$ Pr["Enc"(K, m'_1) = c_1 and "Enc"(K, m'_2) = c_2] = 1/(23^2) $

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Since both probabilities equal $1/23^2$, the scheme is 2-time perfectly secure.* $square$
]

#v(1em)

== Intuition: Why 2-Time but Not 3-Time?

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *The affine cipher $c = a dot m + b$ has 2 unknowns: $a$ and $b$.*
  
  - *With 1 ciphertext:* 1 equation, 2 unknowns → many solutions → 1-time secure
  - *With 2 ciphertexts:* 2 equations, 2 unknowns → unique solution → 2-time secure
  - *With 3 ciphertexts:* 3 equations, 2 unknowns → overdetermined → reveals key structure!
]

#table(
  columns: (auto, 1fr),
  inset: 10pt,
  align: left,
  fill: (col, _) => if col == 0 { rgb("#f5f5f5") } else { white },
  [*Messages*], [*Security*],
  [1 message], [Perfectly secure (like OTP with 2-part key)],
  [2 messages], [Still perfectly secure (equations = unknowns)],
  [3+ messages], [NOT secure — the key is uniquely determined and can be checked],
)

*Analogy:* This is similar to Shamir's secret sharing with threshold 2 — any 2 points determine a line, but 1 point reveals nothing about it.

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: Multi-Time Security = Entropy per Message]
  #v(0.3em)
  
  *The Core Formula:* A scheme with $k$ key "unknowns" can be $k$-time secure but not $(k+1)$-time secure.
  
  *Why?* Each encryption leaks one "equation" about the key. When equations ≥ unknowns, the key is determined.
  
  #table(
    columns: (auto, auto, auto),
    inset: 8pt,
    fill: (_, row) => if row == 0 { rgb("#e0e0e0") } else { white },
    [*Scheme*], [*Key Unknowns*], [*$k$-time secure for*],
    [OTP (key = pad)], [$n$ bits], [1-time only],
    [Affine ($a m+b$)], [2 elements], [2-time],
    [Polynomial degree-$d$], [$d+1$ coefficients], [$(d+1)$-time],
  )
  
  *The Design Principle:* Want $k$-time security? Use a key with $k$ degrees of freedom that's consumed linearly by each encryption.
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: Linear Algebra Determines Security Threshold]
  #v(0.3em)
  
  This problem illustrates a deep connection: *cryptographic security often reduces to linear algebra*.
  
  - *Equations = Encryptions:* Each ciphertext gives a linear equation in key variables
  - *Unknowns = Key entropy:* The key has some number of free variables
  - *Full rank system:* When equations = unknowns, unique solution → key is exposed
  - *Underdetermined:* When equations < unknowns, infinitely many keys fit → security!
  
  *Real-World Connections:*
  - *WEP (broken):* Key reuse led to solving linear equations
  - *Linear cryptanalysis:* Attacks based on finding linear approximations
  - *Stream ciphers:* Must avoid linear key schedules
  
  *This pattern connects to:*
  - *P5 (CPA Attacks):* Queries = equations, key complexity = unknowns
  - *P15 (Polynomial CPA):* Degree $d$ → $(d+1)$ coefficients → $(d+1)$ queries to break
  - *P24 (2-time Impossibility):* Formalizes why perfect $>1$-time security is impossible for OTP
]
