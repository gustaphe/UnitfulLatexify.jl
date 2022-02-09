# UnitfulLatexify
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://gustaphe.github.io/UnitfulLatexify.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://gustaphe.github.io/UnitfulLatexify.jl/dev)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

Adds Latexify recipes for Unitful units and quantities.

Because Github doesn't display ``\\LaTeX`` strings very well, I recommend
reading the [documentation](https://gustaphe.github.io/UnitfulLatexify.jl/dev) instead of the README.

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
L"\qty{612.2}{\nano\meter}"

julia> latexify(u,unitformat=:mathrm) # explicit default
L"$\mathrm{kg}\,\mathrm{m}\,\mathrm{s}^{-2}$"

julia> latexify(u,unitformat=:siunitx)
L"\unit{\kilo\gram\meter\per\second\tothe{2}}"
```

## Results
![Results](/docs/src/assets/examples.png)
