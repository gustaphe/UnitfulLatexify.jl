module UnitfulLatexify

import Unitful, Latexify

function __init__()
    @warn """
        UnitfulLatexify is deprecated, and replaced with an extension on Unitful. 

        The package is now empty, to prevent errors caused by loading it at the same time as the Unitful extension.
        
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
end

end
