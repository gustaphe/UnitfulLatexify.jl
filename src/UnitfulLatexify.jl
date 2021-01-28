module UnitfulLatexify

using Unitful: Unitful, Unit, FreeUnits, Quantity, power, abbr, name, tens, sortexp, unit, @unit, register, NoDims
using Latexify
using LaTeXStrings

function __init__()
    register(UnitfulLatexify)
end

# #key:   Symbol  Display  Name      Equals      Prefixes?
@unit     one     ""       One       1           false
register(UnitfulLatexify)

const prefixes = begin
    Dict(
         (:mathrm,  -24) => "y",
         (:mathrm,  -21) => "z",
         (:mathrm,  -18) => "a",
         (:mathrm,  -15) => "f",
         (:mathrm,  -12) => "p",
         (:mathrm,  -9 ) => "n",
         (:mathrm,  -6 ) => "\\mu",
         (:mathrm,  -3 ) => "m",
         (:mathrm,  -2 ) => "c",
         (:mathrm,  -1 ) => "d",
         (:mathrm,   0 ) => "",
         (:mathrm,   1 ) => "D",
         (:mathrm,   2 ) => "h",
         (:mathrm,   3 ) => "k",
         (:mathrm,   6 ) => "M",
         (:mathrm,   9 ) => "G",
         (:mathrm,   12) => "T",
         (:mathrm,   15) => "P",
         (:mathrm,   18) => "E",
         (:mathrm,   21) => "Z",
         (:mathrm,   24) => "Y",
         (:siunitx, -24) => "\\yocto",
         (:siunitx, -21) => "\\zepto",
         (:siunitx, -18) => "\\atto",
         (:siunitx, -15) => "\\femto",
         (:siunitx, -12) => "\\pico",
         (:siunitx, -9 ) => "\\nano",
         (:siunitx, -6 ) => "\\micro",
         (:siunitx, -3 ) => "\\milli",
         (:siunitx, -2 ) => "\\centi",
         (:siunitx, -1 ) => "\\deci",
         (:siunitx,  0 ) => "",
         (:siunitx,  1 ) => "\\deka",
         (:siunitx,  2 ) => "\\hecto",
         (:siunitx,  3 ) => "\\kilo",
         (:siunitx,  6 ) => "\\mega",
         (:siunitx,  9 ) => "\\giga",
         (:siunitx,  12) => "\\tera",
         (:siunitx,  15) => "\\peta",
         (:siunitx,  18) => "\\exa",
         (:siunitx,  21) => "\\zetta",
         (:siunitx,  24) => "\\yotta"
        )
end

@latexrecipe function f(q::T;unitformat=:mathrm) where T <: Quantity{N,NoDims,FreeUnits{(Unit{:One,NoDims}(0,1),),NoDims,nothing}} where N<:Number
    if unitformat == :mathrm
        env --> :inline
        fmt --> FancyNumberFormatter()
        return q.val
    end
    env --> :raw
    return LaTeXString("\\num{$(
                                latexraw(q.val;kwargs...)
                               )}")
end

@latexrecipe function f(p::T;unitformat=:mathrm) where T <: Unit{:One,NoDims}
    return ""
end

@latexrecipe function f(p::T;unitformat=:mathrm) where T <: Unit
    prefix = prefixes[(unitformat, tens(p))]
    pow = power(p)
    if unitformat == :mathrm
        env --> :inline
        unitname = abbr(p)
        if pow == 1//1
            expo = ""
        else
            expo = "^{$(latexraw(pow;kwargs...,fmt="%g"))}"
        end
        return LaTeXString("\\mathrm{$prefix$unitname}$expo")
    end
    env --> :raw
    unitname = "\\$(lowercase(String(name(p))))"
    per = pow<0 ? "\\per" : ""
    pow = abs(pow)
    expo = pow==1//1 ? "" : "\\tothe{$(latexraw(pow;kwargs...,fmt="%g"))}"
    return LaTeXString("$per$prefix$unitname$expo")
end

function listunits(::T) where T <: FreeUnits
    return sortexp(T.parameters[1])
end

@latexrecipe function f(u::T;unitformat=:mathrm) where T <: FreeUnits
    if unitformat == :mathrm
        env --> :inline
        return LaTeXString(join(latexify.(listunits(u);kwargs...,env=:raw),"\\,"))
    end
    env --> :raw
    return LaTeXString(join(("\\si{",latexify.(listunits(u);kwargs...,env=:raw)...,"}")))
end

@latexrecipe function f(q::T;unitformat=:mathrm) where T <: Quantity
    if unitformat == :mathrm
        env --> :inline
        fmt --> FancyNumberFormatter()
        return LaTeXString(join((latexraw(q.val;kwargs...),
                                 "\\;",
                                 join(
                                      latexify.(listunits(unit(q));kwargs...,env=:raw),
                                      "\\,"
                                     )
                                )))
    end
    env --> :raw
    return LaTeXString(join(("\\SI{",
                             latexraw(q.val;kwargs...),
                             "}{",
                             latexify.(listunits(unit(q));kwargs...,env=:raw)...,
                             "}"
                            )))
end

end
