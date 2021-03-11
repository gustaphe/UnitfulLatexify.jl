function getunitname(p::T, unitformat) where {T<:Unit}
    unitname = get(unitnames, (unitformat, name(p)), nothing)
    isnothing(unitname) || return unitname
    if unitformat == :siunitx
        return "\\$(lowercase(String(name(p))))"
    end
    return abbr(p)
end

function listunits(::T) where {T<:Units}
    return sortexp(T.parameters[1])
end
