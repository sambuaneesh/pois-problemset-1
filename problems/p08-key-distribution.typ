// Problem 8: Encryption Scheme Equivalence

= Problem 8: Uniform vs Non-Uniform Key Distributions

#block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Setting:* Let $("Gen", "Enc", "Dec")$ be an encryption scheme where $"Gen"$ outputs a key $K$ according to an arbitrary (not necessarily uniform) distribution over some finite key space $cal(K)$. For any message $m$, let $C = "Enc"(K, m)$, where the probability is over the randomness of $"Gen"$ (and $"Enc"$, if randomized).
  
  *Task:* Prove that there exists an equivalent encryption scheme $("Gen"', "Enc"', "Dec"')$ with a (possibly different) key space $cal(K)'$ such that:
  1. $"Gen"'$ samples a key uniformly from $cal(K)'$; and
  2. For all messages $m$ and ciphertexts $c$: $Pr[C = c | M = m] = Pr[C' = c | M = m]$
  
  where $C' = "Enc"'(K', m)$ and the probability is over the randomness of $"Gen"'$ (and $"Enc"'$, if applicable).
]

#v(0.8em)

== Intuition

We need to show that *any* key distribution can be "simulated" by a uniform distribution over a (possibly larger) key space, without changing the distribution of ciphertexts.

The key idea: If some keys are more likely than others, we can create "multiple copies" of likely keys to make them appear uniform.

#v(1em)

== Construction of the Equivalent Scheme

=== Step 1: Analyze the Original Distribution

Let the original key distribution be:
$ Pr["Gen"() = k] = p_k "for each" k in cal(K) $

where $sum_(k in cal(K)) p_k = 1$.

#v(0.5em)

=== Step 2: Express Probabilities with Common Denominator

Since $cal(K)$ is finite, all probabilities $p_k$ are rational numbers (or can be approximated arbitrarily well by rationals).

Write each probability as:
$ p_k = n_k / N $

where $N$ is a common denominator and $n_k in NN$ for all $k$.

#block(
  fill: rgb("#e3f2fd"),
  inset: 12pt,
  radius: 4pt,
)[
  *Technical note:* We have $sum_(k in cal(K)) n_k = N$.
  
  Each $n_k$ represents "how many times" key $k$ should appear in the new key space.
]

#v(0.5em)

=== Step 3: Define the New Key Space

Define the new key space as:
$ cal(K)' = {(k, i) : k in cal(K), i in {1, 2, ..., n_k}} $

In other words, for each original key $k$, we create $n_k$ "copies" of it, indexed by $i$.

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Size of new key space:* $|cal(K)'| = sum_(k in cal(K)) n_k = N$
]

#v(0.5em)

=== Step 4: Define the New Algorithms

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *$"Gen"'$:* Sample $(k, i) in cal(K)'$ uniformly at random.
  
  Since $|cal(K)'| = N$ and key $k$ has exactly $n_k$ copies:
  $ Pr["Gen"'() "(has underlying key)" k] = n_k / N = p_k checkmark $
]

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *$"Enc"'((k, i), m)$:* Return $"Enc"(k, m)$.
  
  The index $i$ is ignored — encryption depends only on the underlying key $k$.
]

#block(
  fill: rgb("#e8f4e8"),
  inset: 12pt,
  radius: 4pt,
)[
  *$"Dec"'((k, i), c)$:* Return $"Dec"(k, c)$.
  
  Similarly, decryption ignores the index and uses $k$.
]

#v(1em)

== Proof of Equivalence

=== Property 1: $"Gen"'$ is Uniform over $cal(K)'$

By construction, $"Gen"'$ samples uniformly from $cal(K)'$:
$ Pr["Gen"'() = (k, i)] = 1/N "for all" (k, i) in cal(K)' $

This satisfies requirement 1. $checkmark$

#v(0.5em)

=== Property 2: Ciphertext Distributions are Identical

For any message $m$ and ciphertext $c$:

*Original scheme:*
$ Pr[C = c | M = m] = sum_(k in cal(K)) Pr["Gen"() = k] dot Pr["Enc"(k, m) = c] = sum_(k in cal(K)) p_k dot Pr["Enc"(k, m) = c] $

*New scheme:*
$ Pr[C' = c | M = m] &= sum_((k, i) in cal(K)') Pr["Gen"'() = (k, i)] dot Pr["Enc"'((k, i), m) = c] \
&= sum_((k, i) in cal(K)') 1/N dot Pr["Enc"(k, m) = c] \
&= sum_(k in cal(K)) sum_(i=1)^(n_k) 1/N dot Pr["Enc"(k, m) = c] \
&= sum_(k in cal(K)) n_k/N dot Pr["Enc"(k, m) = c] \
&= sum_(k in cal(K)) p_k dot Pr["Enc"(k, m) = c] $

#block(
  stroke: (left: 2pt + rgb("#4CAF50")),
  inset: (left: 10pt, y: 5pt),
)[
  *The two expressions are identical!*
  
  $ Pr[C = c | M = m] = Pr[C' = c | M = m] checkmark $
]

This satisfies requirement 2. $square$

#v(1em)

== Summary

#table(
  columns: (auto, 1fr, 1fr),
  inset: 10pt,
  align: left,
  fill: (_, row) => if row == 0 { rgb("#e0e0e0") } else { white },
  [*Component*], [*Original Scheme*], [*Equivalent Scheme*],
  [Key Space], [$cal(K)$], [$cal(K)' = {(k, i) : k in cal(K), i <= n_k}$],
  [Key Distribution], [Arbitrary: $Pr[K = k] = p_k$], [Uniform: $Pr[K' = (k,i)] = 1/N$],
  [Encryption], [$"Enc"(k, m)$], [$"Enc"'((k, i), m) = "Enc"(k, m)$],
  [Decryption], [$"Dec"(k, c)$], [$"Dec"'((k, i), c) = "Dec"(k, c)$],
)

#v(0.5em)

#block(
  stroke: (left: 2pt + rgb("#4a90d9")),
  inset: (left: 10pt, y: 5pt),
)[
  *Key Insight:* Any encryption scheme with non-uniform key distribution can be transformed into one with uniform key distribution by "unfolding" the probability mass — replicating keys in proportion to their original probability. This is essentially *inverse transform sampling* applied to key generation.
  
  *Security implication:* This shows that assuming uniform key generation is without loss of generality when analyzing encryption scheme security!
]
