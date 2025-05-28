@latexrecipe function f( # Array{Quantity{U}}
    a::AbstractArray{<:AbstractQuantity{N,D,U}};
) where {N<:Number,D,U}
    insert_deprecated_unitformat!(kwargs)
    # Array of quantities with the same unit
    env --> :equation
    return Expr(
        :latexifymerge, ustrip.(a), has_unit_spacing(first(a)) ? "\\;" : "", unit(first(a))
    )
end

@latexrecipe function f( # Range{Quantity{U}}
    r::AbstractRange{<:AbstractQuantity{N,D,U}};
) where {N<:Number,D,U}
    insert_deprecated_unitformat!(kwargs)
    fmt = get_formatter(kwargs)
    if fmt isa SiunitxNumberFormatter
        env --> :raw
        opening = fmt.version < 3 ? "\\SIrange{" : "\\qtyrange{"
        return Expr(
            :latexifymerge,
            opening,
            NakedNumber(r.start.val),
            "}{",
            NakedNumber(r.stop.val),
            "}{",
            NakedUnits(unit(r.start)),
            "}",
        )
    end
    return collect(r)
end

@latexrecipe function f( # Tuple{Quantity{U}}
    l::Tuple{T,Vararg{T}},
) where {T<:AbstractQuantity{N,D,U}} where {N<:Number,D,U}
    insert_deprecated_unitformat!(kwargs)
    fmt = get_formatter(kwargs)
    if fmt isa SiunitxNumberFormatter
        env --> :raw
        opening = fmt.version < 3 ? "\\SIlist{" : "\\qtylist"
        return Expr(
            :latexifymerge,
            opening,
            intersperse(NakedNumber.(ustrip.(l)), ";")...,
            "}{",
            NakedUnits(unit(first(l))),
            "}",
        )
    end
    return collect(l)
end
