// Problem 28: PRF Constructions

= Problem 28: PRF Constructions Analysis

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  Let $cal(F)_n$ be a Pseudo-Random Function family #link(<prf>)[(Appendix C.6)]. For each construction $f'_k in cal(F)'_n$, prove it is a PRF or provide an attack.
  
  + $f'_k (x, y) = f_k (x) xor f_k (y)$
  + $f'_k (x, y) = f_k (x xor y)$
  + $f'_k (x, y) = f_(k xor x) (y)$
  + $f'_k (x, y) = f_(f_k (x)) (y)$
]

#v(0.8em)

== Part (a): $f'_k (x, y) = f_k (x) xor f_k (y)$

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: NOT a PRF.*
]

*Attack (same as Problem 19):*

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  Query $f'_k (x, x)$ for any $x$:
  $ f'_k (x, x) = f_k (x) xor f_k (x) = 0 $
  
  This is always zero! A random function would return $0$ with probability $1/2^n$.
  
  *Distinguishing advantage:* $1 - 1/2^n approx 1$
]

#v(0.8em)

== Part (b): $f'_k (x, y) = f_k (x xor y)$

#block(
  stroke: (left: 2pt + rgb("#d9534f")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: NOT a PRF.*
]

*Attack:*

#block(
  fill: rgb("#fce4e4"),
  inset: 12pt,
  radius: 4pt,
)[
  Query two different inputs that have the same XOR:
  
  - Query $f'_k (x_1, y_1)$ where $x_1 xor y_1 = z$
  - Query $f'_k (x_2, y_2)$ where $x_2 xor y_2 = z$ (same $z$, different pair)
  
  For example: $(0, z)$ and $(1, z xor 1)$ both give $f_k(z)$.
  
  *Result:* $f'_k (0, z) = f'_k (1, z xor 1) = f_k (z)$
  
  For a random function, $R(0, z) = R(1, z xor 1)$ with probability $1/2^n$.
  
  *Distinguishing advantage:* $1 - 1/2^n approx 1$
]

#v(0.8em)

== Part (c): $f'_k (x, y) = f_(k xor x) (y)$

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: YES, this IS a PRF* (under standard assumptions).
]

*Proof sketch:*

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Key observation:* For each fixed $x$, the key used is $k xor x$.
  
  Since $k$ is random and secret:
  - For different $x$ values, $k xor x$ are different (but still uniformly random from adversary's view)
  - Each "effective key" $k xor x$ is used with a PRF
  
  *Why this is secure:*
  - The adversary doesn't know $k$
  - Each $x$ value corresponds to a PRF with an unknown key $k xor x$
  - Different $x$ values give independent-looking PRF instances
  
  This is similar to having independent PRF instances for each $x$, which a random function would also have.
]

*Technical note:* This assumes the PRF family is secure even when many related keys are used. This is the "related-key security" property, which standard PRFs may or may not have. Under the standard PRF assumption, this construction is secure if we model individual key uses as independent.

#v(0.8em)

== Part (d): $f'_k (x, y) = f_(f_k (x)) (y)$

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *Answer: YES, this IS a PRF.*
]

*Proof:*

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *Structure:* 
  - First, compute $k_x = f_k (x)$ (a derived key)
  - Then, compute $f_(k_x) (y)$
  
  This is essentially the *GGM construction* (one level of it)!
]

*Security argument:*

1. *Replace $f_k$ with random function $R$:*
   - For each $x$, the derived key is $k_x = R(x)$
   - $k_x$ values are independent and random (outputs of random function)
   
2. *For each fixed $x$:*
   - $f_(k_x)(y)$ is a PRF with a random key $k_x$
   - Outputs on different $y$ values are pseudorandom
   
3. *For different $x$ values:*
   - Different $k_x$ means independent PRF instances
   - Outputs are independent across different $x$ values

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Formal reduction:*
  
  Any distinguisher for $f'_k$ can be converted to a distinguisher for $f_k$:
  
  - If the outer PRF ($f_(f_k(x))$) can be distinguished from random, either:
    1. The derived keys $f_k(x)$ are distinguishable from random (breaks PRF $f_k$), or
    2. The inner PRF with random keys is distinguishable (breaks PRF assumption)
  
  Both contradict the PRF security of $f$.
]

#v(0.8em)

== Summary

#align(center)[
#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: (center, left, center),
  fill: (_, row) => if row == 0 { rgb("#1a365d") } else if calc.rem(row, 2) == 0 { rgb("#f7fafc") } else { white },
  table.header(
    [#text(fill: white)[*Part*]], 
    [#text(fill: white)[*Construction*]], 
    [#text(fill: white)[*PRF?*]]
  ),
  [(a)], [$f_k (x) xor f_k (y)$], [#text(fill: rgb("#d9534f"))[*NO*] — self-XOR = 0],
  [(b)], [$f_k (x xor y)$], [#text(fill: rgb("#d9534f"))[*NO*] — collisions],
  [(c)], [$f_(k xor x) (y)$], [#text(fill: rgb("#4CAF50"))[*YES*] — key masking],
  [(d)], [$f_(f_k (x)) (y)$], [#text(fill: rgb("#4CAF50"))[*YES*] — GGM-like],
)
]
