@latexrecipe function f(u::AffineUnits)
    insert_deprecated_unitformat!(kwargs)
    fmt = get_formatter(kwargs)
    if u == Unitful.°C
        unitname = :Celsius
    elseif u == Unitful.°F
        unitname = :Fahrenheit
    else
        # If it's not celsius or farenheit, let it do the default thing
        return genericunit(u)
    end
    if fmt isa SiunitxNumberFormatter
        env --> :raw
        return Expr(:latexifymerge, "\\unit{", unitnames[(:siunitx, unitname)], "}")
    end
    env --> :inline
    return LaTeXString(unitnames[(:mathrm, unitname)])
end

@latexrecipe function f(q::AffineQuantity)
    insert_deprecated_unitformat!(kwargs)
    fmt = get_formatter(kwargs)
    u = unit(q)
    if u == Unitful.°C
        unitname = :Celsius
    elseif u == Unitful.°F
        unitname = :Fahrenheit
    else
        # If it's not celsius or farenheit, let it do the default thing
        return ustrip(q)*genericunit(u)
    end
    if fmt isa SiunitxNumberFormatter
        env --> :raw
        return Expr(
                    :latexifymerge, "\\qty{", NakedNumber(q.val), "}{", unitnames[(:siunitx, unitname)], "}"
                   )
    end
    env --> :inline
    return Expr(
                :latexifymerge, q.val, "\\;\\mathrm{", unitnames[(:mathrm, unitname)], "}"
               )
end
