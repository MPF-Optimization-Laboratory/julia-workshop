# Dual Number Polynomial Differentiation

```@docs
DualNumber
```

```@docs
Polynomial
```

## Differentiation

By using dual numbers with polynomials we can evaluate the derivative! Consider a polynomial ``P(x) = p_0 + p_1 x + \cdots + p_n x^n``. Then,

```math
\begin{aligned}
P(a + bϵ) &= p_0 + p_1 (a + bϵ) + \cdots + p_n (a + bϵ)^n \\
          &= p_0 + p_1 a + p_2 a^2 + \dots \\
          &+ p_1bϵ + 2p_2 abϵ + 3p_3 a^2 b ϵ + \cdots \\
          &= P(a) + bP^\prime(a)ϵ
\end{aligned}
```

```@docs
derivative
```
