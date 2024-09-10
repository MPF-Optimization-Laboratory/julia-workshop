import Base: size, adjoint, getindex, length


##############
# FillMatrix #
##############
#   -> A matrix completely filled with a single value.
# There is one type-related error here. Fix it.


struct FillMatrix <: AbstractMatrix{Number}
    size::Tuple{Int, Int}
    fill::Number
end


function getindex(A::FillMatrix, i::Int, j::Int)
    if i < 1 || j < 1 || i > A.size[1] || j > A.size[2]
        throw(BoundsError(A, (i, j)))
    end
    A.fill
end

size(A::FillMatrix) = A.size


##########
# OneHot #
##########
#   -> A vector with a single nonzero element.
# There is one type-related error here. Fix it.


struct OneHot{T} <: AbstractVector{T}
    length::Int
    index::Int # index of nonzero value
    value::T
end

function getindex(x::OneHot, i::Int)
    if i < 1 || i > x.length
        throw(BoundsError(x, i))
    end

    if i == x.index
        x.value
    else
        0
    end
end

size(x::OneHot) = (x.length,)


#####################
# CumulativeProduct #
#####################
#   -> Wraps another vector, and does cumulative product lazily
# There is one type-related error here. Fix it.


struct CumulativeProduct{T} <: AbstractVector{T}
    wrapping::Vector{T}
end

size(x::CumulativeProduct) = size(x.wrapping)
function getindex(x::CumulativeProduct, i::Int)
    if i > length(x.wrapping) || i < 0
        throw(BoundsError(x, i))
    end

    if i == 0
        1
    else
        x.wrapping[i] * getindex(x, i - 1)
    end
end


######################
# Heterogeneous List #
######################
#  -> A list which can type-safely store values of multiple types together (for example, a float and an int)
# This list uses a tuple to store values heterogeneously.
# - Is it possible to define `getindex` for this type of list type-safely?
# - Write a limited specialized indexing functions which are type-safe. (Hint: check the `first` function from the standard library)


struct HList{Types <: Tuple}
    elements::Types
end

getindex(l::HList, i::Int) = l.elements[i]


##################
# Recursive List #
##################
#   -> A list which stores its elements recursively
# This list uses a `Union` type in one of the fields. Remove it.
# HINT: What would you have to change to be able to store an empty list?
# HINT: You will need to define a singleton and an abstract type


struct List{T}
    head::T
    rest::Union{List{T}, Nothing}
end

# list with a single item
cons(value) = List(value, nothing)
# prepend a new value to a list
cons(value::T, list::List{T}) where {T} = List(value, list)

# HINT: this function should be cleaner
length(l::List) = 1 + (isnothing(l.rest) ? 0 : length(l.rest))

function getindex(l::List, i::Int)
    if i > length(l)
        throw(BoundsError(l, i))
    elseif i == 1
        l.value
    else
        getindex(l.rest, i - 1)
    end
end


##############
# tuplezeros #
##############
#   -> Returns a tuple with all zeros of a particular length
# This type instability can't be solved. Why?


function tuplezeros(T::Type, n::Int)
    if n == 0
        ()
    else
        (zero(T), tuplezeros(T, n - 1)...)
    end
end


###############
# Value Types #
###############
# You may have noticed that type parameters can also be _values_. For example, a `Vector{Int}` is an alias for
#   `Array{Int, 1}`, and `Matrix{Int}` for `Array{Int, 2}` (check it!). The following type instability could
#   never possibly be solved. Why?

struct Foo{N} end

Foo(N::Int) = Foo{N}()


##################
# Value Types II #
##################
# This isn't type stable. Is it possible for it to be (for example if the compiler were more advanced)?
# If this type stability were solved generally (i.e. for any function, not just +), what would that imply about type inference?
# HINT: how much complexity would it add to computing types?


Foo(::Foo{N}, ::Foo{M}) where {N, M} = Foo{N + M}()


###################
# Value Types III #
###################
# The values can be any bitstype. Can you create a surprising result using floating points as a type parameter?
# HINT: When is a float not equal to itself?
