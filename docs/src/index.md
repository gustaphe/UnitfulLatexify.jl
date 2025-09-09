# UnitfulLatexify.jl

A glue package for [Unitful.jl](https://github.com/PainterQubits/Unitful.jl)
and [Latexify.jl](https://github.com/korsbo/Latexify.jl), allowing easy and
pretty latexification of Unitful quantities, numbers and units.

## Deprecation

As of Unitful.jl 1.25, UnitfulLatexify is superceded by an extension to Unitful.
Loading both Unitful and Latexify will automatically load this functionality.

This package is now empty, to prevent errors caused by loading it at the same time as the Unitful extension.

In updating code which previously used `UnitfulLatexify` explicitly, be aware of the following breaking changes:
- The `unitformat` keyword argument to `latexify` is replaced by the `fmt` keyword argument, 
which can be set to `FancyNumberFormatter()`, `SiunitxNumberFormatter()`., 
or `StyledNumberFormatter()`. 
- The `siunitxlegacy` keyword argument is replaced by the `version` keyword 
argument of `SiunitxNumberFormatter()`, where `2` means legacy and `3` means current.",
- The functions `latexslashunitlabel`, `latexroundunitlabel`, 
`latexsquareunitlabel`, and `latexfracunitlabel` no longer exist, 
and should be replaced as either:
  - Direct substitute: `(l,u) -> latexify(l, u; labelformat=:slash)` 
  	with `:slash`, `:round`, `:square`, or `:frac` 
  - First call `Latexify.set_default(labelformat=:slash)`, then use `latexify`