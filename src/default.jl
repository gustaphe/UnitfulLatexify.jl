@latexrecipe function f(p::T; unitformat=:mathrm) where {T<:Unit}
    prefix = prefixes[(unitformat, tens(p))]
    pow = power(p)
    unitname = getunitname(p, unitformat)
    if unitformat === :mathrm
        env --> :inline
        if pow == 1//1
            expo = ""
        else
            expo = "^{$(latexify(pow; kwargs..., fmt="%g", env=:raw))}"
        end
        return LaTeXString("\\mathrm{$prefix$unitname}$expo")
    end
    env --> :raw
    if unitformat === :siunitx
        per = pow < 0 ? "\\per" : ""
        pow = abs(pow)
        expo = pow == 1//1 ? "" : "\\tothe{$(latexify(pow; kwargs..., fmt="%g", env=:raw))}"
    else
        per = ""
        expo = pow == 1//1 ? "" : "^{$(latexify(pow; kwargs..., fmt="%g", env=:raw))}"
    end
    return LaTeXString("$per$prefix$unitname$expo")
end

@latexrecipe function f(
    u::T; unitformat=:mathrm, permode=:power, siunitxlegacy=false
) where {T<:Units}
    if unitformat === :mathrm
        env --> :inline
        return Expr(:latexifymerge, NakedUnits(u))
    end
    env --> :raw
    siunitxlegacy && return Expr(:latexifymerge, "\\si{", NakedUnits(u), "}")
    return Expr(:latexifymerge, "\\unit{", NakedUnits(u), "}")
end

@latexrecipe function f(
    q::T; unitformat=:mathrm, siunitxlegacy=false
) where {T<:AbstractQuantity}
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
    siunitxlegacy &&
        return Expr(:latexifymerge, "\\SI{", q.val, "}{", NakedUnits(unit(q)), "}")
    return Expr(:latexifymerge, "\\qty{", q.val, "}{", NakedUnits(unit(q)), "}")
end

struct NakedUnits
    u::Units
end

@latexrecipe function f(u::T; unitformat=:mathrm, permode=:power) where {T<:NakedUnits}
    unitlist = listunits(u.u)
    if unitformat in (:siunitx, :siunitxsimple) || permode === :power
        return Expr(:latexifymerge, intersperse(unitlist, delimiters[unitformat])...)
    end

    numunits = [x for x in unitlist if power(x) >= 0]
    denunits = [typeof(x)(tens(x), -power(x)) for x in unitlist if power(x) < 0]

    numerator = intersperse(numunits, delimiters[unitformat])
    if iszero(length(denunits))
        return Expr(:latexifymerge, numerator...)
    end
    if iszero(length(numunits))
        numerator = [1]
    end
    denominator = intersperse(denunits, delimiters[unitformat])

    if permode === :slash
        return Expr(:latexifymerge, numerator..., "\\,/\\,", denominator...)
    end
    if permode === :frac
        return Expr(:latexifymerge, "\\frac{", numerator..., "}{", denominator..., "}")
    end
    return error("permode $permode undefined.")
end

const delimiters = Dict{Symbol,String}(
    :mathrm => "\\,", :siunitx => "", :siunitxsimple => "."
)
