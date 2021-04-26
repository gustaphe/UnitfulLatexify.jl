function latexslashunitlabel(l, u; kwargs...)
    return LaTeXString("\$$l\\;\\left/\\;$(latexify(u; kwargs..., env=:raw))\\right.\$")
end
function latexroundunitlabel(l, u; kwargs...)
    return LaTeXString("\$$l\\;\\left($(latexify(u; kwargs..., env=:raw))\\right)\$")
end
function latexsquareunitlabel(l, u; kwargs...)
    return LaTeXString("\$$l\\;\\left[$(latexify(u; kwargs..., env=:raw))\\right]\$")
end
function latexfracunitlabel(l, u; kwargs...)
    return LaTeXString("\$\\frac{$l}{$(latexify(u; kwargs..., env=:raw))}\$")
end

@latexrecipe function f(l::AbstractString, u::Units)
    return Expr(:latexifymerge, l, "\\;\\left/\\;", u, "\\right.")
end
