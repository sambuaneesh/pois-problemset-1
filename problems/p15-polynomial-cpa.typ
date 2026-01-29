// Problem 15: CPA Security with Polynomial Evaluation

= Problem 15: Breaking CPA Security with Polynomial Queries

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Setup:* Suppose $("Gen", "Enc", "Dec")$ is a CPA-secure encryption scheme that encrypts messages belonging to a field $FF$. Construct a new encryption scheme as follows:
  
  - $"Gen"_1 (1^n)$: Sample $k' arrow.l "Gen"(1^n)$, then sample $p$, a random degree-$d$ polynomial over $FF$. The key is $k = (k', p)$.
  
  - $"Enc"_1 (k, m) = "Enc"(k', m) || p(m)$
  
  - $"Dec"_1 (k, c)$: Runs $"Dec"(k', dot)$ on the first part of the ciphertext.
  
  *Question:* In the CPA security experiment, what is the minimum number of queries to the $"Enc"$ oracle needed to break the CPA security of the scheme $("Gen"_1, "Enc"_1, "Dec"_1)$?
]

#v(0.8em)

== Analysis of the Scheme

=== The Vulnerability

The new encryption appends $p(m)$ to the ciphertext, where $p$ is a secret degree-$d$ polynomial.

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key observation:* A degree-$d$ polynomial over $FF$ is uniquely determined by $d + 1$ points!
  
  If the adversary learns $p(m)$ for $d + 1$ distinct messages $m$, they can fully recover $p$ via *Lagrange interpolation*.
]

=== The Attack Strategy

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Attack to recover the polynomial $p$:*
  
  1. Query the encryption oracle on $d + 1$ distinct messages: $m_0, m_1, ..., m_d in FF$
  2. From each ciphertext $c_i = "Enc"(k', m_i) || p(m_i)$, extract $p(m_i)$ (the second part)
  3. Use Lagrange interpolation to recover $p$ from the $d + 1$ point-value pairs $(m_i, p(m_i))$
]

=== Using the Recovered Polynomial

Once $p$ is known, the adversary can break CPA security:

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *CPA Attack:*
  
  1. Choose distinct challenge messages $m_0^*, m_1^* in FF$ (different from query messages)
  2. Receive challenge ciphertext $c^* = "Enc"(k', m_b^*) || p(m_b^*)$
  3. Compute $p(m_0^*)$ and $p(m_1^*)$ using the recovered polynomial
  4. Compare the second part of $c^*$ with $p(m_0^*)$ and $p(m_1^*)$
  5. Output $b' = 0$ if it matches $p(m_0^*)$, else output $b' = 1$
  
  *Success probability: 1* (deterministic!)
]

#v(1em)

== Minimum Number of Queries

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: $d + 1$ queries are necessary and sufficient.*
]

=== Why $d + 1$ is Sufficient

With $d + 1$ queries, the adversary obtains $d + 1$ point-value pairs, which uniquely determine the degree-$d$ polynomial $p$. The attack above then succeeds with probability 1.

=== Why $d + 1$ is Necessary

#block(
  fill: rgb("#fff3e0"),
  inset: 12pt,
  radius: 4pt,
)[
  *Claim:* With only $d$ queries, the scheme remains CPA-secure.
  
  *Proof sketch:*
  
  With $d$ point-value pairs $(m_1, p(m_1)), ..., (m_d, p(m_d))$, infinitely many degree-$d$ polynomials are consistent with the data. Specifically, for any value $v in FF$ and any new point $m^*$, there exists exactly one polynomial $p$ of degree $d$ such that:
  - $p(m_i) = $ observed values for $i = 1, ..., d$
  - $p(m^*) = v$
  
  This means $p(m_0^*)$ and $p(m_1^*)$ are *uniformly random* from the adversary's perspective (conditioned on the $d$ queries), giving no advantage.
]

This is analogous to *Shamir's secret sharing* with threshold $d + 1$: any $d$ shares reveal nothing about the secret, but $d + 1$ shares reveal everything.

#v(1em)

== Summary

#table(
  columns: (auto, 1fr),
  inset: 10pt,
  align: left,
  fill: (col, _) => if col == 0 { rgb("#e0e0e0") } else { white },
  [*Polynomial Degree*], [*Minimum Queries to Break*],
  [$d$], [$d + 1$],
)

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key Insight:* The scheme leaks $p(m)$ for each encryption. Since a degree-$d$ polynomial has $d + 1$ coefficients (degrees of freedom), exactly $d + 1$ evaluations are needed to determine it. With fewer queries, the polynomial remains information-theoretically hidden.
]
