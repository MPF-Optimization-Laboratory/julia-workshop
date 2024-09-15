# ┏━━━━━━━━━━━┓
# ┃ Problem 1 ┃
# ┗━━━━━━━━━━━┛



import Base: iterate


struct Primes
    n::Int
    sieve::?
end


# iterate() methods here



# ┏━━━━━━━━━━━┓
# ┃ Problem 2 ┃
# ┗━━━━━━━━━━━┛


struct OuterProduct{???}
    ???
end


# ┏━━━━━━━━━━━┓
# ┃ Problem 3 ┃
# ┗━━━━━━━━━━━┛


import Base: +, *, convert


abstract type PeanoNumber <: Integer end

function convert(::Type{PeanoNumber}, x::Int)
    if x < 0
        throw(DomainError(x, "Peano numbers are nonnegative."))
    elseif x == 0
        Zero()
    else
        S(convert(PeanoNumber, x - 1))
    end
end



# ┏━━━━━━━┓
# ┃ Tests ┃
# ┗━━━━━━━┛

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
