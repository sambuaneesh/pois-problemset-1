# POIS Appendix Registry

This file tracks all concepts currently defined in `appendix.typ`. 
**READ THIS FILE** before adding new problems to check if a concept already exists.

## How to Use
- If a concept exists below, use `#link(<label>)[(See Appendix X.Y)]` in your problem file
- If a concept doesn't exist, add it to `appendix.typ` AND update this registry

---

## A. Classical Ciphers

| Section | Label | Description |
|---------|-------|-------------|
| A.1 | `<shift-cipher>` | Shift/Caesar cipher: $c_i = (m_i + k) \mod 26$ |
| A.2 | `<substitution-cipher>` | Substitution cipher with permutation $\pi$ |
| A.3 | `<vigenere-cipher>` | Vigenère cipher with repeating keyword |

---

## B. Number Theory Foundations

| Section | Label | Description |
|---------|-------|-------------|
| B.1 | `<dlp>` | Discrete Logarithm Problem: given $y = g^x \mod p$, find $x$ |
| B.2 | `<group-structure>` | Group structure of $\mathbb{Z}_p^*$, order $p-1$, generators |
| B.3 | `<pohlig-hellman>` | Pohlig-Hellman algorithm for DLP with smooth order |

**Note:** Smooth numbers and safe primes are explained inline in Problem 7.

## C. Cryptographic Concepts

| Section | Label | Description |
|---------|-------|-------------|
| C.1 | `<one-way-functions>` | One-way functions: easy to compute, hard to invert |
| C.2 | `<hard-core-predicates>` | Hard-core predicates for OWFs |
| C.3 | `<prg>` | Pseudo-random generators (PRGs) |
| C.4 | `<security-notions>` | Computational vs information-theoretic security |
| C.5 | `<negligible-functions>` | Negligible functions: decay faster than any inverse polynomial |

---

## D. Proof Techniques

| Section | Label | Description |
|---------|-------|-------------|
| D.1 | `<reduction>` | Security reductions |
| D.2 | `<hybrid-argument>` | Hybrid argument for indistinguishability |

---

## E. Principles

| Section | Label | Description |
|---------|-------|-------------|
| E | `<kerckhoffs>` | Kerckhoffs's Principle: security from key secrecy only |

---

## Adding New Concepts

When adding a new concept to `appendix.typ`:

1. Choose the appropriate section (A-E) or create a new one
2. Add content with a label: `== X.Y Concept Name <label-name>`
3. Update this registry with the new entry
4. Use `#link(<label-name>)[(See Appendix X.Y)]` in problem files
