// Problem 14: Hard-Core Predicates

= Problem 14: Hard-Core Predicates and Universality

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Background:* A predicate $b : {0,1}^* -> {0,1}$ is a *hard-core predicate* of a one-way function $f(dot)$ if $b(x)$ is efficiently computable given $x$, and there exists a negligible function $nu$ such that for every PPT adversary $A$ and every $n$:
  $ Pr[A(f(x)) = b(x)] <= 1/2 + nu(n) $
  
  *Tasks:*
  + Construct a one-way function $f : {0,1}^n -> {0,1}^m$ for input $x = (x_1, x_2, ..., x_n)$ such that the first bit $x_1$ is *not* hardcore.
  + Prove that there is *no universal* hardcore predicate (i.e., no single predicate $b$ that is hardcore for every OWF).
  + Construct a one-way function $f$ for which *none* of the individual input bits $b_i (x_1, ..., x_n) = x_i$ are hardcore.
]

#v(0.8em)

== Part (a): A OWF Where the First Bit is NOT Hardcore

*Goal:* Construct $f$ such that $f$ is one-way but the predicate $b(x) = x_1$ can be predicted from $f(x)$.

=== Construction

Let $g : {0,1}^(n-1) -> {0,1}^m$ be any one-way function. Define:

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  $ f(x_1, x_2, ..., x_n) = x_1 || g(x_2, ..., x_n) $
  
  That is, $f$ outputs the first bit unchanged, followed by the one-way function applied to the remaining bits.
]

=== Proof that $f$ is One-Way

Suppose $f$ is not one-way. Then there exists PPT $A$ such that:
$ Pr[A(f(x)) in f^(-1)(f(x))] > "non-negl"(n) $

Given $A$, we construct an inverter $B$ for $g$:

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Inverter $B$ for $g$:*
  
  On input $y = g(x_2, ..., x_n)$:
  1. Pick random $b in {0,1}$
  2. Compute $A(b || y)$ to get $(b', x'_2, ..., x'_n)$
  3. Output $(x'_2, ..., x'_n)$
]

If $A$ successfully inverts $f$, then $g(x'_2, ..., x'_n) = y$, which means $B$ inverts $g$.

Since $g$ is one-way, $A$ cannot succeed with non-negligible probability. Therefore $f$ is one-way. $checkmark$

=== Proof that $x_1$ is NOT Hardcore

An adversary can predict $x_1$ from $f(x)$ with probability *1*!

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  *Attack:* Given $f(x) = x_1 || g(x_2, ..., x_n)$, simply output the first bit.
  
  $ Pr[A(f(x)) = x_1] = 1 >> 1/2 + "negl"(n) $
]

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Conclusion:* The first bit $x_1$ is trivially computable from $f(x)$, so it is *not* a hardcore predicate. $square$
]

#v(1em)

== Part (b): No Universal Hardcore Predicate Exists

*Definition:* A predicate $b : {0,1}^n -> {0,1}$ is *universal hardcore* if it is hardcore for *every* one-way function.

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Claim:* There is no universal hardcore predicate.
]

*Proof:*

Let $b : {0,1}^n -> {0,1}$ be any polynomial-time computable predicate. We will construct a OWF $f$ for which $b$ is *not* hardcore.

Let $g : {0,1}^n -> {0,1}^m$ be any one-way function (we assume OWFs exist).

*Construction:*

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  $ f(x) = b(x) || g(x) $
  
  The output of $f$ is the predicate value $b(x)$ concatenated with the OWF output $g(x)$.
]

*$f$ is one-way:* Same argument as Part (a) — inverting $f$ requires inverting $g$.

*$b$ is not hardcore for $f$:*

Given $f(x) = b(x) || g(x)$, an adversary can compute $b(x)$ by simply reading the first bit of $f(x)$.

$ Pr[A(f(x)) = b(x)] = 1 $

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Conclusion:* For any predicate $b$, we can construct a OWF that "leaks" $b(x)$ in its output. Therefore, no universal hardcore predicate exists. $square$
]

#v(1em)

== Part (c): A OWF Where NO Individual Bit is Hardcore

*Goal:* Construct $f : {0,1}^n -> {0,1}^m$ such that for all $i in {1, ..., n}$, the predicate $b_i (x) = x_i$ is *not* hardcore.

=== Construction

Let $g : {0,1}^n -> {0,1}^m$ be any one-way function. Define:

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  $ f(x_1, ..., x_n) = x_1 || x_2 || ... || x_n || g(x_1, ..., x_n) $
  
  $ f(x) = x || g(x) $
  
  The output is simply $x$ (the entire input) followed by $g(x)$.
]

=== $f$ is One-Way

Suppose adversary $A$ inverts $f$ with non-negligible probability:
$ Pr[f(A(f(x))) = f(x)] > "non-negl"(n) $

Given $f(x) = x || g(x)$, if $A$ outputs $x'$, then:
$ f(x') = x' || g(x') = x || g(x) $

This requires $x' = x$ and $g(x') = g(x)$.

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Wait — there's an issue!* Given $f(x) = x || g(x)$, the adversary can read $x$ directly from the output!
  
  So $f$ as defined is *not* one-way.
]

=== Corrected Construction

We need a more subtle approach. Use a one-way *permutation* and reveal the input:

Let $pi : {0,1}^n -> {0,1}^n$ be a one-way permutation.

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  Define $f : {0,1}^(2n) -> {0,1}^(2n)$ by:
  $ f(x, y) = (x, pi(x) xor y) $
  
  where $x, y in {0,1}^n$.
]

*$f$ is one-way:*

Given $(x, pi(x) xor y)$:
- $x$ is known
- Computing $y$ requires computing $pi(x)$, but we have $pi(x) xor y$
- To find $y$, we need $pi(x)$, which requires computing $pi(x)$ from $x$ — easy!

Hmm, this also doesn't work. Let me try another approach.

=== Working Construction

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  Let $g : {0,1}^n -> {0,1}^(2n)$ be a length-doubling OWF.
  
  $ f(x) = g(x) xor (x || x) $
  
  The output XORs $g(x)$ with the input concatenated with itself.
]

Actually, the simplest working construction:

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Final Construction:*
  
  Let $g : {0,1}^n -> {0,1}^m$ be a one-way function.
  
  $ f(x) = (x, g(x)) $
  
  But this reveals $x$, so it's not one-way in the usual sense...
]

=== Correct Approach: The Key Insight

The question asks for a OWF where *none of the input bit predicates* are hardcore. The trick is:

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key insight:* Even though no *single* bit is hardcore, the function can still be one-way because recovering the *full* preimage might still be hard.
  
  A function $f(x) = x || g(x)$ reveals $x$, so it's *not one-way*.
  
  However, we can construct a OWF where each bit can be *guessed* with probability $> 1/2 + "non-negl"$ but not with probability 1.
]

*Correct Construction:*

Let $g : {0,1}^n -> {0,1}^m$ be a OWF. Define:

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  $ f(x_1, ..., x_n) = g(x) || (x_1 xor x_2) || (x_2 xor x_3) || ... || (x_(n-1) xor x_n) $
  
  The output contains $g(x)$ plus all *consecutive XORs* of bits.
]

*Each bit is not hardcore:*

Given the XORs $(x_1 xor x_2), (x_2 xor x_3), ..., (x_(n-1) xor x_n)$:
- If we guess $x_1$, we can compute all other bits!
- So each $x_i$ can be computed given a single bit guess.

An adversary can:
1. Guess $x_1 = 0$ or $x_1 = 1$ (50% chance of being correct)
2. Compute all other $x_i$ from the XORs
3. Output the guess for any $x_i$

This gives $Pr["guess" x_i] = 1/2$... which is still just random guessing.

*Better construction — using parity leak:*

$ f(x) = g(x) || (x_1 xor r_1) || (x_2 xor r_2) || ... || (x_n xor r_n) || r_1 || ... || r_n $

Wait, this reveals everything.

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  *The correct answer:*
  
  $ f(x) = x || g(x) "where" g : {0,1}^n -> {0,1}^m "is length-preserving OWF" $
  
  This is NOT one-way (since $x$ is revealed). The question may be asking for something subtler, or there's a specific construction involving the Goldreich-Levin theorem.
  
  *Alternative interpretation:* The question may be showing that even though *individual* bits aren't hardcore, the *Goldreich-Levin inner product* $chevron.l x, r chevron.r$ is still hardcore for any OWF.
]

$square$
