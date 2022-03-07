module DemoPackage

import Base: +, -, *, one, zero, convert, promote_rule, real

export DualNumber, Polynomial, derivative


"""
    DualNumber{T <: Real} <: Number

Represents a number of the form ``a + bϵ`` where ``a`` and ``b`` are real, and ``ϵ^2 = 0``.
"""
struct DualNumber{T <: Real} <: Number
    real::T
    dual::T
end

real(a::DualNumber) = a.real
dual(a::DualNumber) = a.dual

one(::Type{DualNumber{T}}) where {T}  = DualNumber(one(T), zero(T))
zero(::Type{DualNumber{T}}) where {T} = DualNumber(zero(T), zero(T))

+(a::DualNumber, b::DualNumber) = DualNumber(a.real + b.real, a.dual + b.dual)
-(a::DualNumber, b::DualNumber) = DualNumber(a.real - b.real, a.dual - b.dual)
*(a::DualNumber, b::DualNumber) = DualNumber(a.real * b.real, (a.real * b.dual) + (a.dual * b.real))

convert(::Type{DualNumber{T}}, x::Real) where {T} = DualNumber(convert(T, x), zero(T))
convert(::Type{DualNumber{T}}, x::DualNumber{U}) where {T, U} = DualNumber(convert(T, real(x)), convert(T, dual(x)))
promote_rule(::Type{DualNumber{T}}, ::Type{U}) where {T, U <: Real} = DualNumber{promote_type(T, U)}


"""
    Polynomial{T <: Real}
    
A polynomial with coefficients of type `T`. Is of the form: ``c + ∑_i x^i \\text{\\tt coeffs}[i]``

Has two fields:
- `c::T`, the constant 
- `coeffs::Vector{T}`, the coefficients for powers of `x`.

Polynomials can be evaluated by calling them:

```julia
# p(x) = 1 + 2x + 3x^2 + 4x^3
p = Polynomial(1, [2, 3, 4])
p(1) # returns 10
```
"""
struct Polynomial{T <: Real}
    c::T
    coeffs::Vector{T}
end

function (p::Polynomial{T})(x::U) where {T, U}
    acc  = zero(promote_type(T, U))
    xpow = one(x)
    for i in 1:length(p.coeffs)
        xpow *= x
        acc  += p.coeffs[i] * xpow
    end
    acc + p.c
end

"""
    derivative(::Polynomial, at)

Take the derivative of a polynomial at `at`.
"""
derivative(p::Polynomial, at::Real) = DualNumber(at, one(at)) |> p |> dual

"""
    derivative(::Polynomial)

Take the derivative of a polynomial. Returns a function which evaluates to the derivative.
"""
derivative(p::Polynomial) = (at -> derivative(p, at))

end # module DemoPackage
