// Problem 5: Chosen Plaintext Attacks

= Problem 5: Chosen Plaintext Attacks

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Scenario:* The adversary can obtain ciphertexts for arbitrary plaintexts of their choosing (without knowing the secret key). Show how to use this to learn the secret key for shift #link(<shift-cipher>)[(Appendix A.1)], substitution #link(<substitution-cipher>)[(A.2)], and Vigenère #link(<vigenere-cipher>)[(A.3)] ciphers.
]

#v(0.8em)

== Part (a): Chosen Plaintext Attacks on Classical Ciphers

=== Attack on Shift Cipher

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Cipher:* $c_i = (m_i + k) mod 26$ where $k in {0, 1, ..., 25}$
  
  *Key to recover:* The shift amount $k$
]

*Attack:*
+ Choose plaintext: $m = $ "A" (just the single letter A, which has value 0)
+ Request encryption: Get $c = "Enc"_k ("A") = (0 + k) mod 26 = k$
+ Recover key: $k = c$ (the ciphertext letter's position directly gives $k$)

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Minimum plaintext length:* #strong[1 character]
  
  By encrypting 'A', the ciphertext directly reveals the shift value $k$.
]

#v(0.8em)

=== Attack on Substitution Cipher

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Cipher:* $c_i = pi(m_i)$ where $pi : Sigma -> Sigma$ is a secret permutation
  
  *Key to recover:* The entire permutation $pi$ (26 mappings)
]

*Attack:*
+ Choose plaintext: $m = $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ" (the entire alphabet)
+ Request encryption: Get $c = pi("A") pi("B") ... pi("Z")$
+ Recover key: The $i^"th"$ character of $c$ gives $pi("letter"_i)$

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Minimum plaintext length:* #strong[26 characters]
  
  We need to query each letter exactly once to learn the complete mapping.
]

#v(0.8em)

=== Attack on Vigenère Cipher (Period $t$ Known)

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Cipher:* $c_i = (m_i + k_(i mod t)) mod 26$ where key $= k_0 k_1 ... k_(t-1)$
  
  *Key to recover:* The $t$ shift values $k_0, k_1, ..., k_(t-1)$
]

*Attack:*
+ Choose plaintext: $m = $ "AAA...A" ($t$ copies of 'A')
+ Request encryption: Get $c = c_0 c_1 ... c_(t-1)$
+ Recover key: $k_i = c_i$ for each $i in {0, 1, ..., t-1}$

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Minimum plaintext length:* #strong[$t$ characters] (when period $t$ is known)
  
  Each 'A' at position $i$ encrypts to $k_(i mod t)$, directly revealing each key byte.
]

#v(1em)

== Part (b): Vigenère with Unknown Period

=== Case (i): Period $t$ is Known

As shown above:

#table(
  columns: (auto, auto),
  inset: 10pt,
  align: left,
  fill: (col, _) => if col == 0 { rgb("#f5f5f5") } else { white },
  [*Plaintext*], ["AAA...A" ($t$ times)],
  [*Length required*], [$t$],
  [*Key recovery*], [$k_i = c_i$ directly],
)

=== Case (ii): Period $t$ Unknown, Upper Bound $t_("max")$ Known

We know the period $t <= t_("max")$ but don't know exact $t$.

*Strategy:* Choose a plaintext that works for *any* possible period up to $t_("max")$.

#block(
  fill: rgb("#fff3e0"),
  inset: 12pt,
  radius: 4pt,
)[
  *Approach 1: Brute Force over Periods*
  
  For each candidate period $t' in {1, 2, ..., t_("max")}$:
  - Use a plaintext of length $t'$ (all A's)
  - Check if decryption is consistent
  
  Total queries: $t_("max")$ plaintexts, but we want a *single* plaintext.
]

*Optimal Single-Plaintext Attack:*

Choose plaintext $m = $ "AAA...A" of length $t_("max")$.

+ Request encryption of $m$: Get $c = c_0 c_1 ... c_(t_("max")-1)$
+ The ciphertext directly reveals: $c_i = k_(i mod t)$
+ To find $t$: Look for the *period* of the sequence $c_0, c_1, c_2, ...$

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Finding the period:* The true period $t$ is the smallest value such that:
  $ c_i = c_(i+t) "for all" i in {0, 1, ..., t_("max") - t - 1} $
  
  Once $t$ is found, the key is simply $k = c_0 c_1 ... c_(t-1)$.
]

*Asymptotic Analysis:*

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Minimum plaintext length:* #strong[$O(t_("max"))$]
  
  More precisely: $t_("max")$ characters suffice.
  
  *Reasoning:* With $t_("max")$ characters, we observe at least one complete period of the key (since $t <= t_("max")$), which is sufficient to both:
  1. Determine $t$ by finding the period of the ciphertext
  2. Extract all $t$ key bytes
]

=== Summary Table

#align(center)[
#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: center,
  fill: (_, row) => if row == 0 { rgb("#e0e0e0") } else { white },
  [*Cipher*], [*Key Size*], [*Min Plaintext Length*],
  [Shift], [$1$ value], [#strong[1]],
  [Substitution], [$26$ mappings], [#strong[26]],
  [Vigenère (known $t$)], [$t$ values], [#strong[$t$]],
  [Vigenère (unknown $t$)], [$t$ values, $t <= t_("max")$], [#strong[$O(t_("max"))$]],
)
]

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key Insight:* In the chosen plaintext model, all classical ciphers can be broken with a single, carefully chosen plaintext. The required length equals the size of the key space that needs to be determined.
]
