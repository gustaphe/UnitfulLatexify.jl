# UnitfulLatexify
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://gustaphe.github.io/UnitfulLatexify.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://gustaphe.github.io/UnitfulLatexify.jl/dev)
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
```

$$
612.2 \mathrm{nm}
$$

```julia
julia> latexify(u; unitformat=:mathrm) # explicit default
L"$\mathrm{kg}\,\mathrm{m}\,\mathrm{s}^{-2}$"
```

$$
\mathrm{kg} \mathrm{m} \mathrm{s}^{-2}
$$

```julia
julia> latexify(q; unitformat=:siunitx)
L"\qty{612.2}{\nano\meter}"

julia> latexify(u,unitformat=:siunitx)
L"\unit{\kilo\gram\meter\per\second\tothe{2}}"
```

One use case is in Pluto notebooks, where my current favourite workflow is to
write

```julia
Markdown.parse("""
The period is $(@latexrun T = $(2.5u"ms")), so the frequency is $(@latexdefine f = 1/T post=u"kHz").
""")
```
, which renders as

> The period is $T = 2.5 \mathrm{ms}$, so the frequency is $f = \frac{1}{T} = 0.4 \mathrm{kHz}$.

Note that the quantity has to be interpolated (put inside a
dollar-parenthesis), or Latexify will interpret it as a multiplication between
a number and a call to `@u_str`.

## More examples
![Results](/docs/src/assets/examples.png)
