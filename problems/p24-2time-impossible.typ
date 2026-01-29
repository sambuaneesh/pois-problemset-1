// Problem 24: 2-Time Perfect Secrecy is Impossible

= Problem 24: Impossibility of 2-Time Perfect Secrecy

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Task:* Prove that no encryption scheme can satisfy the following definition of perfect secrecy #link(<perfect-secrecy>)[(Appendix C.8)] for two messages:
  
  For all distributions over $cal(M) times cal(M)$, all $(m_1, m_2) in cal(M) times cal(M)$ and all $(c_1, c_2) in cal(C) times cal(C)$ where $Pr[C_1 = c_1 and C_2 = c_2] > 0$:
  
  $ Pr[M_1 = m_1 and M_2 = m_2 | C_1 = c_1 and C_2 = c_2] = Pr[M_1 = m_1 and M_2 = m_2] $
]

#v(0.8em)

== Understanding the Definition

*2-time perfect secrecy* would require that seeing TWO ciphertexts (encrypted with the same key) reveals nothing about the two plaintexts.

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Comparison:*
  
  - *1-time perfect secrecy:* $Pr[M = m | C = c] = Pr[M = m]$  – achievable (OTP)
  - *2-time perfect secrecy:* Seeing $(c_1, c_2)$ reveals nothing about $(m_1, m_2)$ – impossible!
]

#v(0.8em)

== Proof of Impossibility

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Theorem:* No encryption scheme can achieve 2-time perfect secrecy.
]

*Proof:*

Consider any deterministic encryption scheme with key $k$. 

*Case 1: Encryption is deterministic*

If $"Enc"$ is deterministic, then:
$ c_1 = c_2 arrow.r.double m_1 = m_2 $

This immediately leaks information! Observing $c_1 = c_2$ tells us the two plaintexts are equal.

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  *Violation:* Let the message distribution have $Pr[M_1 = M_2] < 1$.
  
  Observing $c_1 = c_2$ forces $Pr[M_1 = M_2 | C_1 = c_1 and C_2 = c_1] = 1 != Pr[M_1 = M_2]$.
]

*Case 2: Encryption is randomized*

Even with randomization, we can derive a contradiction using a counting argument.

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Setup:*
  - Let $|cal(M)| = M$, $|cal(K)| = K$, $|cal(C)|$ such that scheme is correct
  - For 1-time perfect secrecy: Shannon requires $K >= M$
  
  *For 2-time perfect secrecy:*
  - Message pairs space: $|cal(M) times cal(M)| = M^2$
  - Ciphertext pairs space: $|cal(C) times cal(C)|$
  - We need every ciphertext pair to be consistent with every message pair
]

*The counting argument:*

Fix a key $k$. The encryption function (even if randomized) maps:
$ "Enc"_k : cal(M) -> cal(C) " (possibly probabilistic)" $

For a pair of messages $(m_1, m_2)$, the possible ciphertext pairs $(c_1, c_2)$ depend on the same key $k$.

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key observation:* Given $(c_1, c_2)$, an adversary learns that both $c_1$ and $c_2$ decrypt to valid messages under the SAME key $k$.
  
  This constrains the possible $(m_1, m_2)$ pairs — not all pairs are equally likely given the ciphertext pair.
]

*Concrete attack:*

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  *Attack using ciphertext relationship:*
  
  For OTP-like schemes: $c_1 = k xor m_1$ and $c_2 = k xor m_2$
  
  Then: $c_1 xor c_2 = m_1 xor m_2$
  
  The adversary learns $m_1 xor m_2$ exactly! This is a massive information leak.
  
  *Violation:* Given $c_1 xor c_2 = Delta$, only message pairs with $m_1 xor m_2 = Delta$ are possible.
  
  $ Pr[M_1 xor M_2 = Delta | C_1 = c_1, C_2 = c_2] = 1 $
  
  But if the message distribution has $Pr[M_1 xor M_2 = Delta] < 1$, perfect secrecy is violated.
]

#v(0.5em)

== General Impossibility Argument

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Fundamental reason:*
  
  With a fixed key:
  - 1 message → 1 ciphertext (or distribution over ciphertexts) — can hide 1 message worth of information
  - 2 messages → 2 ciphertexts with SHARED randomness (the key)
  
  The shared key creates a *correlation* between $c_1$ and $c_2$ that leaks information about the relationship between $m_1$ and $m_2$.
  
  *Formally:* $I(M_1, M_2; C_1, C_2) > 0$ when using the same key twice.
]

#v(0.5em)

== Key Takeaway

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Perfect secrecy is fundamentally a ONE-TIME guarantee.*
  
  - Reusing a key leaks information about message relationships
  - This is why OTP must use fresh keys for each message
  - Computational security (CPA) is needed for multi-message security with key reuse
]
