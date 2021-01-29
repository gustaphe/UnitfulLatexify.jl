module UnitfulLatexify

using Unitful: Unitful, Unit, Units, Quantity, power, abbr, name, tens, sortexp, unit, @unit, register, NoDims
using Latexify
using LaTeXStrings

import Latexify.latexify
import Base.(:*)

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
         (:siunitx,  24) => "\\yotta",
         (:siunitxsimple,  -24) => "y",
         (:siunitxsimple,  -21) => "z",
         (:siunitxsimple,  -18) => "a",
         (:siunitxsimple,  -15) => "f",
         (:siunitxsimple,  -12) => "p",
         (:siunitxsimple,  -9 ) => "n",
         (:siunitxsimple,  -6 ) => "\\u",
         (:siunitxsimple,  -3 ) => "m",
         (:siunitxsimple,  -2 ) => "c",
         (:siunitxsimple,  -1 ) => "d",
         (:siunitxsimple,   0 ) => "",
         (:siunitxsimple,   1 ) => "D",
         (:siunitxsimple,   2 ) => "h",
         (:siunitxsimple,   3 ) => "k",
         (:siunitxsimple,   6 ) => "M",
         (:siunitxsimple,   9 ) => "G",
         (:siunitxsimple,   12) => "T",
         (:siunitxsimple,   15) => "P",
         (:siunitxsimple,   18) => "E",
         (:siunitxsimple,   21) => "Z",
         (:siunitxsimple,   24) => "Y",
        )
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
    if unitformat == :siunitx
        unitname = "\\$(lowercase(String(name(p))))"
        per = pow<0 ? "\\per" : ""
        pow = abs(pow)
        expo = pow==1//1 ? "" : "\\tothe{$(latexraw(pow;kwargs...,fmt="%g"))}"
    else
        unitname = abbr(p)
        per = ""
        expo = pow==1//1 ? "" : "^{$(latexraw(pow;kwargs...,fmt="%g"))}"
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

function listunits(::T) where T <: Units
    return sortexp(T.parameters[1])
end


@latexrecipe function f(p::T;unitformat=:mathrm) where T <: Unit{:One,NoDims}
    return ""
end

@latexrecipe function f(p::T;unitformat=:mathrm) where T <: Units{(Unit{:One,NoDims}(0,1),),NoDims,nothing}
    return ""
end

@latexrecipe function f(q::T;unitformat=:mathrm) where T <: Quantity{<:Number,NoDims,<:Units{(Unit{:One,NoDims}(0,1),),NoDims,nothing}}
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

*(q::Quantity,::Units{(Unit{:One,NoDims}(0,1),),NoDims,nothing}) = q

end
