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

include("prefixes.jl")
include("unitnames.jl")

function getunitname(p::T,unitformat) where T <: Unit
    unitname = get(unitnames,(unitformat,name(p)),nothing)
    isnothing(unitname) || return unitname
    if unitformat == :siunitx
        return "\\$(lowercase(String(name(p))))"
    end
    return abbr(p)
end

@latexrecipe function f(p::T;unitformat=:mathrm) where T <: Unit
    prefix = prefixes[(unitformat, tens(p))]
    pow = power(p)
    unitname = getunitname(p, unitformat)
    if unitformat == :mathrm
        env --> :inline
        if pow == 1//1
            expo = ""
        else
            expo = "^{$(latexraw(pow;kwargs...,fmt="%g"))}"
        end
        return LaTeXString("\\mathrm{$prefix$unitname}$expo")
    end
    env --> :raw
    if unitformat == :siunitx
        per = pow<0 ? "\\per" : ""
        pow = abs(pow)
        expo = pow==1//1 ? "" : "\\tothe{$(latexraw(pow;kwargs...,fmt="%g"))}"
    else
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
