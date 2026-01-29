// Problem 23: CPA-Secure Encryption Construction

= Problem 23: CPA-Secure Encryption with Randomization

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Setup:* Let $("Gen", "Enc", "Dec")$ be a CPA-secure encryption scheme. Construct $("Gen"_1, "Enc"_1, "Dec"_1)$:
  
  - $"Gen"_1 (1^n)$: $k arrow.l "Gen"(1^n)$
  - $"Enc"_1 (k, m)$: Sample $r arrow.l {0,1}^n$ uniformly. $c_0 := "Enc"(k, r)$, $c_1 := r xor m$. Output $c = (c_0, c_1)$.
  
  *Tasks:*
  + Fill in the decryption algorithm $"Dec"_1 (k, (c_0, c_1))$ for correct decryption.
  + Prove that $("Gen"_1, "Enc"_1, "Dec"_1)$ satisfies CPA security.
]

#v(0.8em)

== Part (a): Decryption Algorithm

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *$"Dec"_1 (k, (c_0, c_1))$:*
  
  1. Compute $r := "Dec"(k, c_0)$
  2. Compute $m := c_1 xor r$
  3. Output $m$
]

*Correctness verification:*

Given $c = (c_0, c_1)$ where $c_0 = "Enc"(k, r)$ and $c_1 = r xor m$:

$ "Dec"_1(k, (c_0, c_1)) &= c_1 xor "Dec"(k, c_0) \
&= (r xor m) xor r \
&= m $

#v(1em)

== Part (b): CPA Security Proof

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Theorem:* If $("Gen", "Enc", "Dec")$ is CPA-secure, then $("Gen"_1, "Enc"_1, "Dec"_1)$ is also CPA-secure.
]

#v(0.5em)

=== Proof by Hybrid Argument

*Game 0 (Real CPA game for scheme 1):*
- Adversary interacts with $"Enc"_1$ oracle
- Each query: $r arrow.l {0,1}^n$, returns $("Enc"(k, r), r xor m)$
- Challenge: Encrypt $m_b$ for random $b$

*Game 1 (Replace $r$ with random string in challenge):*
- Same as Game 0, but in the challenge ciphertext, use a truly random $s$ independent of $r$
- Challenge returns $("Enc"(k, r), s)$ where $s$ is uniform random

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Claim 1:* Games 0 and 1 are computationally indistinguishable.
  
  *Proof:* The value $r$ is encrypted under a CPA-secure scheme in $c_0$. If an adversary could distinguish whether $c_1 = r xor m_b$ or $c_1 = s$ (random), they could extract information about $r$ from $c_0 = "Enc"(k, r)$, breaking CPA security of the underlying scheme.
  
  Formally: We reduce to CPA security of $("Gen", "Enc", "Dec")$.
]

*In Game 1:*
- The challenge ciphertext is $("Enc"(k, r), s)$ where $s$ is random
- The value $s$ is independent of $m_0$ and $m_1$
- Hence $s$ provides no information about which message was "encrypted"

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Conclusion:* In Game 1, the adversary has advantage 0 (the challenge ciphertext is independent of $b$).
  
  Since Game 0 ≈ Game 1, the adversary's advantage in Game 0 is negligible.
]

#v(0.5em)

=== Formal Reduction

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Reduction $cal(B)$ (breaking CPA of underlying scheme):*
  
  Given access to "Enc" oracle and CPA challenge:
  
  1. *Simulate $"Enc"_1$ oracle for $cal(A)$:* 
     - On query $m$: sample $r$, query own oracle for $"Enc"(k, r)$ to get $c_0$, return $(c_0, r xor m)$
  
  2. *Handle challenge:*
     - $cal(A)$ submits challenge messages $m_0, m_1$
     - Sample $r^*$, submit $(r^*, s^*)$ to own CPA challenger where $s^*$ is random
     - Receive $c_0^* = "Enc"(k, r^*)$ or $"Enc"(k, s^*)$
     - Sample random bit $b'$, give $cal(A)$ the ciphertext $(c_0^*, r^* xor m_(b'))$
     - If $cal(A)$ guesses $b'$ correctly AND we're in real case, output 0
     
  This links the advantage of $cal(A)$ to breaking the underlying scheme.
]

#v(0.5em)

=== Why This Construction Works

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key insight:* The message $m$ is "one-time padded" with $r$, and $r$ is protected by CPA-secure encryption.
  
  - $c_1 = r xor m$ is information-theoretically secure given $r$ is unknown
  - $c_0 = "Enc"(k, r)$ hides $r$ computationally (CPA security)
  - Together: CPA security of the construction
  
  This is essentially how hybrid encryption works!
]
