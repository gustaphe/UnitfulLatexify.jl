module UnitfulLatexify

using Unitful:
    Unitful,
    Unit,
    Units,
    AbstractQuantity,
    AffineUnits,
    AffineQuantity,
    power,
    abbr,
    name,
    tens,
    sortexp,
    unit,
    @unit,
    register,
    NoDims,
    ustrip,
    @u_str,
    genericunit,
    has_unit_spacing
using Latexify:
    Latexify, @latexrecipe, latexify, _latexarray, FancyNumberFormatter, latexraw
using LaTeXStrings: LaTeXString

import Latexify.latexify
import Base.(:*)

export latexslashunitlabel, latexroundunitlabel, latexsquareunitlabel, latexfracunitlabel

function __init__()
    return register(UnitfulLatexify)
end

include("prefixes.jl")
include("unitnames.jl")

include("auxiliary.jl")
include("default.jl")
include("one.jl")
include("arrays.jl")
include("affine.jl")
include("label.jl")

end
