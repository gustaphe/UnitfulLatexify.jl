module UnitfulLatexify

using Unitful: Unitful, Unit, Units, Quantity, power, abbr, name, tens, sortexp, unit, @unit, register, NoDims, ustrip, @u_str
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
                                latexify(q.val;kwargs...,env=:raw)
                               )}")
end

*(q::Quantity,::Units{(Unit{:One,NoDims}(0,1),),NoDims,nothing}) = q

@latexrecipe function f(a::AbstractArray{Quantity{N,D,U}};unitformat=:mathrm) where {N<:Number,D,U}
    # Array of quantities with the same unit
    env --> :equation
    return LaTeXString(join(
                            (
                             latexarray((ustrip.(a).*u"one");kwargs...,unitformat),
                             latexify(unit(first(a));kwargs...,unitformat,env=:raw)
                            ),"\\;"
                           ))
end

@latexrecipe function f(r::AbstractRange{Quantity{N,D,U}};unitformat=:mathrm) where {N<:Number,D,U}
    if unitformat == :siunitx
        return LaTeXString(join((
                                 "\\SIrange{",
                                 latexify(r.start.val;kwargs...,env=:raw),
                                 "}{",
                                 latexify(r.stop.val;kwargs...,env=:raw),
                                 "}{",
                                 latexify.(listunits(unit(r.start));kwargs...,unitformat,env=:raw)...,
                                 "}",
                                ))
                          )
    end
    if unitformat == :siunitxsimple
        return LaTeXString(join((
                                 "\\SIrange{",
                                 latexify(r.start.val;kwargs...,env=:raw),
                                 "}{",
                                 latexify(r.stop.val;kwargs...,env=:raw),
                                 "}{",
                                 join(
                                      latexify.(listunits(unit(r.start));kwargs...,unitformat,env=:raw),
                                      "."
                                     ),
                                 "}",
                                ))
                          )
    end
    return LaTeXString(join(
                            (latexarray((ustrip.(r).*u"one");kwargs...,unitformat,env=:raw),
                             latexify(unit(r.start);kwargs...,unitformat,env=:raw)
                            ),"\\;"
                           ))
end

@latexrecipe function f(r::T;unitformat=:mathrm) where T <: AbstractRange{Quantity{N,D,U}} where {N<:Number,D,U<:Units{(Unit{:One,NoDims}(0,1),),NoDims,nothing}}
    if unitformat == :siunitx || unitformat == :siunitxsimple
        return LaTeXString(join((
                                 "\\numrange{",
                                 latexify(r.start.val;kwargs...,env=:raw),
                                 "}{",
                                 latexify(r.stop.val;kwargs...,env=:raw),
                                 "}"
                                ))
                          )
    end
    return latexarray((ustrip.(r)))
end

@latexrecipe function f(l::Tuple{T,Vararg{T}};unitformat=:mathrm) where T <: Quantity{N,D,U} where {N<:Number,D,U}
    if unitformat == :siunitx
        return LaTeXString(join(
                                (
                                 "\\SIlist{",
                                 join(latexify.(ustrip.(l);kwargs...,unitformat,env=:raw),";"),
                                 "}{",
                                 latexify.(listunits(unit(first(l)));kwargs...,unitformat,env=:raw)...,
                                 "}",
                                )
                               ))

    end
    if unitformat == :siunitxsimple
        return LaTeXString(join(
                                (
                                 "\\SIlist{",
                                 join(latexify.(ustrip.(l);kwargs...,unitformat,env=:raw),";"),
                                 "}{",
                                 join(latexify.(listunits(unit(first(l)));kwargs...,unitformat,env=:raw),"."),
                                 "}",
                                )
                               ))
    end
    return [l...]
end

@latexrecipe function f(l::Tuple{T,Vararg{T}};unitformat=:mathrm) where T <: Quantity{N,D,U} where {N<:Number,D,U<:Units{(Unit{:One,NoDims}(0,1),),NoDims,nothing}}
    if unitformat == :siunitx || unitformat == :siunitxsimple
        return LaTeXString(join(
                                (
                                 "\\numlist{",
                                 join(latexify.(ustrip.(l);kwargs...,unitformat,env=:raw),";"),
                                 "}"
                                )
                               ))
    end
    return [ustrip.(l)...]
end

end
