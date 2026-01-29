// Problem 16: Cryptographic Constructions

= Problem 16:  Constructing Primitives from Other Primitives <p16>

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Task:* Give complete details of how to construct $Y$ from $X$ where:
  
  + $X =$ One-way permutation #link(<one-way-functions>)[(C.1)], $Y =$ Pseudorandom generator #link(<prg>)[(C.3)]
  + $X =$ Pseudorandom generator #link(<prg>)[(C.3)], $Y =$ One-way function #link(<one-way-functions>)[(C.1)]
  + $X =$ Pseudorandom generator #link(<prg>)[(C.3)], $Y =$ Pseudorandom function #link(<prf>)[(C.6)]
]

#v(0.8em)

== Part (a): One-Way Permutation → PRG

*Goal:* Construct a PRG from a one-way permutation (OWP).

=== The Blum-Micali / Goldreich-Levin Construction

Let $f : {0,1}^n -> {0,1}^n$ be a one-way permutation.

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Hard-core predicate (Goldreich-Levin):* For any OWP $f$, the inner product:
  $ b(x, r) = chevron.l x, r chevron.r = plus.o.big_(i=1)^n x_i dot r_i mod 2 $
  is a hard-core predicate for $f'(x, r) = (f(x), r)$.
]

=== PRG Construction

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *PRG $G : {0,1}^n -> {0,1}^(n+1)$:*
  
  $ G(s) = f(s) || b(s) $
  
  where $b(s)$ is a hard-core bit for $f$ (e.g., the parity of $s$ if $f$ is appropriately structured, or use Goldreich-Levin with a public random $r$).
]

*Output:* $n + 1$ bits from an $n$-bit seed → expansion by 1 bit.

=== Why This is a PRG

*Proof sketch:*

Suppose distinguisher $D$ can distinguish $G(U_n)$ from $U_(n+1)$.

- $G(U_n) = (f(U_n), b(U_n))$
- $U_(n+1) = (U_n, U_1)$ (independent uniform bits)

Since $f$ is a permutation, $f(U_n)$ is uniform over ${0,1}^n$.

The only difference is: Is the last bit $b(U_n)$ or independent random?

By the hard-core property, $b(s)$ cannot be predicted from $f(s)$ better than $1/2 + "negl"(n)$.

Therefore, $D$ cannot distinguish $arrow.r.double$ $G$ is a PRG. $square$

=== Extending to More Bits

To get $G : {0,1}^n -> {0,1}^(n + k)$ for polynomial $k$:

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Iterate:*
  
  $ s_0 = s $
  $ s_(i+1) = f(s_i), "output bit" b_i = b(s_i) $
  
  Final output: $s_k || b_1 || b_2 || ... || b_k$
]

#v(1em)

== Part (b): PRG → One-Way Function

*Goal:* Construct a OWF from a PRG.

=== Construction

Let $G : {0,1}^n -> {0,1}^(2n)$ be a length-doubling PRG.

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *One-way function $f$:*
  
  $ f(s) = G(s) $
  
  Simply use the PRG as the one-way function!
]

=== Proof that $f$ is One-Way

*Claim:* If $G$ is a PRG, then $f(s) = G(s)$ is a one-way function.

*Proof by contradiction:*

Suppose $f$ is not one-way. Then there exists PPT inverter $I$ such that:
$ Pr[f(I(f(s))) = f(s)] > "non-negl"(n) $

We construct a PRG distinguisher $D$:

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Distinguisher $D$:*
  
  On input $y in {0,1}^(2n)$:
  1. Run $s' = I(y)$
  2. If $G(s') = y$, output "PRG" (i.e., $y = G(s)$ for some $s$)
  3. Else output "random"
]

*Analysis:*

- If $y = G(s)$ for random $s$: $I$ succeeds with non-negligible probability, so $D$ outputs "PRG"
- If $y$ is truly random: $y in "Image"(G)$ with probability $|{0,1}^n| / |{0,1}^(2n)| = 2^n / 2^(2n) = 2^(-n)$ (negligible!)

So $D$ distinguishes with non-negligible advantage, contradicting PRG security. $square$

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key insight:* The PRG "compresses" the seed, so most strings in ${0,1}^(2n)$ are NOT in the image of $G$. This asymmetry allows distinguishing and proves one-wayness.
]

#v(1em)

== Part (c): PRG → PRF (The GGM Construction)

*Goal:* Construct a PRF from a PRG.

=== The GGM Tree Construction

Let $G : {0,1}^n -> {0,1}^(2n)$ be a length-doubling PRG.

Write $G(s) = G_0 (s) || G_1 (s)$ where $G_0, G_1 : {0,1}^n -> {0,1}^n$ are the left and right halves.

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *PRF $F : {0,1}^n times {0,1}^n -> {0,1}^n$:*
  
  For key $k in {0,1}^n$ and input $x = x_1 x_2 ... x_n in {0,1}^n$:
  
  $ F_k (x) = G_(x_n) (G_(x_(n-1)) (... G_(x_2) (G_(x_1) (k)) ...)) $
  
  That is, start with $k$, and for each bit $x_i$ of the input:
  - If $x_i = 0$: take the left half of $G$
  - If $x_i = 1$: take the right half of $G$
]

=== Pictorial Representation

#block(
  fill: rgb("#fff3e0"),
  inset: 12pt,
  radius: 4pt,
)[
  *Binary tree of depth $n$:*
  
  ```
  Level 0 (root):     k
                     / \
  Level 1:       G₀(k)  G₁(k)
                 / \     / \
  Level 2:   G₀G₀(k) G₁G₀(k) G₀G₁(k) G₁G₁(k)
                ...
  Level n:   F_k(0...00)  F_k(0...01)  ...  F_k(1...11)
  ```
  
  Each leaf corresponds to one input $x$, and $F_k (x)$ is the value at that leaf.
]

=== Why This is a PRF

*Proof by hybrid argument (sketch):*

Define hybrids $H_0, H_1, ..., H_n$ where:

- $H_0$: Real PRF $F_k$
- $H_i$: First $i$ levels of the tree are replaced with truly random values
- $H_n$: Completely random function

*Adjacent hybrids are indistinguishable:*

$H_i$ and $H_(i+1)$ differ only in whether level $i+1$ values are computed via $G$ or are random.

At level $i$, the values are either:
- PRG outputs (derived from level $i-1$)
- Already random

Replacing $G(s)$ with random values is indistinguishable by PRG security (for each node at level $i$).

By a union bound over polynomially many nodes queried, adjacent hybrids are indistinguishable.

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Conclusion:* $H_0 approx_c H_n$, so $F_k$ is indistinguishable from a random function.
  
  Therefore, $F$ is a PRF. $square$
]

#v(1em)

== Summary Table

#align(center)[
#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: left,
  fill: (_, row) => if row == 0 { rgb("#1a365d") } else if calc.rem(row, 2) == 0 { rgb("#f7fafc") } else { white },
  table.header(
    [#text(fill: white)[*From (X)*]], 
    [#text(fill: white)[*To (Y)*]], 
    [#text(fill: white)[*Construction*]]
  ),
  [OWP], [PRG], [$G(s) = f(s) || b(s)$ (hard-core bit)],
  [PRG], [OWF], [$f(s) = G(s)$ (direct use)],
  [PRG], [PRF], [GGM tree: $F_k (x) = G_(x_n)(... G_(x_1)(k))$],
)
]

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Relationships:*
  
  $ "OWP" arrow.r "PRG" arrow.r "PRF" arrow.r "OWF" $
  
  And also: $"PRG" arrow.r "OWF"$ directly.
  
  This shows that OWPs are a strong assumption that implies all other primitives!
]

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: The "Minicrypt" World]
  #v(0.3em)
  
  *The Impagliazzo Worlds:*
  - *Minicrypt:* OWFs exist. We have symmetric crypto (PRG, PRF, CPA/CCA Encryption, Signatures).
  - *Cryptomania:* OWPs exist (maybe trapdoors). We have Public Key Crypto, OT, MPC.
  
  This problem builds the infrastructure of "Minicrypt":
  1.  *OWP $\to$ PRG:* Goldreich-Levin (Turn hardness into randomness)
  2.  *PRG $\to$ PRF:* GGM Tree (Turn small randomness into huge random-access function)
  3.  *PRF $\to$ Encryption:* CPA Security (Part #link(<p13>)[P13])
  
  *It all starts with One-Wayness.* If OWFs don't exist, symmetric cryptography is dead (all encryption is breakable).
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: Tree-Based Constructions (GGM)]
  #v(0.3em)
  
  The *GGM Tree* construction is a fundamental pattern for expanding domains:
  
  - *Length:* Expands $n$-bit seed to $2^n$ outputs.
  - *Structure:* Binary tree path determines the value.
  
  *Where else this appears:*
  - *Merkle Trees:* Hashing up a tree to verify membership (Integrity).
  - *Ratchet Trees (Signal):* Deriving keys for group chats.
  - *Key Derivation:* Deriving subkeys hierarchically.
  
  *Connections:*
  - #link(<p02>)[*P2 (PRG):*] The atomic building block.
  - #link(<p13>)[*P13 (Weak PRF):*] Building stronger primitives from weaker ones.
]
