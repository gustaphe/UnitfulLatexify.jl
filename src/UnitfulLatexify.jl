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
    Latexify,
    @latexrecipe,
    latexify,
    _latexarray,
    latexraw,
    FancyNumberFormatter,
    PlainNumberFormatter,
    StyledNumberFormatter,
    SiunitxNumberFormatter,
    AbstractNumberFormatter
using LaTeXStrings: LaTeXString

import Latexify: latexify

import Base.*

export latexslashunitlabel, latexroundunitlabel, latexsquareunitlabel, latexfracunitlabel

function __init__()
    @warn """
        UnitfulLatexify is deprecated, and replaced with an extension on Unitful. 
        
        ```
        using Unitful, Latexify
        ````
        should trigger the extension.

        In updating code which previously used `UnitfulLatexify`, be aware of the following breaking changes:
        - The `unitformat` keyword argument is replaced by the `fmt` keyword argument, 
          which can be set to `FancyNumberFormatter()`, `SiunitxNumberFormatter()`., 
          or `StyledNumberFormatter()`. 
        - The `siunitxlegacy` keyword argument is replaced by the `version` keyword 
          argument of `SiunitxNumberFormatter()`.",
        - The functions `latexslashunitlabel`, `latexroundunitlabel`, 
          `latexsquareunitlabel`, and `latexfracunitlabel` no longer exist, 
          and should be replaced as either.
            - Direct substitute: `(l,u) -> latexify(l, u; labelformat=:slash)` 
              with `:slash`, `:round`, `:square`, or `:frac` 
            - First call `Latexify.set_default(labelformat=:slash)`, then use `latexify`
        """
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
