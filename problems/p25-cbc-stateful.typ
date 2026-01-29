// Problem 25: Stateful CBC-Mode and Ciphertext Length

= Problem 25: CBC Mode Variants

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Tasks:*
  + Consider a stateful variant of CBC-mode #link(<cbc>)[(Appendix G.2)] where the sender increments the IV by 1 each time a message is encrypted (rather than choosing IV at random). Show this scheme is NOT CPA-secure #link(<eav-cpa>)[(C.7)].
  + Say CBC-mode encryption uses a block cipher with 256-bit key and 128-bit block length to encrypt a 1024-bit message. What is the length of the resulting ciphertext?
]

#v(0.8em)

== Part (a): Stateful CBC with Incremented IV is NOT CPA-Secure

=== The Scheme

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Stateful CBC-mode:*
  - State: counter $"ctr"$ (initially 0 or some value)
  - Encryption of $m = m_1 || m_2 || ... || m_ell$:
    - IV $= "ctr"$
    - $c_0 = "IV"$
    - $c_i = F_k (m_i xor c_(i-1))$ for $i = 1, ..., ell$
    - Update: $"ctr" := "ctr" + 1$
  - Output: $(c_0, c_1, ..., c_ell)$
]

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Claim: This scheme is NOT CPA-secure.*
]

=== The Attack

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  *CPA Attack:*
  
  1. *Learn the current IV:* Query encryption of any single-block message $m'$.
     - Receive $(c_0, c_1)$ where $c_0 = "IV"_1$ is the current IV
     - Now the adversary knows the next IV will be $"IV"_2 = "IV"_1 + 1$
  
  2. *Craft challenge messages:*
     - Let $m_0 = $ any single block, say $0^n$
     - Let $m_1 = m_0 xor "IV"_1 xor "IV"_2 = m_0 xor 1$ (XOR with the IV difference)
  
  3. *Submit challenge:* Receive encryption of $m_b$ with IV $= "IV"_2$
     - Challenge ciphertext: $(c_0^*, c_1^*) = ("IV"_2, F_k (m_b xor "IV"_2))$
  
  4. *Request another encryption:* Query $m' = 0^n$ again with IV $= "IV"_3$
  
  Wait, let me give a cleaner attack...
]

=== Cleaner Attack

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Alternative Attack (exploiting predictable IV):*
  
  1. Query encryption of message $m = 0^n$ to learn current IV (call it $"IV"_1$)
  
  2. The next IV is $"IV"_2 = "IV"_1 + 1$ (predictable!)
  
  3. Choose challenge messages:
     - $m_0 = "IV"_2$ (single block)
     - $m_1 = "IV"_2 xor 1$ (single block)
  
  4. Receive challenge ciphertext $(c_0^*, c_1^*)$ where:
     - If $b = 0$: $c_1^* = F_k (m_0 xor "IV"_2) = F_k (0^n)$
     - If $b = 1$: $c_1^* = F_k (m_1 xor "IV"_2) = F_k (1)$
  
  5. Query encryption of message $m'' = 0^n$ (IV $= "IV"_3$, but we observe $c_0''$)
     
     Actually, simpler: query message $m'' = "IV"_3$ with the new IV...
]

=== Simplest Attack

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Definitive Attack:*
  
  *Setup:* The adversary can predict IV values because they increment.
  
  1. Query encryption of $m = $ any message. Learn $"IV"_1$ from $c_0$.
  
  2. Compute $"IV"_2 = "IV"_1 + 1$ (known to adversary!)
  
  3. Submit challenge: $m_0 = 0^n$, $m_1 = 1 || 0^(n-1)$
     - Receive $(c_0^*, c_1^*)$ with $"IV" = "IV"_2$
     - $c_1^* = F_k (m_b xor "IV"_2)$
  
  4. Query encryption of message $m' = "IV"_2$ (so $m' xor "IV"_3 = "IV"_2 xor "IV"_3$)
     - Actually use: query message $= "IV"_2$ and check if first ciphertext block matches...
  
  *Key insight:* Query a message $m'$ such that $m' xor "IV"_3 = m_0 xor "IV"_2 = "IV"_2$
  
  This requires $m' = "IV"_2 xor "IV"_3 = "IV"_2 xor ("IV"_2 + 1)$
  
  If this query's first ciphertext block equals $c_1^*$, then $b = 0$.
]

=== Clean Version of Attack

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *The attack works because:*
  
  With predictable IVs, the adversary can craft queries that produce the same PRF input as the challenge, allowing them to detect which message was encrypted.
  
  *Distinguishing advantage: 1* (the attack is deterministic)
]

#v(1em)

== Part (b): CBC Ciphertext Length

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Given:*
  - Block cipher key: 256 bits (irrelevant for length calculation)
  - Block size: $n = 128$ bits
  - Message length: 1024 bits
]

*Calculation:*

1. *Number of message blocks:* $1024 / 128 = 8$ blocks

2. *CBC ciphertext structure:* IV $||$ $c_1$ $||$ $c_2$ $||$ ... $||$ $c_8$

3. *Components:*
   - IV: 128 bits (1 block)
   - Ciphertext blocks: $8 times 128 = 1024$ bits

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Total ciphertext length:*
  $ 128 + 1024 = bold(1152 " bits") $
  
  Or equivalently: $9 times 128 = 1152$ bits = *144 bytes*
]

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Note:* The key size (256 bits) does not affect ciphertext length. It only affects:
  - Security level
  - Key schedule complexity
  
  Ciphertext length depends only on block size and message length.
]
