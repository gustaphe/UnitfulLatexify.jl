latexslashunitlabel(l, u; kwargs...) = "\$$l\\;/\\;$(latexify(u; kwargs..., env=:raw))\$"
function latexroundunitlabel(l, u; kwargs...)
    return "\$$l\\;\\left($(latexify(u; kwargs..., env=:raw))\\right)\$"
end
function latexsquareunitlabel(l, u; kwargs...)
    return "\$$l\\;\\left[$(latexify(u; kwargs..., env=:raw))\\right]\$"
end
latexfracunitlabel(l, u; kwargs...) = "\$\\frac{$l}{$(latexify(u; kwargs..., env=:raw))}\$"

@latexrecipe function f(l::AbstractString, u::Units)
    return Expr(:latexifymerge, l, "\\;/\\;", u)
end
