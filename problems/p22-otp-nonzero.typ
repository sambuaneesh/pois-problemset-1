#import "../preamble.typ": *
// Problem 22: Modified OTP with Non-Zero Keys

= Problem 22:  OTP with Non-Zero Keys Only <p22>

#difficulty("Beginner") #tag("Theory") #tag("PerfectSecrecy")

#scenario-box("The Paranoid Generator")[
  *Intel Report:* A nervous operator refuses to use the key $00...0$ for the One-Time Pad because "encryption shouldn't send the message in cleartext!". He removes it from the key space.

  *Your Mission:* Prove that his "fix" actually breaks the Perfect Secrecy of the system.
]

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Question:* When using the one-time pad with key $k = 0^ell$, we have $"Enc"_k (m) = k xor m = m$ and the message is sent in the clear! It has been suggested to modify OTP by only encrypting with $k != 0^ell$ (i.e., Gen chooses $k$ uniformly from the set of *nonzero* keys of length $ell$). Is this modified scheme still perfectly secret #link(<perfect-secrecy>)[(Appendix C.8)]?
]

#v(0.8em)

== Analysis

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: NO, the modified scheme is NOT perfectly secret.*
]

#v(0.5em)

=== Why Excluding $0^ell$ Breaks Perfect Secrecy

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Perfect Secrecy Requirement:* For all $m_0, m_1 in cal(M)$ and all $c in cal(C)$:
  $ Pr["Enc"_K (m_0) = c] = Pr["Enc"_K (m_1) = c] $
]

*The problem:* Consider the ciphertext $c = m$ (i.e., ciphertext equals plaintext).

In standard OTP:
$ Pr["Enc"_K (m) = m] = Pr[K = 0^ell] = 1/2^ell $

In modified OTP (excluding $k = 0^ell$):
$ Pr["Enc"_K (m) = m] = Pr[K = 0^ell | K != 0^ell] = 0 $

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  *The violation:*
  
  Consider messages $m_0$ and $m_1 != m_0$, and ciphertext $c = m_0$.
  
  - $Pr["Enc"_K (m_0) = m_0] = 0$ (would need $k = 0^ell$, but that's excluded)
  - $Pr["Enc"_K (m_1) = m_0] = 1/(2^ell - 1)$ (the key $k = m_1 xor m_0 != 0^ell$)
  
  Since $0 != 1/(2^ell - 1)$, perfect secrecy is violated!
]

#v(0.5em)

=== Information Leaked

If an adversary sees ciphertext $c$, they can immediately rule out the message $m = c$ (since that would require the forbidden key $k = 0^ell$).

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Intuition:* Perfect secrecy requires that every ciphertext is equally likely for every plaintext. By removing even one key, we create a "hole" — some (message, ciphertext) pairs become impossible, leaking information.
]

#v(0.5em)

=== Formal Statement

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Shannon's Theorem implication:* Perfect secrecy requires $|cal(K)| >= |cal(M)|$.
  
  Originally: $|cal(K)| = 2^ell = |cal(M)|$ ✓
  
  After modification: $|cal(K)| = 2^ell - 1 < 2^ell = |cal(M)|$ ✗
  
  The key space is now strictly smaller than the message space, making perfect secrecy impossible.
]

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: Coverage is Mandatory]
  #v(0.3em)
  
  *The "Perfect" Standard:* To be perfectly secret, an adversary who sees a ciphertext $c$ must admit: "This could be *any* message $m$."
  
  - If even *one* message $m$ becomes impossible for a given $c$, you have leaked information (specifically, "It's not m").
  - This requires every ciphertext to be "reachable" from every message.
  
  *Real-World Lesson:* Bias is fatal.
  - If your RNG never outputs 0, you lose perfect secrecy (as shown here).
  - If your RNG outputs even numbers slightly more often, you lose perfect secrecy (bias accumulates).
  - *RC4 (WEP):* Failed because the first few bytes of output were biased!
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: Key Space vs. Message Space]
  #v(0.3em)
  
  The inequality $|K| < |M|$ is the *fundamental limit* of information-theoretic security.
  
  *Connections:*
  - #link(<p08>)[*P8 (Key Distribution):*] Shows we can assume uniform keys. If the distribution has a "hole" (prob 0), it's like reducing the key space.
  - #link(<p11>)[*P11 (Variable Length):*] Shows that mismatching lengths effectively disjoints the message spaces, breaking secrecy.
  - #link(<p10>)[*P10 (2-Time Pad):*] Reusing the key reduces the *effective* key space relative to the total message size (2 messages vs 1 key), breaking security.
]
