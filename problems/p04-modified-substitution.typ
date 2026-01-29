// Problem 4: Modified Substitution Cipher

= Problem 4:  Modified Substitution Cipher <p04>

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Task:* Consider a modification where we first apply a substitution cipher #link(<substitution-cipher>)[(Appendix A.2)], then apply a shift cipher #link(<shift-cipher>)[(A.1)] on the substituted values. Give a formal description and show how to break this scheme.
]

#v(0.8em)

== Formal Description

=== Notation

- *Alphabet:* $Sigma = {A, B, C, ..., Z}$ with $|Sigma| = 26$
- *Plaintext:* $m = m_1 m_2 ... m_n$ where each $m_i in Sigma$
- *Ciphertext:* $c = c_1 c_2 ... c_n$

=== Key Space

The key consists of two components:

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  $ K = (pi, k) $
  where:
  - $pi : Sigma -> Sigma$ is a *permutation* (bijection) — the substitution key
  - $k in {0, 1, 2, ..., 25}$ — the shift amount
]

*Key space size:* $|cal(K)| = 26! times 26 approx 1.04 times 10^{28}$

=== Encryption

For each plaintext character $m_i$:
$ c_i = (pi(m_i) + k) mod 26 $

Or equivalently:
$ "Enc"_((pi, k))(m) = "Shift"_k ("Sub"_pi (m)) $

=== Decryption

For each ciphertext character $c_i$:
$ m_i = pi^(-1)((c_i - k) mod 26) $

Or equivalently:
$ "Dec"_((pi, k))(c) = "Sub"_(pi^(-1)) ("Shift"_(-k) (c)) $

#v(1em)

== Breaking the Scheme

Despite the large key space, this cipher is *no more secure than a simple substitution cipher*. Here's why and how to break it:

=== Key Observation

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *The composition of a substitution and a shift is just another substitution!*
  
  Define $sigma = "Shift"_k compose pi$, i.e., $sigma(x) = (pi(x) + k) mod 26$
  
  Since both $pi$ and $"Shift"_k$ are permutations, their composition $sigma$ is also a permutation.
]

This means the "enhanced" cipher with key $(pi, k)$ is equivalent to a simple substitution cipher with key $sigma$.

The shift adds *no additional security* — it's redundant!

=== Attack: Frequency Analysis

Since the scheme reduces to a substitution cipher, we use *frequency analysis*:

==== Step 1: Compute Ciphertext Frequencies

Count the frequency of each letter in the ciphertext:
$ f_c (x) = ("|"{i : c_i = x}"|") / n "for each" x in Sigma $

==== Step 2: Compare with Known Language Frequencies

English letter frequencies (approximate):

#align(center)[
#table(
  columns: 13,
  inset: 5pt,
  align: center,
  fill: (_, row) => if row == 0 { rgb("#e0e0e0") } else { white },
  [E], [T], [A], [O], [I], [N], [S], [H], [R], [D], [L], [U], [C],
  [12.7%], [9.1%], [8.2%], [7.5%], [7.0%], [6.7%], [6.3%], [6.1%], [6.0%], [4.3%], [4.0%], [2.8%], [2.8%],
)
]

==== Step 3: Map Most Frequent Ciphertext Letters

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Procedure:*
  + Rank ciphertext letters by frequency
  + Match the most frequent ciphertext letter to 'E' (most common in English)
  + Match the second most frequent to 'T', and so on
  + Refine using common patterns (TH, THE, AND, etc.)
]

==== Step 4: Iterative Refinement

- Look for common digraphs: TH, HE, IN, ER, AN
- Look for common words: THE, AND, OF, TO, A
- Adjust mappings based on context and word patterns
- Use trial decryption and check for meaningful text

=== Complete Attack Algorithm

#block(
  fill: rgb("#fff3e0"),
  inset: 12pt,
  radius: 4pt,
)[
```
Input: Ciphertext c
Output: Plaintext m and key (π, k)

1. Compute frequency distribution of c
2. Initialize σ by matching frequencies to English
3. Decrypt using current σ guess
4. While decryption not readable:
     - Identify likely errors (nonsense patterns)
     - Swap suspected letter mappings
     - Re-decrypt and evaluate
5. Output final σ (which equals the composition of π and shift_k)
```
]

=== Why the Shift Doesn't Help

#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: left,
  fill: (col, _) => if col == 0 { rgb("#fce4e4") } else { rgb("#e8f4e8") },
  [*What you might expect*], [*Reality*],
  [Two layers = harder to break], [Composition = single substitution],
  [Key space: $26! times 26$], [Effective key space: $26!$ (shift is absorbed)],
  [Need to find both $pi$ and $k$], [Only need to find $sigma = pi compose "Shift"_k$],
)

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Conclusion:* The modified cipher can be broken using standard frequency analysis techniques with $O(n)$ letter counting and human-guided (or automated) pattern matching. The shift cipher layer provides *zero additional security* because it merely relabels the already-permuted alphabet.
]

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: Structure vs. Randomness]
  #v(0.3em)
  
  *The Core Insight:* Security comes from destroying structure, not just hiding it.
  
  - *Substitution:* Preserves frequency distribution (Statistically invariant)
  - *Shift:* Preserves adjacency and order
  - *Permutation:* Preserves set membership
  
  When you compose weak operations that preserve the *same* structure, you don't get a strong operation. You just get a slightly messier weak operation.
  
  *Real-World Analogy:* 
  - If you write a secret message in red ink.
  - Then write it backwards.
  - Then translate it to French.
  ... It still has the statistical structure of language!
  
  *Modern Ciphers (AES/DES):* work by *alternating* confusion (removing structure) and diffusion (spreading influence) to truly destroy statistical patterns.
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: Closure Properties of Ciphers]
  #v(0.3em)
  
  This problem illustrates the *closure property*:
  
  $ "Sub" compose "Shift" in "Sub" $
  
  The set of substitution ciphers is closed under composition with shift ciphers.
  
  *Connections:*
  - #link(<p06>)[*P6 (Negligible):*] Closure properties of negligible functions (sum of negligible is negligible).
  - #link(<p09>)[*P9 (PRG Closure):*] Is the set of PRGs closed under XOR? (See $G(x) xor G(x)$).
  - #link(<p27>)[*P27 (OWF Constructions):*] Composition $f(f(x))$ preserves one-wayness.
  
  *Design Lesson:* To build stronger systems, you need components that *don't commute* or close. Example: $"AES"(x) = ... "AddRoundKey" compose "MixColumns" compose "SubBytes" ...$ — mixing linear and non-linear layers!
]
