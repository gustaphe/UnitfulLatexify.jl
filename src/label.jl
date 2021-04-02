latexslashunitlabel(l, u; kwargs...) = "\$$l\\;/\\;$(latexify(u; kwargs..., env=:raw))\$"
latexroundunitlabel(l, u; kwargs...) = "\$$l\\;\\left($(latexify(u; kwargs..., env=:raw))\\right)\$"
latexsquareunitlabel(l, u; kwargs...) = "\$$l\\;\\left[$(latexify(u; kwargs..., env=:raw))\\right]\$"
latexfracunitlabel(l, u; kwargs...) = "\$\\frac{$l}{$(latexify(u; kwargs..., env=:raw))}\$"
