// Appendix: Prerequisites and Background Concepts
// This file is included at the end of the main answer book

#set heading(numbering: none)

#align(center)[
  #block(
    fill: rgb("#2d3748"),
    inset: 15pt,
    radius: 6pt,
    width: 100%,
  )[
    #text(size: 16pt, weight: "bold", fill: white)[Appendix: Background Concepts & Prerequisites]
  ]
]

#v(1em)

= #text(fill: rgb("#1a365d"))[A. Classical Ciphers] <appendix-ciphers>

== A.1 Shift Cipher (Caesar Cipher) <shift-cipher>

The *shift cipher* encrypts by shifting each letter by a fixed amount.

- *Key:* $k in {0, 1, 2, ..., 25}$
- *Encryption:* $c_i = (m_i + k) mod 26$
- *Decryption:* $m_i = (c_i - k) mod 26$

*Example:* With $k = 3$: A→D, B→E, ..., Z→C

*Security:* Only 26 possible keys — trivially broken by brute force.

#v(0.8em)

== A.2 Substitution Cipher <substitution-cipher>

The *substitution cipher* replaces each letter with another according to a fixed permutation.

- *Key:* A permutation $pi : {A, ..., Z} -> {A, ..., Z}$
- *Encryption:* $c_i = pi(m_i)$
- *Decryption:* $m_i = pi^(-1)(c_i)$

*Key space:* $26! approx 4 times 10^{26}$

*Security:* Despite large key space, vulnerable to *frequency analysis* because each letter always maps to the same ciphertext letter.

#v(0.8em)

== A.3 Vigenère Cipher <vigenere-cipher>

The *Vigenère cipher* uses a repeating keyword to apply different shifts at different positions.

- *Key:* A keyword of length $t$, represented as $k = (k_0, k_1, ..., k_(t-1))$
- *Encryption:* $c_i = (m_i + k_(i mod t)) mod 26$
- *Decryption:* $m_i = (c_i - k_(i mod t)) mod 26$

*Example:* Keyword "KEY" ($t = 3$) with values $(10, 4, 24)$:
- Position 0: shift by 10
- Position 1: shift by 4
- Position 2: shift by 24
- Position 3: shift by 10 (repeats)

*Security:* Stronger than simple substitution but breakable via *Kasiski examination* (finding period) followed by frequency analysis on each position.

#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e0"))

= #text(fill: rgb("#1a365d"))[B. Number Theory Foundations] <appendix-number-theory>

== B.1 Discrete Logarithm Problem (DLP) <dlp>

Let $p$ be a prime and $g$ a generator of the multiplicative group $ZZ_p^* = {1, 2, ..., p-1}$.

*Problem:* Given $y = g^x mod p$, find $x$.

*Properties:*
- *Easy direction:* Computing $g^x mod p$ is efficient (square-and-multiply)
- *Hard direction:* Finding $x$ from $y$ is believed computationally infeasible for large $p$

*Why it matters:* DLP hardness is the foundation of Diffie-Hellman key exchange and many cryptographic constructions.

#v(0.8em)

== B.2 Group Structure of $ZZ_p^*$ <group-structure>

For a prime $p$:
- $ZZ_p^* = {1, 2, ..., p-1}$ under multiplication mod $p$
- Order of the group: $|ZZ_p^*| = p - 1$
- A *generator* $g$ satisfies: ${g^0, g^1, g^2, ..., g^(p-2)} = ZZ_p^*$

When $p - 1 = s dot 2^r$ (with $s$ odd):
- The group has a subgroup of order $2^r$ (easy DLP via Pohlig-Hellman)
- The "hard" part of DLP lives in the subgroup of odd order $s$

#v(0.8em)

== B.3 Pohlig-Hellman Algorithm <pohlig-hellman>

An algorithm that efficiently solves DLP in groups whose order has only *small prime factors*.

*Key insight:* If $|G| = p_1^(e_1) dot p_2^(e_2) dot ... dot p_k^(e_k)$, then:
1. Solve DLP in each subgroup of order $p_i^(e_i)$ separately
2. Combine results using the Chinese Remainder Theorem

*Implication:* For safe cryptographic use, $p - 1$ should have a large prime factor.

#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e0"))

= #text(fill: rgb("#1a365d"))[C. Cryptographic Concepts] <appendix-crypto>

== C.1 One-Way Functions <one-way-functions>

A function $f : X -> Y$ is *one-way* if:
- $f(x)$ is efficiently computable for all $x in X$
- For a random $x$, given $f(x)$, no efficient algorithm can find $x' $ with $f(x') = f(x)$ with non-negligible probability

*Examples:*
- $f(x) = g^x mod p$ (assuming DLP is hard)
- Cryptographic hash functions (e.g., SHA-256)

#v(0.8em)

== C.2 Hard-Core Predicates <hard-core-predicates>

A predicate $B : X -> {0, 1}$ is *hard-core* for one-way function $f$ if:
- $B(x)$ is efficiently computable given $x$
- Given only $f(x)$, predicting $B(x)$ is no better than random guessing

*Formal definition:* For all PPT (probabilistic polynomial-time) adversaries $A$:
$ Pr[A(f(x)) = B(x)] <= 1/2 + "negl"(n) $

*Goldreich-Levin Theorem:* For any OWF $f$, there exists a hard-core predicate (the inner product with a random vector).

#v(0.8em)

== C.3 Pseudo-Random Generators (PRGs) <prg>

A *PRG* is a deterministic function $G : {0,1}^n -> {0,1}^(ell(n))$ where $ell(n) > n$ such that:
- *Expansion:* Output is longer than input
- *Pseudorandomness:* No efficient algorithm can distinguish $G(s)$ from truly random $r in {0,1}^(ell(n))$

*Construction from OWF + Hard-Core Bit (Blum-Micali):*
$ x_(i+1) = f(x_i), quad b_i = B(x_i) $
Output: $b_1 || b_2 || ... || b_n$

#v(0.8em)

== C.4 Computational vs Information-Theoretic Security <security-notions>

#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  fill: (col, _) => if col == 0 { rgb("#e3f2fd") } else { rgb("#fff3e0") },
  [*Information-Theoretic (Perfect)*], [*Computational*],
  [Secure against unbounded adversaries], [Secure against efficient (PPT) adversaries],
  [Cannot be broken even with infinite time], [Could theoretically be broken with enough time],
  [Example: One-Time Pad], [Example: AES, RSA],
  [Requires key ≥ message length], [Short keys can protect long messages],
)

#v(0.8em)

== C.5 Negligible Functions <negligible-functions>

A function $f : NN -> RR$ is *negligible* if it decreases faster than the inverse of any polynomial.

*Formal Definition:* For every positive polynomial $p(n)$, there exists $N in NN$ such that for all $n > N$:
$ |f(n)| < 1/(p(n)) $

*Equivalent Characterization:* $f$ is negligible $<=>$ for all $c > 0$: $lim_(n -> oo) n^c dot f(n) = 0$

*Key Test for $f(n) = 2^(-g(n))$:*
- Negligible if $g(n) = omega(log n)$, i.e., $g(n)/(log n) -> oo$
- NOT negligible if $g(n) = O(log n)$

*Examples:*
- $2^(-n)$, $2^(-sqrt(n))$, $2^(-(log n)^2)$: negligible
- $n^(-100)$, $2^(-sqrt(log n))$: NOT negligible

*Why it matters:* In cryptography, security proofs show that adversary's advantage is negligible in the security parameter $n$.

#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e0"))

= #text(fill: rgb("#1a365d"))[D. Proof Techniques] <appendix-proofs>

== D.1 Security Reduction <reduction>

A *reduction* proves that breaking scheme $S$ implies breaking a hard problem $P$.

*Structure:*
1. Assume an adversary $A$ breaks $S$ with advantage $epsilon$
2. Construct algorithm $B$ that uses $A$ as a subroutine
3. Show $B$ solves $P$ with related advantage

*Contrapositive:* If $P$ is hard, then $S$ is secure.

#v(0.8em)

== D.2 Hybrid Argument <hybrid-argument>

A technique for proving two distributions are indistinguishable.

*Method:*
1. Define a sequence of hybrid distributions: $H_0, H_1, ..., H_n$
2. $H_0$ = first distribution, $H_n$ = second distribution
3. Prove adjacent hybrids $H_i$ and $H_(i+1)$ are indistinguishable
4. By transitivity: $H_0 approx_c H_n$

*Why it works:* If $H_0$ and $H_n$ were distinguishable, some adjacent pair must also be distinguishable (pigeon-hole).

#line(length: 100%, stroke: 0.5pt + rgb("#cbd5e0"))

= #text(fill: rgb("#1a365d"))[E. Kerckhoffs's Principle] <kerckhoffs>

Stated by Auguste Kerckhoffs in 1883:

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *"A cryptosystem should be secure even if everything about the system, except the key, is public knowledge."*
]

*Modern interpretation (Shannon's Maxim):* "The enemy knows the system."

*Implications:*
- Security must rely solely on key secrecy
- Algorithms should be publicly scrutinized
- Never rely on "security through obscurity"

#v(2em)
#align(center)[
  #text(fill: rgb("#718096"), size: 10pt)[— End of Appendix —]
]
