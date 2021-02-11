@latexrecipe function f(p::T;unitformat=:mathrm) where T <: Unit
    prefix = prefixes[(unitformat, tens(p))]
    pow = power(p)
    unitname = getunitname(p, unitformat)
    if unitformat == :mathrm
        env --> :inline
        if pow == 1//1
            expo = ""
        else
            expo = "^{$(latexify(pow;kwargs...,fmt="%g",env=:raw))}"
        end
        return LaTeXString("\\mathrm{$prefix$unitname}$expo")
    end
    env --> :raw
    if unitformat == :siunitx
        per = pow<0 ? "\\per" : ""
        pow = abs(pow)
        expo = pow == 1//1 ? "" : "\\tothe{$(latexify(pow;kwargs...,fmt="%g",env=:raw))}"
    else
        per = ""
        expo = pow == 1//1 ? "" : "^{$(latexify(pow;kwargs...,fmt="%g",env=:raw))}"
    end
    return LaTeXString("$per$prefix$unitname$expo")
end

@latexrecipe function f(u::T;unitformat=:mathrm) where T <: Units
    if unitformat == :mathrm
        env --> :inline
        return LaTeXString(join(latexify.(listunits(u);kwargs...,env=:raw),"\\,"))
    end
    env --> :raw
    if unitformat == :siunitx
        return LaTeXString(join(("\\si{",latexify.(listunits(u);kwargs...,env=:raw)...,"}")))
    end
    return LaTeXString(join(("\\si{",join(latexify.(listunits(u);kwargs...,env=:raw),"."),"}")))
end

@latexrecipe function f(q::T;unitformat=:mathrm) where T <: Quantity
    if unitformat == :mathrm
        env --> :inline
        fmt --> FancyNumberFormatter()
        return LaTeXString(join((latexify(q.val;kwargs...,env=:raw),
                                 "\\;",
                                 join(
                                      latexify.(listunits(unit(q));kwargs...,env=:raw),
                                      "\\,"
                                     )
                                )))
    end
    env --> :raw
    return LaTeXString(join(("\\SI{",
                             latexify(q.val;kwargs...,env=:raw),
                             "}{",
                             join(latexify.(listunits(unit(q));kwargs...,env=:raw),
                                  unitformat==:siunitxsimple ? "." : ""),
                             "}"
                            )))
end

