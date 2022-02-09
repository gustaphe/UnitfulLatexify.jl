#key:     Symbol  Display  Name      Equals      Prefixes?
@unit one "" One 1 false

register(UnitfulLatexify)

*(q::AbstractQuantity, ::Units{(Unit{:One,NoDims}(0, 1),),NoDims,nothing}) = q
function *(
    a::AbstractQuantity, b::T
) where {
    T<:AbstractQuantity{<:Number,NoDims,<:Units{(Unit{:One,NoDims}(0, 1),),NoDims,nothing}}
}
    return a * b.val
end
function *(
    b::T, a::AbstractQuantity
) where {
    T<:AbstractQuantity{<:Number,NoDims,<:Units{(Unit{:One,NoDims}(0, 1),),NoDims,nothing}}
}
    return b.val * a
end

@latexrecipe function f(p::T; unitformat=:mathrm) where {T<:Unit{:One,NoDims}}
    return ""
end

@latexrecipe function f(
    p::T; unitformat=:mathrm
) where {T<:Units{(Unit{:One,NoDims}(0, 1),),NoDims,nothing}}
    return ""
end

@latexrecipe function f(
    q::T; unitformat=:mathrm
) where {T<:AbstractQuantity{<:Number,NoDims,<:Units{(),NoDims,nothing}}}
    if unitformat === :mathrm
        env --> :inline
        fmt --> FancyNumberFormatter()
        return ustrip(q)
    end
    env --> :raw
    return Expr(:latexifymerge, "\\num{", ustrip(q), "}")
end

@latexrecipe function f(
    q::T; unitformat=:mathrm
) where {
    T<:AbstractQuantity{<:Number,NoDims,<:Units{(Unit{:One,NoDims}(0, 1),),NoDims,nothing}}
}
    if unitformat === :mathrm
        env --> :inline
        fmt --> FancyNumberFormatter()
        return ustrip(q)
    end
    env --> :raw
    return Expr(:latexifymerge, "\\num{", ustrip(q), "}")
end
