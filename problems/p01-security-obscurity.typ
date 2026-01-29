// Problem 1: Security Through Obscurity

= Problem 1:  Security Through Obscurity <p01>

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Scenario:* A company designs a proprietary encryption system for internal communications. Initially, both the algorithm and secret key are known only to the company. After several years, the algorithm documentation is leaked publicly, but the secret keys remain unknown.
]

#v(0.8em)

== Part (a): Design Assumption Flaw

*Question:* Assume that the system faces a successful attack shortly after the algorithm is revealed, even though the keys are still secret. What does this suggest about the original design assumptions?

*Answer:*

The successful attack after the algorithm leak reveals a critical flaw in the system's design: the company relied on *security through obscurity*.

This means the system's security depended not just on the secrecy of the key, but also on keeping the algorithm itself secret. This is a fundamentally weak approach because:

+ *The algorithm was not robust:* A well-designed encryption algorithm should remain secure even when its internal workings are fully known. The only secret should be the key.

+ *False sense of security:* The company assumed that hiding the algorithm provided an additional layer of protection. Once this "layer" was removed (via the leak), the system collapsed—proving it was never truly secure.

+ *Violation of Kerckhoffs's Principle:* This principle states that a cryptographic system should be secure even if everything about the system, except the key, is public knowledge. The company's system clearly violated this.

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key Takeaway:* If knowing the algorithm is enough to break the system (even without the key), then the algorithm itself is flawed and the design assumptions were incorrect.
]

#v(1em)

== Part (b): General Design Guideline

*Question:* State a general design guideline for cryptographic systems regarding which components may be assumed public and which must remain secret.

*Answer:*

The fundamental guideline is *Kerckhoffs's Principle* #link(<kerckhoffs>)[(see Appendix E)] (also known as Shannon's Maxim in its modern form):

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *"A cryptographic system should be secure even if everything about the system, except the key, is public knowledge."*
]

This translates to the following design rules:

#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: left,
  fill: (col, _) => if col == 0 { rgb("#f5f5f5") } else { white },
  [*May Be Public*], [*Must Remain Secret*],
  [
    - Encryption algorithm
    - Decryption algorithm
    - Protocol specifications
    - Implementation details
    - Mathematical foundations
  ],
  [
    - Secret keys
    - Private keys (in asymmetric systems)
    - Session keys
    - Key derivation seeds
  ],
)

*Rationale:*
- Algorithms can be reverse-engineered, leaked, or discovered over time
- Public algorithms undergo widespread scrutiny, leading to discovery and fixing of vulnerabilities
- Security concentrated in a small, manageable secret (the key) is easier to protect and rotate
- Keys can be changed easily; algorithms cannot be changed without massive overhaul

#v(1em)

== Part (c): Forward Secrecy vs. Backward Secrecy

*Question:* Explain and differentiate between forward and backward secrecy.

*Answer:*

These are properties that protect encrypted communications even if long-term secret keys are compromised.

=== Forward Secrecy (a.k.a. Perfect Forward Secrecy - PFS)

*Definition:* If a long-term secret key is compromised in the future, previously encrypted messages remain secure and cannot be decrypted.

*How it works:*
- Each session uses a unique, ephemeral session key
- Session keys are derived independently and deleted after use
- Compromising the long-term key doesn't reveal past session keys

*Example:* Alice and Bob communicate using TLS with Diffie-Hellman key exchange. Even if an attacker later obtains the server's private key, they cannot decrypt old recorded conversations because each session used a unique ephemeral key that no longer exists.

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Forward Secrecy protects the PAST from future key compromise.*
]

=== Backward Secrecy (a.k.a. Future Secrecy)

*Definition:* If a session key or secret is compromised, future communications remain secure and cannot be decrypted.

*How it works:*
- Keys are updated or rotated regularly
- New keys are derived in a way that knowing the old key doesn't help compute the new one (one-way derivation)
- Often achieved through key ratcheting mechanisms

*Example:* In the Signal Protocol, after every message, the encryption key is "ratcheted" forward. If an attacker compromises the current key, they cannot decrypt future messages because new keys are derived using one-way functions.

#block(
  stroke: (left: 2pt + rgb("#2196F3")),
  inset: (left: 10pt, y: 5pt),
)[
  *Backward Secrecy protects the FUTURE from current key compromise.*
]

=== Comparison Table

#table(
  columns: (1fr, 1fr, 1fr),
  inset: 10pt,
  align: left,
  fill: (_, row) => if row == 0 { rgb("#e0e0e0") } else { white },
  [*Aspect*], [*Forward Secrecy*], [*Backward Secrecy*],
  [Protects], [Past communications], [Future communications],
  [Threat], [Future key compromise], [Current key compromise],
  [Mechanism], [Ephemeral session keys], [Key ratcheting / rotation],
  [Key insight], [Old keys are deleted], [New keys are independent],
  [Example], [TLS with DHE/ECDHE], [Signal Protocol],
)

#v(0.5em)

*Practical Note:* Modern secure messaging protocols (like Signal, WhatsApp's encryption) implement *both* forward and backward secrecy using a "double ratchet" algorithm, ensuring that compromise of any single key has limited impact on overall communication security.

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: Why This Matters]
  #v(0.3em)
  
  *The Core Pattern:* Security should come from *one well-protected secret* (the key), not from hiding how the system works.
  
  *Why?* Because:
  - Algorithms get leaked, reverse-engineered, or independently discovered
  - Public scrutiny makes algorithms *stronger*, not weaker
  - A small secret (key) is easier to protect, rotate, and revoke than an entire system
  
  *Real-World Examples:*
  - *AES*: The algorithm is public, published by NIST, studied by thousands of cryptographers — yet it remains secure because security lies in the 256-bit key
  - *Intel ME vulnerabilities*: Proprietary "security through obscurity" in Intel chips has been repeatedly broken once researchers reverse-engineered it
  - *CSS (DVD encryption)*: A proprietary algorithm that was quickly broken once DeCSS reverse-engineered it
  
  *Pattern Recognition:* Whenever you see a system that relies on *keeping the method secret*, ask: "What happens when (not if) this method is discovered?" Good systems survive disclosure.
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Connections to Other Concepts]
  #v(0.3em)
  
  - *PRGs/PRFs (P9, P12, P19):* These are public algorithms — anyone can implement them. Security comes from the secret seed/key.
  - *CPA Security (P5, P17, P23):* The attacker knows the algorithm and can even get encryptions of chosen messages. The system must still be secure.
  - *OWFs (P18, P27):* The function itself is public; security comes from computational hardness, not secrecy.
  
  *The Meta-Pattern:* Throughout this problem set, you'll see that *the adversary always knows the algorithm*. This is by design — it's the only way to build truly robust security.
]
