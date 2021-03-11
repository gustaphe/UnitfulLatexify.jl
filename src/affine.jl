@latexrecipe function f(u::T; unitformat=:mathrm) where T <: AffineUnits
    if u == Unitful.°C
        unitname = :Celsius
    elseif u == Unitful.°F
        unitname = :Fahrenheit
    else
        # If it's not celsius or farenheit, let it do the default thing
        return genericunit(u)
    end
    if unitformat === :mathrm
        env --> :inline
        return LaTeXString(unitnames[(unitformat, unitname)])
    end
    env --> :raw
    return LaTeXString(string(
                              "\\si{",
                              unitnames[(unitformat, unitname)],
                              "}"
                             ))
end


@latexrecipe function f(q::T; unitformat =:mathrm) where T <: AffineQuantity
    u = unit(q)
    if u == Unitful.°C
        unitname = :Celsius
    elseif u == Unitful.°F
        unitname = :Fahrenheit
    else
        # If it's not celsius or farenheit, let it do the default thing
        return genericunit(u)
    end
    if unitformat === :mathrm
        env --> :inline
        fmt --> FancyNumberFormatter()
        return LaTeXString(join((latexify(q.val; kwargs..., env=:raw),
                                 "\\;\\mathrm{",
                                 unitnames[(unitformat, unitname)],
                                 "}"
                                )))
    end
    env --> :raw
    return LaTeXString(join(("\\SI{",
                             latexify(q.val; kwargs..., env=:raw),
                             "}{",
                             unitnames[(unitformat,unitname)],
                             "}"
                            )))
end

