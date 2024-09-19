@def title = "Day 3"

# Day 3

- [Slides](/day3.ipynb)
- [Type instability](/typeinstability.jl)

## Problems

1. Check whether your solutions for last week's problems were type stable. One of the methods there cannot be type stable. Which is it?
2. For the Peano numbers problem, in the following code, how many compilations for `+` happen?

```julia
Zero() + Zero()
Zero() + convert(PeanoNumber, 1)
convert(PeanoNumber, 1) + Zero()
convert(PeanoNumber, 1) + convert(PeanoNumber, 5)
convert(PeanoNumber, 2) + convert(PeanoNumber, 5)
```
