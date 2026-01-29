#import "../preamble.typ": *
// Problem 12: PRF Constructions

= Problem 12:  PRF or Not? <p12>

#difficulty("Intermediate") #tag("Design") #tag("Extension")

#scenario-box("The Infinite Stream")[
  *Intel Report:* We have a "Doubling Generator" that turns $n$ bits into $2n$ bits. We need to stretch it further.

  *Your Mission:* Analyze constructions to turn this small generator into a massive random function. Which blueprint works?
]

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Setup:* Let $f : {0,1}^n times {0,1}^n -> {0,1}^n$ be a pseudorandom function (PRF). For each construction $f'$ below, either prove that $f'$ is a PRF (for all choices of $f$), or prove that $f'$ is not a PRF.
  
  + $f'_k (x) := f_k (0 || x) || f_k (1 || x)$
  + $f'_k (x) := f_k (0 || x) || f_k (x || 1)$
]

#v(0.8em)

== Background: PRF Definition

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Pseudorandom Function (PRF)* #link(<prf>)[(Appendix C.6)]*:* A keyed function $f : {0,1}^n times {0,1}^n -> {0,1}^n$ is a PRF if no efficient adversary can distinguish between:
  - Oracle access to $f_k (dot)$ for random $k$
  - Oracle access to a truly random function $R : {0,1}^n -> {0,1}^n$
  
  Formally: For all PPT distinguishers $D$:
  $ |Pr[D^(f_k (dot)) = 1] - Pr[D^(R(dot)) = 1]| <= "negl"(n) $
]

#v(1em)

== Part (a): $f'_k (x) := f_k (0 || x) || f_k (1 || x)$

*Note:* Here the input $x$ has length $n-1$ bits (so that $0 || x$ and $1 || x$ are $n$ bits each).

The output is $2n$ bits (concatenation of two $n$-bit values).

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: YES, $f'$ is a PRF.*
]

*Proof by reduction:*

Suppose $f'$ is not a PRF. Then there exists a PPT distinguisher $D'$ that can distinguish $f'_k$ from a random function $R' : {0,1}^(n-1) -> {0,1}^(2n)$ with non-negligible advantage.

We construct a distinguisher $D$ that breaks $f$:

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Distinguisher $D$ with oracle access to $O$ (either $f_k$ or random $R$):*
  
  1. When $D'$ queries $x in {0,1}^(n-1)$:
     - Query $O(0 || x)$ to get $y_0$
     - Query $O(1 || x)$ to get $y_1$
     - Return $y_0 || y_1$ to $D'$
  2. Output whatever $D'$ outputs
]

*Analysis:*

*Case 1: $O = f_k$ (real PRF)*

$D$ simulates $f'_k$ perfectly:
$ D'"'s view" = f_k (0 || x) || f_k (1 || x) = f'_k (x) $

*Case 2: $O = R$ (random function)*

$D$ simulates a random function on pairs of inputs:
- $R(0 || x)$ and $R(1 || x)$ are independent random values
- Their concatenation is uniformly random in ${0,1}^(2n)$
- Different inputs $x != x'$ give independent outputs

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key observation:* The inputs $0 || x$ and $1 || x$ are *always distinct* (they differ in the first bit), so $R(0 || x)$ and $R(1 || x)$ are independent.
  
  Furthermore, inputs $0 || x$ and $0 || x'$ for $x != x'$ are distinct, so all queries produce independent random outputs.
]

Therefore:
$ Pr[D^(f_k) = 1] = Pr[D'^(f'_k) = 1] $
$ Pr[D^R = 1] = Pr[D'^(R') = 1] $

If $D'$ has non-negligible advantage, so does $D$. This contradicts that $f$ is a PRF. $square$

#v(1em)

== Part (b): $f'_k (x) := f_k (0 || x) || f_k (x || 1)$

*Note:* Here the input $x$ has length $n-1$ bits (so that $0 || x$ and $x || 1$ are $n$ bits each).

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: NO, $f'$ is NOT necessarily a PRF.*
]

*Counterexample:*

Consider what happens when we query specific related inputs.

*The attack:*

Query $f'$ on two specific inputs:
- $x_1 = 0^(n-2) || 1$ (i.e., $00...01$)
- $x_2 = 1 || 0^(n-2)$ (i.e., $10...00$)

Compute the corresponding PRF queries:

For $x_1 = 0^(n-2) 1$:
- $0 || x_1 = 0 || 0^(n-2) || 1 = 0^(n-1) || 1$
- $x_1 || 1 = 0^(n-2) || 1 || 1 = 0^(n-2) || 11$

For $x_2 = 1 || 0^(n-2)$:
- $0 || x_2 = 0 || 1 || 0^(n-2) = 01 || 0^(n-2)$
- $x_2 || 1 = 1 || 0^(n-2) || 1 = 1 || 0^(n-2) || 1$

Hmm, these don't immediately collide. Let me reconsider...

*Better attack — finding a collision:*

Let $x_1$ such that $0 || x_1 = x_2 || 1$ for some $x_2$.

This means: $x_2 = 0 || x_1[1..n-2]$ and $x_1[n-1] = 1$.

Specifically, if $x_1 = a || 1$ for some $a in {0,1}^(n-2)$, then:
$ 0 || x_1 = 0 || a || 1 $

And if $x_2 = 0 || a$, then:
$ x_2 || 1 = 0 || a || 1 $

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  *Collision found!*
  
  For $x_1 = a || 1$ and $x_2 = 0 || a$ (where $a in {0,1}^(n-2)$):
  $ 0 || x_1 = x_2 || 1 $
  
  This means $f_k (0 || x_1) = f_k (x_2 || 1)$.
]

*The distinguishing attack:*

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Distinguisher $D$:*
  
  1. Choose any $a in {0,1}^(n-2)$
  2. Let $x_1 = a || 1$ and $x_2 = 0 || a$
  3. Query $f'(x_1) = f_k(0 || x_1) || f_k(x_1 || 1)$ — call the first half $A$
  4. Query $f'(x_2) = f_k(0 || x_2) || f_k(x_2 || 1)$ — call the second half $B$
  5. Check if $A = B$ (i.e., first half of $f'(x_1)$ equals second half of $f'(x_2)$)
  6. If yes, output "real PRF"; if no, output "random"
]

*Analysis:*

*If $f'$ is built from $f$:*

We have $0 || x_1 = x_2 || 1$ (by construction), so:
$ f_k (0 || x_1) = f_k (x_2 || 1) $

Therefore $A = B$ *always*. The check passes with probability 1.

*If $f'$ is a truly random function:*

The first half of $f'(x_1)$ and the second half of $f'(x_2)$ are independent random $n$-bit strings.
$ Pr[A = B] = 1/(2^n) $

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Distinguishing advantage:*
  $ |1 - 1/(2^n)| = 1 - "negl"(n) approx 1 $
  
  This is overwhelming! The construction is completely broken. $square$
]

#v(1em)

== Summary

#align(center)[
#table(
  columns: (auto, 1fr, auto, 1fr),
  inset: 10pt,
  align: (center, left, center, left),
  fill: (_, row) => if row == 0 { rgb("#1a365d") } else if calc.rem(row, 2) == 0 { rgb("#f7fafc") } else { white },
  table.header(
    [#text(fill: white)[*Part*]], 
    [#text(fill: white)[*Construction*]], 
    [#text(fill: white)[*PRF?*]],
    [#text(fill: white)[*Reason*]]
  ),
  [(a)], [$f_k (0||x) || f_k (1||x)$], [#text(fill: rgb("#4CAF50"))[*YES*]], [Inputs always differ in first bit → no collisions],
  [(b)], [$f_k (0||x) || f_k (x||1)$], [#text(fill: rgb("#d9534f"))[*NO*]], [Collision: $0||x_1 = x_2||1$ is exploitable],
)
]

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key Insight:* When constructing PRFs from PRFs, ensure that the internal queries *never collide* for different external inputs. In part (a), prepending 0 and 1 guarantees distinct inputs. In part (b), the overlap between "prepend 0" and "append 1" creates exploitable collisions.
]

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: Domain Separation]
  #v(0.3em)
  
  *The Design Principle:* When using the same key for multiple purposes (like generating two outputs), you must ensure the inputs live in separate "domains."
  
  *How to do it:* Prepending a *prefix* is the standard way.
  - $F_k("len" || x)$ vs $F_k("mac" || x)$
  - $F_k(0 || x)$ vs $F_k(1 || x)$ (Part a)
  
  *Why Part (b) Failed:* Prepending '0' vs Appending '1' is *not* a clean separation. The domains overlap ($0...1$ belongs to both!), causing collisions.
  
  *Real-World Example:* HKDF (HMAC-based Key Derivation Function) uses "info" strings to strictly separate derived keys.
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Pattern: Prefix-Free Encoding]
  #v(0.3em)
  
  To safely combine inputs, you need a *prefix-free code* or fixed-length formatting.
  
  *Connections:*
  - #link(<p09>)[*P9 (PRG):*] Similar issues. $G(x||y)$ vs $G(x||0)$ — structure matters.
  - #link(<p21>)[*P21 (XOR PRF):*] Algebraic combinations (XOR) are another way domains can "collide" algebraically.
  - #link(<p13>)[*P13 (Counter):*] Counters $0, 1, 2...$ are efficient domain separators.
]
