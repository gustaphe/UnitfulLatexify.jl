@latexrecipe function f( # Array{Quantity{U}}
    a::AbstractArray{<:AbstractQuantity{N,D,U}};
    unitformat=:mathrm,
) where {N<:Number,D,U}
    # Array of quantities with the same unit
    env --> :equation
    return Expr(
        :latexifymerge,
        ustrip.(a) * u"one",
        has_unit_spacing(first(a)) ? "\\;" : "",
        unit(first(a)),
    )
end

@latexrecipe function f( # Array{Quantity{One}
    a::T;
    unitformat=:mathrm,
) where {
    T<:AbstractArray{<:AbstractQuantity{N,D,U}}
} where {N<:Number,D,U<:Units{(Unit{:One,NoDims}(0, 1),),NoDims,nothing}}
    env --> :equation
    if unitformat in (:siunitx, :siunitxsimple)
        return latexify.(a; kwargs..., unitformat=unitformat, env=:raw)
    end
    return ustrip.(a)
end

@latexrecipe function f( # Range{Quantity{U}}
    r::AbstractRange{<:AbstractQuantity{N,D,U}};
    unitformat=:mathrm,
) where {N<:Number,D,U}
    if unitformat in (:siunitx, :siunitxsimple)
        env --> :raw
        return Expr(
            :latexifymerge,
            "\\qtyrange{",
            r.start.val,
            "}{",
            r.stop.val,
            "}{",
            NakedUnits(unit(r.start)),
            "}",
        )
    end
    env --> :inline
    return collect(r)
end

@latexrecipe function f( # Range{Quantity{One}}
    r::T;
    unitformat=:mathrm,
) where {
    T<:AbstractRange{<:AbstractQuantity{N,D,U}}
} where {N<:Number,D,U<:Units{(Unit{:One,NoDims}(0, 1),),NoDims,nothing}}
    if unitformat in (:siunitx, :siunitxsimple)
        env --> :raw
        return Expr(:latexifymerge, "\\numrange{", r.start.val, "}{", r.stop.val, "}")
    end
    env --> :inline
    return ustrip.(r)
end

@latexrecipe function f( # Tuple{Quantity{U}}
    l::Tuple{T,Vararg{T}};
    unitformat=:mathrm,
) where {T<:AbstractQuantity{N,D,U}} where {N<:Number,D,U}
    if unitformat in (:siunitx, :siunitxsimple)
        env --> :raw
        return Expr(
            :latexifymerge,
            "\\qtylist{",
            intersperse(ustrip.(l), ";")...,
            "}{",
            NakedUnits(unit(first(l))),
            "}",
        )
    end
    env --> :inline
    return collect(l)
end

@latexrecipe function f( # Tuple{Quantity{One}}
    l::Tuple{T,Vararg{T}};
    unitformat=:mathrm,
) where {
    T<:AbstractQuantity{N,D,U}
} where {N<:Number,D,U<:Units{(Unit{:One,NoDims}(0, 1),),NoDims,nothing}}
    if unitformat in (:siunitx, :siunitxsimple)
        env --> :raw
        return Expr(:latexifymerge, "\\numlist{", intersperse(ustrip.(l), ";")..., "}")
    end
    env --> :inline
    return ustrip.(l)
end
