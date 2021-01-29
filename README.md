# UnitfulLatexify
Adds Latexify recipes for Unitful units and quantities.

## Installation
```julia
] add UnitfulLatexify
```

## Usage
```julia
julia> using Unitful, Latexify, UnitfulLatexify;

julia> q = 612.2u"nm";

julia> u = u"kg*m/s^2";

julia> latexify(q)
L"$612.2\;\mathrm{nm}$"

julia> latexify(q,unitformat=:siunitx)
L"\SI{612.2}{\nano\meter}"

julia> latexify(u,unitformat=:mathrm) # explicit default
L"$\mathrm{kg}\mathrm{m}\mathrm{s}^{-2}$"

julia> latexify(u,unitformat=:siunitx)
L"\si{\kilo\gram\meter\per\second\tothe{2}}"
```

The `unitformat` argument can be set as a default by `set_default(unitformat=:siunitx)`.

## Results
![Results](/docs/examples.png)

## Extra notes
Introduces dimensionless unit `u"one"`, which causes a `\num` command in `:siunitx` mode. This is for corner cases, and will have to be invoked manually.
