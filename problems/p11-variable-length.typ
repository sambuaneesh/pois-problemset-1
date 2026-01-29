#import "../preamble.typ": *
// Problem 11: Variable-Length Perfect Secrecy

= Problem 11:  Perfect Secrecy for Variable-Length Messages <p11>

#difficulty("Beginner") #tag("Theory") #tag("LengthExtension")

#scenario-box("The Length Leak")[
  *Intel Report:* A new encryption scheme handles messages of *variable length*, but the ciphertext length perfectly matches the message length.

  *Your Mission:* Show why revealing the *length* of the message inherently breaks the strict definition of Perfect Secrecy.
]

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Setting:* The message space is $cal(M) = {0,1}^(<= ell)$, the set of all nonempty binary strings of length at most $ell$.
  
  *Tasks:*
  + Consider the encryption scheme where $"Gen"$ chooses a uniform key from $cal(K) = {0,1}^ell$, and $"Enc"_k (m) = k_(|m|) xor m$, where $k_t$ denotes the first $t$ bits of $k$. Show that this scheme is *not* perfectly secret for message space $cal(M)$.
  
  + Design a perfectly secret encryption scheme for message space $cal(M)$.
]

#v(0.8em)

== Part (a): The Scheme is NOT Perfectly Secret

*The Encryption Scheme:*
- *Key space:* $cal(K) = {0,1}^ell$
- *Key generation:* Sample $k arrow.l {0,1}^ell$ uniformly
- *Encryption:* $"Enc"_k (m) = k_(|m|) xor m$ (use first $|m|$ bits of $k$, XOR with $m$)

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Claim:* This scheme is *NOT* perfectly secret.
]

*Proof by counterexample:*

Perfect secrecy requires that for all $m_0, m_1 in cal(M)$ and all ciphertexts $c$:
$ Pr["Enc"_K (m_0) = c] = Pr["Enc"_K (m_1) = c] $

We will find $m_0, m_1$, and $c$ that violate this.

*Counterexample:*

Let:
- $m_0 = 0$ (a single bit message of length 1)
- $m_1 = 00$ (a two-bit message of length 2)
- $c = 0$ (a single bit ciphertext of length 1)

*Compute $Pr["Enc"_K (m_0) = c]$:*

$"Enc"_k (m_0) = "Enc"_k (0) = k_1 xor 0 = k_1$ (the first bit of $k$)

For this to equal $c = 0$, we need $k_1 = 0$.

$ Pr["Enc"_K (0) = 0] = Pr[k_1 = 0] = 1/2 $

*Compute $Pr["Enc"_K (m_1) = c]$:*

$"Enc"_k (m_1) = "Enc"_k (00) = k_2 xor 00 = k_2$ (the first 2 bits of $k$)

The ciphertext is a 2-bit string. For this to equal $c = 0$ (a 1-bit string):

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  *The ciphertext lengths don't match!*
  
  $"Enc"_k (00)$ produces a 2-bit output, but $c = 0$ is a 1-bit string.
  
  Therefore: $Pr["Enc"_K (00) = 0] = 0$
]

*Conclusion:*

$ Pr["Enc"_K (0) = 0] = 1/2 != 0 = Pr["Enc"_K (00) = 0] $

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *The scheme is NOT perfectly secret because the ciphertext length reveals the message length!*
  
  An adversary seeing a ciphertext of length $t$ knows the message has exactly $t$ bits.
]

$square$

#v(1em)

== Part (b): A Perfectly Secret Scheme for $cal(M)$

*Goal:* Design an encryption scheme that hides both the message content AND the message length.

=== Key Idea: Pad All Messages to Maximum Length

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Strategy:* 
  1. Encode the message with its length
  2. Pad to fixed length $ell$
  3. Use one-time pad encryption
]

=== Construction

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key Space:* $cal(K) = {0,1}^(ell + ceil(log_2 ell))$
  
  *Gen:* Sample $k arrow.l cal(K)$ uniformly. Parse $k = k_"pad" || k_"len"$ where:
  - $k_"pad" in {0,1}^ell$ (for padding the message)
  - $k_"len" in {0,1}^(ceil(log_2 ell))$ (for hiding the length)
  
  *Encryption* $"Enc"_k (m)$: 
  1. Let $t = |m|$ be the message length
  2. Pad $m$ to length $ell$: $m' = m || 0^(ell - t)$
  3. Encode length: $t' = t xor k_"len"$
  4. Encrypt: $c = m' xor k_"pad"$
  5. Output $(c, t')$
  
  *Decryption* $"Dec"_k (c, t')$:
  1. Recover length: $t = t' xor k_"len"$
  2. Decrypt: $m' = c xor k_"pad"$
  3. Output first $t$ bits of $m'$
]

=== Proof of Perfect Secrecy

*Claim:* This scheme is perfectly secret for $cal(M) = {0,1}^(<= ell)$.

*Proof:*

For any two messages $m_0, m_1 in cal(M)$ and any ciphertext $(c, t')$:

$ Pr["Enc"_K (m_0) = (c, t')] &= Pr[m_0 || 0^(ell - |m_0|) xor k_"pad" = c "and" |m_0| xor k_"len" = t'] \
&= Pr[k_"pad" = c xor (m_0 || 0^(ell - |m_0|))] times Pr[k_"len" = t' xor |m_0|] \
&= 1/(2^ell) times 1/(2^(ceil(log_2 ell))) $

Similarly:
$ Pr["Enc"_K (m_1) = (c, t')] = 1/(2^ell) times 1/(2^(ceil(log_2 ell))) $

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Both probabilities are equal and independent of the message!*
  
  Therefore, the scheme is perfectly secret. $square$
]

=== Alternative Simpler Construction

If ciphertext length is allowed to be fixed at $ell + ceil(log_2 ell)$:

#block(
  fill: rgb("#fff3e0"),
  inset: 12pt,
  radius: 4pt,
)[
  *Simpler version:*
  - *Key:* $k in {0,1}^(ell + ceil(log_2 ell))$
  - *Encryption:* $"Enc"_k (m) = k xor (m || 0^(ell - |m|) || "bin"(|m|))$
  
  where $"bin"(|m|)$ is the binary encoding of the length.
  
  This directly XORs the (padded message + length encoding) with the full key.
]

#v(0.5em)

#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: left,
  fill: (col, _) => if col == 0 { rgb("#fce4e4") } else { rgb("#e8f4e8") },
  [*Original Scheme (NOT secure)*], [*Fixed Scheme (Secure)*],
  [Ciphertext length = message length], [Ciphertext length = fixed ($ell + O(log ell)$)],
  [Leaks message length], [Hides message length],
  [Key size: $ell$ bits], [Key size: $ell + ceil(log_2 ell)$ bits],
)

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: You Cannot Hide Length "For Free"]
  #v(0.3em)
  
  *The Fundamental Trade-off:* To hide the length of a message, you MUST pad it to the *maximum possible length*.
  
  *Why?*
  - If distinct message lengths produce distinct ciphertext lengths, the ciphertext leaks information about the message.
  - This breaks *Perfect Secrecy* ($Pr[C=c | M=m_0] = Pr[C=c | M=m_1]$) if $m_0$ is short and $m_1$ is long.
  
  *Real-World Impact:*
  - *Traffic Analysis:* Even if encrypted, packet sizes reveal what you're doing (e.g., streaming video vs typing text).
  - *CRIME/BREACH Attacks:* Compression + Encryption leaks length, which leaks data!
  - *Modern Protocols (TLS 1.3):* Support padding to hide exact lengths, but full hiding is too expensive (bandwidth cost).
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: Side-Channel Leakage]
  #v(0.3em)
  
  Length is a side channel. Other side channels include timing, power, and sound.
  
  *Connections:*
  - #link(<p01>)[*P1 (Security Models):*] Perfect secrecy is a *theoretical* model. In practice, length is often accepted as "leaked."
  - #link(<p05>)[*P5 (CPA):*] Indistinguishability games usually require $|m_0| = |m_1|$ to avoid trivial wins based on length.
  - #link(<p17>)[*P17 (CPA):*] Standard definitions *exempt* length from secrecy requirements. We only demand $"Enc"(m_0) approx "Enc"(m_1)$ when $|m_0|=|m_1|$.
]
