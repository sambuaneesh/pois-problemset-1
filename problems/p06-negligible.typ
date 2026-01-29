// Problem 6: Negligible Functions

= Problem 6: Negligible or Not?

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Topic:* Analysis of negligible functions — fundamental concept in cryptographic security definitions #link(<negligible-functions>)[(see Appendix C.5)].
]

#v(0.8em)

== Background: What is a Negligible Function?

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Definition:* A function $f : NN -> RR$ is *negligible* if for every positive polynomial $p(n)$, there exists $N in NN$ such that for all $n > N$:
  $ |f(n)| < 1/(p(n)) $
  
  *Intuition:* $f(n)$ decreases faster than the inverse of any polynomial — it's "super-polynomially small."
  
  *Notation:* We write $f(n) = "negl"(n)$ to denote that $f$ is negligible.
]

*Key characterization:* $f$ is negligible $<=>$ for all $c > 0$: $lim_(n -> oo) n^c dot f(n) = 0$

#v(1em)

== Part (a): Properties of Negligible Functions

Let $f, g : NN -> RR$ be negligible functions, and let $p : NN -> RR$ be a polynomial with $p(n) > 0$ for all $n in NN$.

#v(0.5em)

=== (i) $h(n) = f(n) + g(n)$

*Claim:* $h(n)$ is negligible.

*Proof:*

Let $q(n)$ be any positive polynomial. We need to show $|h(n)| < 1/(q(n))$ for sufficiently large $n$.

Since $f$ is negligible, there exists $N_1$ such that for $n > N_1$:
$ |f(n)| < 1/(2 q(n)) $

Since $g$ is negligible, there exists $N_2$ such that for $n > N_2$:
$ |g(n)| < 1/(2 q(n)) $

For $n > max(N_1, N_2)$:
$ |h(n)| = |f(n) + g(n)| <= |f(n)| + |g(n)| < 1/(2 q(n)) + 1/(2 q(n)) = 1/(q(n)) $

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Conclusion:* The sum of two negligible functions is negligible. $checkmark$
  
  *Generalization:* The sum of polynomially many negligible functions is also negligible.
]

#v(0.8em)

=== (ii) $h(n) = f(n) dot p(n)$

*Claim:* $h(n)$ is negligible.

*Proof:*

Let $q(n)$ be any positive polynomial. We need $|h(n)| < 1/(q(n))$ for large $n$.

Define $r(n) = q(n) dot p(n)$. Since $q$ and $p$ are both polynomials, $r(n)$ is also a polynomial.

Since $f$ is negligible, there exists $N$ such that for $n > N$:
$ |f(n)| < 1/(r(n)) = 1/(q(n) dot p(n)) $

Therefore, for $n > N$:
$ |h(n)| = |f(n) dot p(n)| = |f(n)| dot p(n) < 1/(q(n) dot p(n)) dot p(n) = 1/(q(n)) $

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Conclusion:* A negligible function multiplied by a polynomial is still negligible. $checkmark$
  
  *Intuition:* Polynomials can't "catch up" to super-polynomial decay.
]

#v(0.8em)

=== (iii) $f(n) := f'(n) dot p(n)$ for *some* negligible $f'$ and *some* polynomial $p$

*Question:* Is such an $f(n)$ always negligible?

*Answer:* *Yes*, such an $f(n)$ is always negligible.

*Proof:*

This follows directly from part (ii). Given:
- $f'(n)$ is negligible (by assumption)
- $p(n)$ is a polynomial (by assumption)

By the result of part (ii), the product $f'(n) dot p(n)$ is negligible.

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key insight:* The statement "for some negligible $f'$ and some polynomial $p$" simply means we're given a specific negligible function and a specific polynomial. Their product is always negligible, regardless of which specific functions they are.
]

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Summary of Part (a) — Closure Properties:*
  
  #table(
    columns: (1fr, 1fr),
    inset: 8pt,
    align: left,
    fill: (_, row) => if row == 0 { rgb("#e0e0e0") } else { white },
    [*Operation*], [*Result*],
    [$"negl"_1 + "negl"_2$], [Negligible $checkmark$],
    [$"negl" times "poly"$], [Negligible $checkmark$],
    [$"negl"_1 times "negl"_2$], [Negligible $checkmark$ (even smaller!)],
  )
]

#v(1em)

== Part (b): Analyzing Specific Functions

For each function, we determine whether it is negligible by checking if it decays faster than any inverse polynomial.

*Key technique:* Take logarithms and compare growth rates.

#v(0.5em)

=== (i) $f(n) = 1/(2^(100 log n))$

*Simplification:*
$ f(n) = 1/(2^(100 log n)) = 1/((2^(log n))^100) = 1/(n^(100 dot log 2)) approx 1/(n^(30.1)) $

Wait, let's be more careful. Assuming $log$ is base 2:
$ 2^(100 log_2 n) = (2^(log_2 n))^100 = n^100 $

So $f(n) = 1/(n^100) = n^(-100)$.

*Analysis:* This is exactly an inverse polynomial ($n^(-100)$).

For $f$ to be negligible, we need $n^c dot f(n) -> 0$ for all $c > 0$.

But with $c = 101$:
$ n^101 dot n^(-100) = n -> oo $

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Verdict: NOT negligible* ✗
  
  $f(n) = n^(-100)$ is polynomial decay, not super-polynomial.
]

#v(0.8em)

=== (ii) $f(n) = 1/((log n)^(log n))$

*Analysis using logarithms:*
$ log f(n) = -log n dot log(log n) $

Compare with inverse polynomial $1/(n^c)$, which has $log(1/(n^c)) = -c log n$.

We need: Is $log n dot log(log n)$ eventually larger than $c log n$ for any $c$?

$ (log n dot log(log n)) / (c log n) = (log(log n))/c -> oo $ as $n -> oo$

So $f(n)$ decays faster than any $n^(-c)$.

*Formal verification:* For any polynomial $p(n) = n^c$:
$ n^c dot f(n) = n^c / ((log n)^(log n)) $

Taking logs: $c log n - log n dot log(log n) = log n (c - log(log n))$

As $n -> oo$, $log(log n) -> oo$, so this becomes $-oo$, meaning $n^c dot f(n) -> 0$.

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Verdict: Negligible* $checkmark$
  
  $(log n)^(log n)$ grows super-polynomially (faster than any $n^c$).
]

#v(0.8em)

=== (iii) $f(n) = n^(-100) + 2^(-n)$

*Analysis:*

- $n^(-100)$: Polynomial decay (NOT negligible by itself)
- $2^(-n)$: Exponential decay (negligible)

The sum is dominated by the slower-decaying term:
$ f(n) approx n^(-100) "for large" n $

For $c = 101$:
$ n^101 dot f(n) >= n^101 dot n^(-100) = n -> oo $

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Verdict: NOT negligible* ✗
  
  The $n^(-100)$ term dominates and is only polynomial decay.
]

#v(0.8em)

=== (iv) $f(n) = 1.01^(-n)$

*Analysis:*

$ f(n) = (1/1.01)^n = (100/101)^n $

This is exponential decay with base $< 1$.

For any $c > 0$:
$ n^c dot (1.01)^(-n) = n^c / (1.01)^n $

The exponential $(1.01)^n$ grows faster than any polynomial, so this ratio $-> 0$.

*Formal:* Using L'Hôpital's rule or the fact that exponentials dominate polynomials:
$ lim_(n->oo) n^c / a^n = 0 "for any" a > 1, c > 0 $

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Verdict: Negligible* $checkmark$
  
  Exponential decay (even with base as small as $1.01$) is negligible.
]

#v(0.8em)

=== (v) $f(n) = 2^(-(log n)^2)$

*Analysis:*

$ log f(n) = -(log n)^2 $

Compare with $1/(n^c)$: $log(n^(-c)) = -c log n$

Is $(log n)^2$ eventually larger than $c log n$ for any $c$?

$ ((log n)^2) / (c log n) = (log n)/c -> oo $

So $f(n)$ decays faster than any inverse polynomial.

*Verification:*
$ n^c dot f(n) = 2^(c log n) dot 2^(-(log n)^2) = 2^(c log n - (log n)^2) = 2^(log n (c - log n)) $

For large $n$, $log n > c$, so exponent $-> -oo$, hence $n^c dot f(n) -> 0$.

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Verdict: Negligible* $checkmark$
  
  $(log n)^2$ in the exponent grows faster than linear, causing super-polynomial decay.
]

#v(0.8em)

=== (vi) $f(n) = 2^(-sqrt(n))$

*Analysis:*

$ log f(n) = -sqrt(n) $

Compare with $1/(n^c)$: need $sqrt(n)$ vs $c log n$.

$ (sqrt(n)) / (c log n) -> oo "as" n -> oo $

So $sqrt(n)$ grows faster than $log n$, meaning $f(n)$ decays faster than any $n^(-c)$.

*Verification:*
$ n^c dot f(n) = n^c / (2^(sqrt(n))) = 2^(c log n) / 2^(sqrt(n)) = 2^(c log n - sqrt(n)) $

Since $sqrt(n)$ grows faster than $log n$, the exponent $-> -oo$.

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Verdict: Negligible* $checkmark$
  
  $sqrt(n)$ grows faster than any $c log n$, so $2^(-sqrt(n))$ is negligible.
]

#v(0.8em)

=== (vii) $f(n) = 2^(-sqrt(log n))$

*Analysis:*

$ log f(n) = -sqrt(log n) $

Compare with $1/(n^c)$: need $sqrt(log n)$ vs $c log n$.

$ (sqrt(log n)) / (c log n) = 1/(c sqrt(log n)) -> 0 "as" n -> oo $

This means $sqrt(log n)$ grows *slower* than $c log n$!

*The critical test:* For $c = 1$:
$ n dot f(n) = n / 2^(sqrt(log n)) = 2^(log n) / 2^(sqrt(log n)) = 2^(log n - sqrt(log n)) $

Since $log n - sqrt(log n) = sqrt(log n)(sqrt(log n) - 1) -> oo$, we get $n dot f(n) -> oo$.

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Verdict: NOT negligible* ✗
  
  $sqrt(log n)$ grows too slowly — slower than $c log n$ for any $c > 0$.
]

#v(0.8em)

=== (viii) $f(n) = 1/((log n)!)$

*Analysis using Stirling's approximation:*

$ (log n)! approx sqrt(2 pi log n) ((log n)/e)^(log n) $

So:
$ log((log n)!) approx (log n) dot log(log n) - (log n) dot log e + O(log log n) $
$ approx (log n) dot (log(log n) - 1) $

For large $n$, this is $approx (log n) dot log(log n)$.

Compare with $c log n$:
$ ((log n) dot log(log n)) / (c log n) = (log(log n))/c -> oo $

So $(log n)!$ grows super-polynomially.

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Verdict: Negligible* $checkmark$
  
  $(log n)!$ grows faster than any polynomial due to factorial growth.
]

#v(1em)

== Summary Table

#align(center)[
#table(
  columns: (auto, 1fr, auto),
  inset: 10pt,
  align: (center, left, center),
  fill: (_, row) => if row == 0 { rgb("#1a365d") } else if calc.rem(row, 2) == 0 { rgb("#f7fafc") } else { white },
  table.header(
    [#text(fill: white)[*No.*]], 
    [#text(fill: white)[*Function*]], 
    [#text(fill: white)[*Negligible?*]]
  ),
  [(i)], [$f(n) = 1/(2^(100 log n)) = n^(-100)$], [#text(fill: rgb("#d9534f"))[*NO* ✗]],
  [(ii)], [$f(n) = 1/((log n)^(log n))$], [#text(fill: rgb("#4CAF50"))[*YES* $checkmark$]],
  [(iii)], [$f(n) = n^(-100) + 2^(-n)$], [#text(fill: rgb("#d9534f"))[*NO* ✗]],
  [(iv)], [$f(n) = 1.01^(-n)$], [#text(fill: rgb("#4CAF50"))[*YES* $checkmark$]],
  [(v)], [$f(n) = 2^(-(log n)^2)$], [#text(fill: rgb("#4CAF50"))[*YES* $checkmark$]],
  [(vi)], [$f(n) = 2^(-sqrt(n))$], [#text(fill: rgb("#4CAF50"))[*YES* $checkmark$]],
  [(vii)], [$f(n) = 2^(-sqrt(log n))$], [#text(fill: rgb("#d9534f"))[*NO* ✗]],
  [(viii)], [$f(n) = 1/((log n)!)$], [#text(fill: rgb("#4CAF50"))[*YES* $checkmark$]],
)
]

#v(0.5em)

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key Insight — The Negligibility Threshold:*
  
  A function $f(n) = 2^(-g(n))$ is negligible $<=>$ $g(n) = omega(log n)$
  
  Equivalently, $g(n)/(log n) -> oo$ as $n -> oo$.
  
  *Examples:*
  - $g(n) = sqrt(n)$: negligible ($sqrt(n)/(log n) -> oo$)
  - $g(n) = (log n)^2$: negligible
  - $g(n) = sqrt(log n)$: NOT negligible ($sqrt(log n)/(log n) -> 0$)
  - $g(n) = 100 log n$: NOT negligible (just polynomial decay)
]
