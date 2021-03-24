# UnitfulLatexify
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

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
L"$\mathrm{kg}\,\mathrm{m}\,\mathrm{s}^{-2}$"

julia> latexify(u,unitformat=:siunitx)
L"\si{\kilo\gram\meter\per\second\tothe{2}}"
```

`Array`s of `Quantity` numbers will move the unit outside the array if there's a common unit. If the units differ, the result will unfortunately not be as nice. There's a fix on the way upstream.

`Range`s of quantities will be expressed as `\SIrange`s (or `\numrange`s in the case of `u"one"`) in `:siunitx` and `:siunitxsimple` format. `Tuple`s will become `\SIlist`s. To get the original behaviour, treating ranges and tuples as arrays, make them explicit (`[x...]`).


The `unitformat` argument can be set as a default by `set_default(unitformat=:siunitx)`. Implemented `unitformat`s are `:mathrm` (`1\;\mathrm{mm}`),`:siunitx` (`\SI{1}{\milli\meter}`) and `siunitxsimple` (`\SI{1}{mm}`), examples below and a more comprehensive image in docs/allunits.png.


## Results
![Results](/docs/examples.png)

## Labels
when plotting unitful quantities using `UnitfulRecipes`, you can supply a keyword `unitformat` (coincidentally), which determines how the axis guides are printed. In service of this, `UnitfulLatexify.jl` exports these functions:

| function | format (applied to `("x", u"m")` |
| ---- | ---- |
| `latexslashunitlabel` | ``x\;/\;\mathrm{m}`` |
| `latexroundunitlabel` | ``x\;\left(\mathrm{m}\right)`` |
| `latexsquareunitlabel` | ``x\;\left[\mathrm{m}\right]`` |
| `latexfracunitlabel` | ``\frac{x}{\mathrm{m}}`` |

Simply supply this when plotting: `plot(x, y; xlabel="x", unitformat=latexslashunitlabel)`.

## Extra notes
Introduces dimensionless unit `u"one"`, which causes a `\num` command in `:siunitx` mode. This is for corner cases, and will have to be invoked manually.
