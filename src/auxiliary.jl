function getunitname(p::T, unitformat) where {T<:Unit}
    unitname = get(unitnames, (unitformat, name(p)), nothing)
    isnothing(unitname) || return unitname
    if unitformat === :siunitx
        return "\\$(lowercase(String(name(p))))"
    end
    return abbr(p)
end

function listunits(::T) where {T<:Units}
    return sortexp(T.parameters[1])
end

"""
```julia
intersperse(t, delim)
```
Create a vector whose elements alternate between the elements of `t` and `delim`, analogous
to `join` for strings.

# Example
```julia
julia> intersperse((1, 2, 3, 4), :a)
[1, :a, 2, :a, 3, :a, 4]
```
"""
function intersperse(t::T, delim::U) where {T,U}
    iszero(length(t)) && return ()
    L = length(t) * 2 - 1
    out = Vector{Union{typeof.(t)...,U}}(undef, L)
    out[1:2:L] .= t
    out[2:2:L] .= delim
    return out
end
