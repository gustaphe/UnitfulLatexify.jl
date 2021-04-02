@latexrecipe function f(p::T; unitformat=:mathrm) where {T<:Unit}
    prefix = prefixes[(unitformat, tens(p))]
    pow = power(p)
    unitname = getunitname(p, unitformat)
    if unitformat === :mathrm
        env --> :inline
        if pow == 1//1
            expo = ""
        else
            expo = "^{$(latexify(pow;kwargs...,fmt="%g",env=:raw))}"
        end
        return LaTeXString("\\mathrm{$prefix$unitname}$expo")
    end
    env --> :raw
    if unitformat === :siunitx
        per = pow < 0 ? "\\per" : ""
        pow = abs(pow)
        expo = pow == 1//1 ? "" : "\\tothe{$(latexify(pow;kwargs...,fmt="%g",env=:raw))}"
    else
        per = ""
        expo = pow == 1//1 ? "" : "^{$(latexify(pow;kwargs...,fmt="%g",env=:raw))}"
    end
    return LaTeXString("$per$prefix$unitname$expo")
end

@latexrecipe function f(u::T; unitformat=:mathrm) where {T<:Units}
    if unitformat === :mathrm
        env --> :inline
        return Expr(:latexifymerge, NakedUnits(u))
    end
    env --> :raw
    return Expr(:latexifymerge, "\\si{", NakedUnits(u), "}")
end

@latexrecipe function f(q::T; unitformat=:mathrm) where {T<:AbstractQuantity}
    if unitformat === :mathrm
        env --> :inline
        fmt --> FancyNumberFormatter()
        return Expr(
            :latexifymerge,
            q.val,
            has_unit_spacing(unit(q)) ? "\\;" : nothing,
            NakedUnits(unit(q)),
        )
    end
    env --> :raw
    return Expr(:latexifymerge, "\\SI{", q.val, "}{", NakedUnits(unit(q)), "}")
end

struct NakedUnits
    u::Units
end
@latexrecipe function f(u::T; unitformat=:mathrm) where {T<:NakedUnits}
    return Expr(:latexifymerge, intersperse(listunits(u.u), delimiters[unitformat])...)
end

const delimiters = Dict{Symbol,String}(
    :mathrm => "\\,", :siunitx => "", :siunitxsimple => "."
)
