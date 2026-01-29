// Problem 17: EAV vs CPA Security

= Problem 17:  EAV-Security vs CPA-Security <p17>

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Setup:* Let $F$ be a length-preserving pseudorandom function and $G$ be a pseudorandom generator with expansion factor $ell(n) = n + 1$. For each encryption scheme below, state whether it is EAV-secure and whether it is CPA-secure. The shared key $k in {0,1}^n$ is uniform.
  
  + To encrypt $m in {0,1}^(n+1)$, choose uniform $r in {0,1}^n$ and output ciphertext $chevron.l r, G(r) xor m chevron.r$.
  + To encrypt $m in {0,1}^(n+1)$, choose uniform $r in {0,1}^n$ and output ciphertext $chevron.l r, G(r) xor m chevron.r$.
  
  + To encrypt $m in {0,1}^n$, output ciphertext $m xor F_k (0^n)$.
  
  + To encrypt $m in {0,1}^(2n)$, parse $m$ as $m_1 || m_2$ with $|m_1| = |m_2|$, then choose uniform $r in {0,1}^n$ and send $chevron.l r, m_1 xor F_k (r), m_2 xor F_k (r + 1) chevron.r$.
]

#v(0.8em)

== Background: Security Notions

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *EAV-Security (Eavesdropper)* #link(<eav-cpa>)[(Appendix C.7)]*:* Adversary sees ONE ciphertext of a chosen message. Cannot distinguish which of two messages was encrypted.
  
  *CPA-Security (Chosen Plaintext):* Adversary has ACCESS to encryption oracle. Can request encryptions of arbitrary messages, then tries to distinguish challenge ciphertext.
]

#v(1em)

== Scheme 1: $"Enc"(m) = chevron.l r, G(r) xor m chevron.r$ where $r arrow.l {0,1}^n$

*Note:* This scheme does NOT use the key $k$ at all!

=== EAV-Security Analysis

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *EAV-Secure: YES*
]

*Proof:*

For a single encryption:
- $r$ is uniformly random
- $G(r)$ is pseudorandom (indistinguishable from uniform $U_(n+1)$)
- $G(r) xor m$ is therefore pseudorandom (XOR with fixed message preserves pseudorandomness)

An EAV adversary seeing $(r, G(r) xor m)$ cannot distinguish $m_0$ from $m_1$ because $G(r) xor m_0$ and $G(r) xor m_1$ are both pseudorandom.

=== CPA-Security Analysis

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *CPA-Secure: NO*
]

*Attack:*

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  1. Request encryption of $m' = 0^(n+1)$
  2. Receive $(r', G(r') xor 0^(n+1)) = (r', G(r'))$
  3. Now the adversary knows $G(r')$ for some $r'$
  4. Submit challenge messages $m_0, m_1$
  5. If challenge uses same $r = r'$, can compute $G(r) xor m_b$ and determine $b$
  
  *Better attack:* Since the scheme doesn't use key $k$, the adversary can compute $G(r)$ themselves for any $r$!
  
  Given challenge $(r^*, c^*)$, compute $G(r^*)$ and check if $c^* xor G(r^*) = m_0$ or $m_1$.
]

*Success probability: 1* (deterministic attack)

#v(1em)

== Scheme 2: $"Enc"(m) = m xor F_k (0^n)$

*Note:* This is deterministic encryption — same message always produces same ciphertext.

=== EAV-Security Analysis

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *EAV-Secure: YES*
]

*Proof:*

For a single encryption, $F_k (0^n)$ is a fixed pseudorandom value (depending only on $k$).

The ciphertext $m xor F_k (0^n)$ is pseudorandom because:
- $F_k (0^n)$ is indistinguishable from uniform (by PRF security)
- XOR with a fixed message preserves this property

An EAV adversary cannot distinguish which message was encrypted.

=== CPA-Security Analysis

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *CPA-Secure: NO*
]

*Attack:*

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  Deterministic encryption is NEVER CPA-secure!
  
  1. Request encryption of $m_0$: receive $c_0 = m_0 xor F_k (0^n)$
  2. Submit challenge messages $m_0, m_1$
  3. Receive challenge ciphertext $c^* = m_b xor F_k (0^n)$
  4. If $c^* = c_0$, output $b = 0$; else output $b = 1$
  
  *Success probability: 1*
]

#v(1em)

== Scheme 3: $"Enc"(m_1 || m_2) = chevron.l r, m_1 xor F_k (r), m_2 xor F_k (r + 1) chevron.r$

*Note:* This is essentially CTR mode with a random starting counter.

=== EAV-Security Analysis

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *EAV-Secure: YES*
]

*Proof:*

For a single encryption with random $r$:
- $F_k (r)$ and $F_k (r+1)$ are pseudorandom (by PRF security)
- They are also independent (different inputs to PRF)
- $m_1 xor F_k (r)$ and $m_2 xor F_k (r+1)$ are both pseudorandom

The ciphertext reveals nothing about $m_1, m_2$ to an EAV adversary.

=== CPA-Security Analysis

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *CPA-Secure: YES*
]

*Proof:*

This is randomized encryption using a PRF in counter mode.

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Why CPA-secure:*
  
  1. Each encryption uses fresh random $r$
  2. With overwhelming probability, all counter values $(r, r+1)$ across all encryptions are distinct (assuming counter space is large enough)
  3. PRF outputs on distinct inputs are indistinguishable from independent random values
  4. Therefore, each encryption is essentially a one-time pad with fresh randomness
]

Formally, by a hybrid argument:
- Replace $F_k$ with truly random function $R$
- Condition on no counter collisions (negligible probability)
- In this case, all pad values are independent and uniform

#v(1em)

== Summary

#align(center)[
#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: center,
  fill: (_, row) => if row == 0 { rgb("#1a365d") } else if calc.rem(row, 2) == 0 { rgb("#f7fafc") } else { white },
  table.header(
    [#text(fill: white)[*Scheme*]], 
    [#text(fill: white)[*EAV-Secure?*]], 
    [#text(fill: white)[*CPA-Secure?*]]
  ),
  [1: $chevron.l r, G(r) xor m chevron.r$], [#text(fill: rgb("#4CAF50"))[YES]], [#text(fill: rgb("#d9534f"))[NO] (key-less)],
  [2: $m xor F_k (0^n)$], [#text(fill: rgb("#4CAF50"))[YES]], [#text(fill: rgb("#d9534f"))[NO] (deterministic)],
  [3: $chevron.l r, m_1 xor F_k (r), m_2 xor F_k (r+1) chevron.r$], [#text(fill: rgb("#4CAF50"))[YES]], [#text(fill: rgb("#4CAF50"))[YES] (CTR mode)],
)
]

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key Insights:*
  
  - *EAV $arrow.r.not$ CPA:* Schemes 1 and 2 show that EAV security does NOT imply CPA security
  - *Deterministic encryption* is never CPA-secure (Scheme 2)
  - *Key-less encryption* leaks the pad (Scheme 1)
  - *Randomized PRF-based schemes* (like CTR mode in Scheme 3) can achieve CPA security
]

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: The Security Hierarchy]
  #v(0.3em)
  
  *The Core Insight:* Security notions form a hierarchy based on *how much power the adversary has*:
  
  $ "CPA-secure" arrow.r.double "EAV-secure" arrow.r.double "Semantic security" $
  
  *But the reverse is FALSE:* EAV $arrow.r.not$ CPA. This problem shows exactly why.
  
  *Intuitive Understanding:*
  - *EAV (passive):* Adversary is like someone reading your mail — they see messages but can't influence what's sent
  - *CPA (active):* Adversary is like someone who can *trick you into encrypting specific messages* — much more powerful!
  
  *The Three Failure Modes:*
  
  #table(
    columns: (auto, 1fr),
    inset: 8pt,
    fill: (col, _) => if col == 0 { rgb("#ffebee") } else { white },
    [*Scheme 1*], [No key → adversary learns the "mask" $G(r)$ by encrypting zeros],
    [*Scheme 2*], [Deterministic → same message gives same ciphertext → trivial to detect],
    [*Scheme 3*], [✅ Fresh randomness + PRF = unpredictable pads every time],
  )
  
  *Real-World Lesson:* HTTPS uses modes similar to Scheme 3. Earlier protocols that reused IVs (like WEP) failed like Schemes 1-2.
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: The Three Requirements for CPA Security]
  #v(0.3em)
  
  Every CPA-secure scheme needs ALL of these:
  
  + *Randomization:* Each encryption must be different even for the same message
  + *Key-dependence:* The randomization must use the secret key (otherwise adversary can simulate it)  
  + *Independence:* The "randomness" for one message must be unpredictable from others
  
  *Check against the schemes:*
  - Scheme 1: Randomized ✅, Key-dependent ❌, fails
  - Scheme 2: Randomized ❌, deterministic, fails
  - Scheme 3: Randomized ✅, Key-dependent ✅, Independent ✅, succeeds!
  
  *Connections:*
  - *P20, P25 (Block Cipher Modes):* CBC, CTR achieve CPA via randomization + PRF
  - *P23 (CPA Construction):* Tests whether modifications preserve CPA security
  - *P10 (Two-time Security):* What happens when randomization fails (nonce reuse)
]
