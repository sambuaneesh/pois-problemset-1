#import "../preamble.typ": *
// Problem 20: Block Cipher Modes and Dropped Blocks

= Problem 20:  Dropped Ciphertext Blocks & CTR Mode Security <p20>

#difficulty("Advanced") #tag("Protocol") #tag("ModesOfOperation")

#scenario-box("The Packet Loss Mystery")[
  *Intel Report:* We are broadcasting encrypted video over a lossy radio link (UDP). Packets get dropped frequently.

  *Your Mission:* Determine which encryption mode (CBC, OFB, or CTR) will let the video keep playing with minor glitches, and which ones will turn the screen to static noise forever.
]

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Tasks:*
  + What is the effect of a dropped ciphertext block (e.g., $c_1, c_2, c_3, ...$ received as $c_1, c_3, ...$) when using CBC #link(<cbc>)[(G.2)], OFB #link(<ofb>)[(G.4)], and CTR #link(<ctr>)[(G.3)] modes?
  + Consider CTR mode variant where $c_i := m_i xor F_k ("IV" + i)$ with uniform IV. Prove CPA-security #link(<eav-cpa>)[(C.7)] and give a concrete security bound.
]

#v(0.8em)

== Part (a): Effect of Dropped Blocks

Consider dropping block $c_2$, so receiver gets $c_1, c_3, c_4, ...$ instead of $c_1, c_2, c_3, c_4, ...$

#v(0.5em)

=== CBC Mode (Cipher Block Chaining)

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *CBC Decryption:* $m_i = D_k (c_i) xor c_(i-1)$
  
  *Normal:* IV, $c_1$, $c_2$, $c_3$, ... → $m_1$, $m_2$, $m_3$, ...
  
  *With $c_2$ dropped:* IV, $c_1$, $c_3$, $c_4$, ...
  - $m'_1 = D_k (c_1) xor "IV" = m_1$ ✓
  - $m'_2 = D_k (c_3) xor c_1 != m_3$ (uses wrong chaining block)
  - $m'_3 = D_k (c_4) xor c_3 = m_4$ ✓ (resynchronizes!)
]

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *CBC impact:* 
  - One block ($m_3$) lost entirely
  - One block ($m'_2$) is garbled (wrong chaining)
  - Remaining blocks decrypt correctly (self-synchronizing)
]

#v(0.5em)

=== OFB Mode (Output Feedback)

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *OFB:* Generates keystream independent of ciphertext
  - $z_0 = "IV"$, $z_i = F_k (z_(i-1))$
  - $c_i = m_i xor z_i$, $m_i = c_i xor z_i$
  
  *With $c_2$ dropped:* Receiver computes $z_1, z_2, z_3, ...$ correctly but:
  - $m'_1 = c_1 xor z_1 = m_1$ ✓
  - $m'_2 = c_3 xor z_2 != m_3$ (wrong keystream block!)
  - $m'_3 = c_4 xor z_3 != m_4$ (still wrong!)
  - All subsequent blocks are garbled
]

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *OFB impact:* 
  - One block lost
  - ALL subsequent blocks are garbled (permanent desynchronization)
  - Does NOT self-synchronize
]

#v(0.5em)

=== CTR Mode (Counter)

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Standard CTR:* $c_i = m_i xor F_k ("IV" || i)$ where $i$ is embedded in ciphertext
  
  If counter is transmitted with each block (or can be inferred):
  - Each block decrypts independently: $m_i = c_i xor F_k ("IV" || i)$
  
  *With $c_2$ dropped:*
  - $m'_1 = c_1 xor F_k ("IV" || 1) = m_1$ ✓  
  - $m'_2 = c_3 xor F_k ("IV" || 3) = m_3$ ✓
  - All blocks decrypt correctly (just $m_2$ is missing)
]

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *CTR impact:* 
  - Only the dropped block is lost
  - All other blocks decrypt correctly
  - Most resilient to block loss
]

#v(0.5em)

=== Summary Table

#align(center)[
#table(
  columns: (auto, auto, auto, auto),
  inset: 10pt,
  align: (center, center, center, center),
  fill: (_, row) => if row == 0 { rgb("#1a365d") } else if calc.rem(row, 2) == 0 { rgb("#f7fafc") } else { white },
  table.header(
    [#text(fill: white)[*Mode*]], 
    [#text(fill: white)[*Blocks Lost*]], 
    [#text(fill: white)[*Blocks Garbled*]],
    [#text(fill: white)[*Self-Sync?*]]
  ),
  [CBC], [1], [1 (next block)], [Yes],
  [OFB], [1], [All subsequent], [No],
  [CTR], [1], [0], [N/A (independent)],
)
]

#v(1em)

== Part (b): CTR Mode Variant CPA Security

*The variant:* $c_i := m_i xor F_k ("IV" + i)$ where IV is uniform in ${0,1}^n$.

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Theorem:* This CTR mode variant is CPA-secure if $F$ is a PRF.
]

#v(0.5em)

=== Proof Outline

*Step 1: Replace PRF with random function*

Let $R : {0,1}^n -> {0,1}^n$ be a truly random function. Consider the modified scheme:
$ c_i := m_i xor R("IV" + i) $

By PRF security: Any distinguisher between $F_k$ and $R$ gives advantage at most $epsilon_"PRF"$.

*Step 2: Analyze security with random function*

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key observation:* For the scheme to be insecure, we need a collision in counter values across different encryptions.
  
  If encryption $j$ uses $"IV"_j$ and encrypts $ell_j$ blocks, the counters used are:
  $ {"IV"_j + 1, "IV"_j + 2, ..., "IV"_j + ell_j} $
  
  A *collision* occurs if $"IV"_j + i = "IV"_(j') + i'$ for different $(j, i) != (j', i')$.
]

*Step 3: Bound collision probability*

Suppose the adversary makes $q$ encryption queries, each of length at most $ell$ blocks.

Total counter values used: at most $q dot ell$.

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Birthday bound:* The probability of any collision among $q dot ell$ counter values is:
  $ Pr["collision"] <= ((q dot ell)^2) / (2 dot 2^n) = (q^2 ell^2) / 2^(n+1) $
]

*Step 4: Conditioned on no collision*

If no collision occurs, all pad values $R("IV" + i)$ across all encryptions are:
- Independent
- Uniformly random

This is information-theoretically secure (like many independent one-time pads).

#v(0.5em)

=== Concrete Security Bound

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Theorem:* For any CPA adversary $cal(A)$ making $q$ queries of total length at most $q dot ell$ blocks:
  
  $ "Adv"_"CPA" (cal(A)) <= epsilon_"PRF" + (q^2 ell^2) / 2^(n+1) $
  
  where $epsilon_"PRF"$ is the PRF advantage of the best distinguisher with $q dot ell$ queries.
]

*Interpretation:*
- The scheme remains secure as long as $q dot ell << 2^(n/2)$
- For $n = 128$ (AES), this allows about $2^64$ total blocks before birthday attacks become concerning

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Concrete example:* With $n = 128$, $q = 2^30$ queries, $ell = 2^10$ blocks each:
  $ (q^2 ell^2) / 2^129 = (2^60 dot 2^20) / 2^129 = 2^80 / 2^129 = 2^(-49) $
  
  This is negligible — the scheme is very secure!
]

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: Mode Properties = Trade-offs]
  #v(0.3em)
  
  Each block cipher mode makes different trade-offs. This problem reveals a key dimension: *error resilience*.
  
  #table(
    columns: (auto, auto, auto, auto),
    inset: 8pt,
    fill: (_, row) => if row == 0 { rgb("#e0e0e0") } else { white },
    [*Mode*], [*Dropped Block*], [*Bit Flip*], [*Why?*],
    [*CBC*], [2 blocks affected], [2 blocks], [Chaining means errors propagate forward once],
    [*OFB*], [ALL subsequent], [1 block], [Keystream independent, but position-dependent],
    [*CTR*], [Only that block], [1 block], [Each block decrypts independently],
  )
  
  *The Design Insight:* CTR mode wins for error resilience because encryption is *stateless* — each block uses its counter, not the previous block.
  
  *Real-World Consequences:*
  - *Network protocols (UDP):* CTR preferred because packets can arrive out of order or be lost
  - *Disk encryption:* CTR/XTS preferred for random access
  - *Streaming (TCP):* CBC acceptable because order is guaranteed
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: The Birthday Bound in Cryptography]
  #v(0.3em)
  
  The security bound $(q^2 ell^2)/2^(n+1)$ follows the *birthday paradox* pattern:
  
  - With $2^n$ possible values and $Q$ queries, collision probability ≈ $Q^2 / 2^n$
  - Once collisions happen, security degrades
  
  *You'll see this pattern everywhere:*
  - *P13 (CTR nonce collision):* Same analysis
  - *P25 (CBC stateful IV):* Birthday bound on IV reuse
  - *Hash collisions:* $2^(n/2)$ messages to find collision in $n$-bit hash
  
  *The Practical Rule:* For $n$-bit security, you get about $2^(n/2)$ "safe" operations. For AES-128, that's $2^64$ blocks — sounds huge, but at 100 Gbps, you hit it in a few years!
  
  *Connections:*
  - *P17 (Scheme 3):* Same CTR security proof
  - *P26 (Negligibility):* When $2^(-49)$ counts as "secure"
]
