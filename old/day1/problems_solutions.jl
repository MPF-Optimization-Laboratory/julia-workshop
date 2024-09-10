# ┏━━━━━━━━━━━┓
# ┃ Problem 1 ┃
# ┗━━━━━━━━━━━┛

import Base: iterate


struct Primes
    n::Int
    sieve::Vector{Bool}
end

# find the index of the next true after the given index in a sieve
# returns nothing if no such index exists
function findnexttrue(i::Int, sieve::Vector{Bool})
    for j in (i+1):length(sieve)
        if sieve[j]
            return j
        end
    end
    nothing
end
# an alternate version of this uses the built-in `findfirst` function:
#    findnexttrue(i::Int, sieve::Vector{Bool}) = findfirst(identity, sieve[i:end])

function Primes(n::Int)
    sieve = ones(Bool, n)
    sieve[1] = false

    p = 1
    while true
        p = findnexttrue(p, sieve)
        if isnothing(p)
            break
        end

        for i in (2p):p:n
            sieve[i] = false
        end
    end

    Primes(n, sieve)
end

# our state here is just the last prime we found
function iterate(p::Primes, state::Int=1)
    nstate = findnexttrue(state, p.sieve)
    if isnothing(nstate)
        nothing
    else
        nstate, nstate
    end
end


# ┏━━━━━━━━━━━┓
# ┃ Problem 2 ┃
# ┗━━━━━━━━━━━┛

import Base: getindex, size, adjoint


struct OuterProduct{T} <: AbstractMatrix{T}
    u::Vector{T}
    v::Vector{T}
end

getindex(M::OuterProduct, i::Int, j::Int) = M.u[i] * M.v[j]
size(M::OuterProduct) = length(M.u), length(M.v)
adjoint(M::OuterProduct) = OuterProduct(M.v, M.u)



# ┏━━━━━━━━━━━┓
# ┃ Problem 3 ┃
# ┗━━━━━━━━━━━┛

import Base: +, *, convert


abstract type PeanoNumber <: Integer end

struct Zero <: PeanoNumber end
struct S{P <: PeanoNumber} <: PeanoNumber
    of::P
end

function convert(::Type{PeanoNumber}, x::Int)
    if x < 0
        throw(DomainError(x, "Peano numbers are nonnegative."))
    elseif x == 0
        Zero()
    else
        S(convert(PeanoNumber, x - 1))
    end
end

convert(::Type{Int}, ::Zero) = 0
convert(::Type{Int}, s::S)   = 1 + convert(Int, s.of)

+(x::PeanoNumber, ::Zero) = x
+(::Zero, x::PeanoNumber) = x
+(::Zero, ::Zero) = Zero()
+(x::S, y::S) = S(+(x, y.of))

*(::PeanoNumber, ::Zero) = Zero()
*(::Zero, ::PeanoNumber) = Zero()
*(::Zero, ::Zero) = Zero()
*(x::S, y::S) = x + (x * y.of)



function test_primes()
    answers = [2, 3, 5, 7, 11]
    for (i, p) in enumerate(Primes(12))
        if p != answers[i]
            error("The $(i)th prime is incorrect: is $p but should be $(answers[i])")
        end
    end
    println("Primes passed the test.")
end
test_primes()


function test_outerproduct()
    u = randn(128)
    v = randn(256)
    eager = u * v'
    lazy  = OuterProduct(u, v)

    eager_ = adjoint(eager)
    lazy_  = adjoint(lazy)

    if size(lazy) != size(eager)
        println("OuterProduct failed the test, probably in `size`.")
    end

    if !all(eager .≈ lazy)
        println("OuterProduct failed the test, probably in `getindex`.")
    end

    if all(eager_ .≈ lazy_)
        println("OuterProduct passed the test.")
    else
        println("OuterProduct failed the test, probably in `adjoint`")
    end
end
test_outerproduct()


function test_peano()
    zero = Zero()
    one = S(zero)
    two = S(one)
    three = S(two)

    test(fn, a, b, expected) = let i = convert(Int, fn(a, b))
        if i != expected
            println("$fn(a + b) should be $expected, but is $i")
            false
        else
            true
        end
    end

    test(+, two, three, 5) && test(*, two, three, 6) && test(+, zero, zero, 0) && println("PeanoNumbers passed the test.")
end
test_peano()
