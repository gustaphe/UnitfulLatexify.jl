#key:     Symbol  Display  Name      Equals      Prefixes?
@unit one "" One 1 false

register(UnitfulLatexify)

function *(q::AbstractQuantity, ::Units{(Unit{:One,NoDims}(0, 1),),NoDims,nothing})
    Base.depwarn("Unit `one` is no longer needed, just use the number directly.", :*)
    q
end
function *(
    a::AbstractQuantity, b::T
) where {
    T<:AbstractQuantity{<:Number,NoDims,<:Units{(Unit{:One,NoDims}(0, 1),),NoDims,nothing}}
}
    Base.depwarn("Unit `one` is no longer needed, just use the number directly.", :*)
    return a * b.val
end
function *(
    b::T, a::AbstractQuantity
) where {
    T<:AbstractQuantity{<:Number,NoDims,<:Units{(Unit{:One,NoDims}(0, 1),),NoDims,nothing}}
}
    Base.depwarn("Unit `one` is no longer needed, just use the number directly.", :*)
    return b.val * a
end

@latexrecipe function f(p::Unit{:One,NoDims})
    return ""
end

@latexrecipe function f(p::Units{(Unit{:One,NoDims}(0, 1),),NoDims,nothing})
    return ""
end

@latexrecipe function f(q::AbstractQuantity{<:Number,NoDims,<:Units{(),NoDims,nothing}})
    Base.depwarn("Unit `one` is no longer needed, just use the number directly.", :latexify)
    return ustrip(q)
end

@latexrecipe function f(
    q::AbstractQuantity{<:Number,NoDims,<:Units{(Unit{:One,NoDims}(0, 1),),NoDims,nothing}}
)
    Base.depwarn("Unit `one` is no longer needed, just use the number directly.", :latexify)
    return ustrip(q)
end
