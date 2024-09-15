@def title = "Day 2"

# Day 2

- [Slides](/day2.ipynb)
- [Starter code for the problems](/problems/day2.jl)

## Problem 1: Prime Number Iterator


Make an iterator over the prime numbers less than or equal to $n$ using a Sieve of Eratosthenes
- The sieve should be created when building the Primes struct
- You should provide a constructor which does so (`Primes(n::Int)`)
- The iterator interface is described [here](https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-iteration)
- You may wish to define additional functions

Sieve of Eratosthenes:

- Allocate a Boolean vector of size $n$, where each element represents whether that number is prime.
  - They should all start as `true`. You can use the function `ones(Bool, n)` to make the vector.
    - (there's also a `trues` function, which returns a [`BitVector`](https://docs.julialang.org/en/v1/base/arrays/#Base.BitArray-Tuple{Any}). This'll also work.)
 - Mark 1 as `false`
    - 1 isn't prime
 - Let $p = 1$
 - While there are numbers marked as prime greater than $p$:
   - Set $p$ to the smallest number marked prime larger than the previous $p$
   - Mark all multiples of $p$ ($2p$, $3p$, ...) as not prime
 - Now, all numbers are marked correctly

Hint: `1:2:10` gives you a range over `(1, 3, 5, 7, 9)`


## Problem 2: Outer Product Matrix


Problem 2: Write a matrix type which is the outer product of two vectors
- You should only store the vectors
- Both should have element type `T`, and it should be a subtype of `AbstractMatrix{T}`
- You should implement the methods ([docs](https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-array)):
  - `size(::OuterProduct)`
  - `getindex(::OuterProduct, i::Int, j::Int)`
  - `adjoint(::OuterProduct)` (hint: (uv')' = (vu'))
- Try building an instance of OuterProduct in the REPL. Julia can already print it and has matrix-vector and matrix-matrix multiplication defined!


## Problem 3: Peano Arithmetic

[Peano arithmetic](https://en.wikipedia.org/wiki/Peano_axioms) provides a compact axiomatic description of the natural numbers. An informal description is:
- There exists 0.
- There exists the successor function, $S()$. $S(x) \neq 0 ∀ x$
- $S(x) = S(y)$ implies $x = y$

From this we can recursively construct the naturals. Further, we can define addition recursively:

```
+(0, 0)    = 0
+(x, 0)    = x
+(0, x)    = x
+(x, S(y)) = S(x + y)
```

As well as multiplication:

```
*(0, 0)    = 0
*(x, 0)    = 0
*(0, x)    = 0
*(x, S(y)) = x + (x * y)
```

For your implementation, you'll define types and methods to compute Peano arithmetic.

- There should be two subtypes of `PeanoNumber`: `Zero` and `S`
   - `Zero` should have no fields
   - `S` should have a single parameter `P <: PeanoNumber`, and a single field of type `P`
- You should define `+`, `*`, and `==` (equality)
- You should also define `convert(::Type{Int}, ...)` to turn the Peano numbers into regular ints.
- The opposite conversion has been done for you

- HINT: Think recursively! Remember dispatch!
- HINT: Don't try to use too large of numbers. You'll find you're implementing arithmetic _in the type system_, so this can work the compiler pretty hard!