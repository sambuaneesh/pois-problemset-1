// Problem 26: Negligibility Characterization

= Problem 26:  Negligibility of $2^(-f(n))$ <p26>

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  Define functions $g(n) = 2^(-f(n))$.
  
  + Prove that if $f(n) = omega(log n)$, then $g(n)$ is negligible #link(<negligible-functions>)[(Appendix C.5)].
  + Prove that if $f(n) = O(log n)$, then $g(n)$ is non-negligible.
]

#v(0.8em)

== Background: Negligibility Definition

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  A function $g : NN -> RR^(>=0)$ is *negligible* if for every polynomial $p(n)$:
  $ exists N "such that" forall n > N : g(n) < 1/(p(n)) $
  
  Equivalently: $g(n) = o(1/(n^c))$ for all constants $c > 0$.
  
  A function is *non-negligible* if $exists$ polynomial $p$ such that $g(n) >= 1/(p(n))$ for infinitely many $n$.
]

#v(0.8em)

== Part (a): $f(n) = omega(log n) arrow.r.double g(n)$ is negligible

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Claim:* If $f(n) = omega(log n)$, then $g(n) = 2^(-f(n))$ is negligible.
]

*Proof:*

We need to show: for any polynomial $p(n) = n^c$ (for any constant $c > 0$):
$ 2^(-f(n)) < 1/(n^c) "for sufficiently large" n $

This is equivalent to:
$ n^c < 2^(f(n)) $

Taking logarithms (base 2):
$ c dot log_2 n < f(n) $

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Since $f(n) = omega(log n)$:*
  
  By definition, for every constant $c' > 0$, there exists $N$ such that for all $n > N$:
  $ f(n) > c' dot log n $
  
  In particular, taking $c' = c / (log 2)$ (so that $c' log n = (c log n)/(log 2) = c log_2 n$):
  $ f(n) > c / (log 2) dot log n = c dot log_2 n $
  
  Therefore $c dot log_2 n < f(n)$ for all sufficiently large $n$.
]

This shows $n^c < 2^(f(n))$, hence $2^(-f(n)) < n^(-c)$ for all $n > N$.

Since this holds for any polynomial $n^c$, we have $g(n) = 2^(-f(n))$ is negligible. $square$

#v(1em)

== Part (b): $f(n) = O(log n) arrow.r.double g(n)$ is non-negligible

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Claim:* If $f(n) = O(log n)$, then $g(n) = 2^(-f(n))$ is non-negligible.
]

*Proof:*

Since $f(n) = O(log n)$, there exist constants $c > 0$ and $N$ such that for all $n > N$:
$ f(n) <= c dot log n = c / (log 2) dot log_2 n $

Therefore:
$ 2^(-f(n)) >= 2^(-(c / log 2) dot log_2 n) = 2^(log_2 (n^(-c / log 2))) = n^(-c / log 2) $

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  Let $c' = c / (log 2)$. Then:
  $ g(n) = 2^(-f(n)) >= n^(-c') = 1/(n^(c')) $
  
  This means $g(n) >= 1/(p(n))$ where $p(n) = n^(c')$ is a polynomial.
]

By definition, $g(n)$ is non-negligible — it is at least inverse polynomial. $square$

#v(0.8em)

== Summary

#align(center)[
#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: center,
  fill: (_, row) => if row == 0 { rgb("#1a365d") } else if calc.rem(row, 2) == 0 { rgb("#f7fafc") } else { white },
  table.header(
    [#text(fill: white)[*Condition on $f(n)$*]], 
    [#text(fill: white)[*$g(n) = 2^(-f(n))$*]],
    [#text(fill: white)[*Intuition*]]
  ),
  [$f(n) = omega(log n)$], [Negligible], [$g(n) < n^(-c)$ for all $c$],
  [$f(n) = O(log n)$], [Non-negligible], [$g(n) >= n^(-c')$ for some $c'$],
)
]

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key Insight:* The boundary between negligible and non-negligible for functions of the form $2^(-f(n))$ is precisely when $f(n) = Theta(log n)$.
  
  - $f(n)$ grows faster than $log n$ → $2^(-f(n))$ is negligible
  - $f(n)$ grows at most as fast as $log n$ → $2^(-f(n))$ is non-negligible
  
  This makes sense: $2^(-c log n) = n^(-c')$ is exactly polynomial!
]

#v(1.5em)

#block(
  fill: rgb("#fff8e1"),
  stroke: (left: 3pt + rgb("#ffa000")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#e65100"))[💡 The Big Picture: Why Negligibility Matters]
  #v(0.3em)
  
  *The Core Idea:* In cryptography, we can't make attacks *impossible* — we make them *impractical*. Negligible functions quantify "so unlikely that we don't care."
  
  *Intuitive Understanding:*
  - *Non-negligible (bad):* Probability ≥ $1/n^c$ → attacker with $n^c$ tries can succeed
  - *Negligible (good):* Probability shrinks faster than any polynomial → even $n^{100}$ tries won't help
  
  *The $log n$ Boundary Explained:*
  - $2^(-log n) = 1/n$ → polynomial → non-negligible (attacker can brute-force)
  - $2^(-n)$ → exponential decay → negligible (attacker needs exponential time)
  - $2^(-sqrt(n))$ → still super-polynomial decay → negligible!
  
  *Real Numbers:* For $n = 128$ (typical security parameter):
  - $2^(-128) approx 3 times 10^(-39)$ — atoms in the universe: $10^80$, so you'd need $10^(-39) × 10^80 = 10^41$ universes searching every atom every second for a year to find a solution
]

#v(1em)

#block(
  fill: rgb("#e3f2fd"),
  stroke: (left: 3pt + rgb("#1976d2")),
  inset: 12pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0d47a1"))[🔗 Connections: Where You See Negligibility]
  #v(0.3em)
  
  This pattern appears in every security proof:
  
  - *P2 (PRG security):* Distinguishing advantage must be negligible
  - *P17-P20 (CPA security):* Attack success probability is negligible  
  - *P27 (OWF):* Inversion probability is negligible
  - *P3 (Hard-core predicates):* Prediction advantage is $1/2 + "negl"$
  
  *The Universal Template:* "For all PPT adversaries, $Pr["bad event"] ≤ "negl"(n)$"
  
  *Why $log n$ is the Boundary:* A PPT algorithm runs in $"poly"(n)$ time. If success probability is $1/"poly"(n)$, repeating $"poly"(n)$ times gives constant success. But if probability is $2^(-omega(log n))$, even $"poly"(n)$ repetitions give negligible total success.
]
