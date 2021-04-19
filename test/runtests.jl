using UnitfulLatexify
using Unitful
using Latexify
using LaTeXStrings
using Test
using JuliaFormatter

function unitfullatexifytest(val, mathrmexpected, siunitxexpected, siunitxsimpleexpected)
    @test latexify(val; unitformat=:mathrm) == LaTeXString(mathrmexpected)
    @test latexify(val; unitformat=:siunitx) == LaTeXString(siunitxexpected)
    @test latexify(val; unitformat=:siunitxsimple) == LaTeXString(siunitxsimpleexpected)
end

@testset "Latexify units" begin
    unitfullatexifytest(
        u"H*J/kg",
        raw"$\mathrm{H}\,\mathrm{J}\,\mathrm{kg}^{-1}$",
        raw"\si{\henry\joule\per\kilo\gram}",
        raw"\si{H.J.kg^{-1}}",
    )
    unitfullatexifytest(
        24.7e9u"Gm/s^2",
        raw"$2.47 \cdot 10^{10}\;\mathrm{Gm}\,\mathrm{s}^{-2}$",
        raw"\SI{2.47e10}{\giga\meter\per\second\tothe{2}}",
        raw"\SI{2.47e10}{Gm.s^{-2}}",
    )
    unitfullatexifytest(
        6.02214076e23u"one",
        raw"$6.022 \cdot 10^{23}$",
        raw"\num{6.02214076e23}",
        raw"\num{6.02214076e23}",
    )
    unitfullatexifytest(u"percent", raw"$\mathrm{\%}$", raw"\si{\percent}", raw"\si{\%}")
    unitfullatexifytest(
        2u"°C", raw"$2\;\mathrm{^\circ C}$", raw"\SI{2}{\celsius}", raw"\SI{2}{\celsius}"
    )
    unitfullatexifytest(
        1u"°", raw"$1\mathrm{^{\circ}}$", raw"\SI{1}{\degree}", raw"\SI{1}{\degree}"
    )
    unitfullatexifytest(
        [1, 2, 3]u"m",
        raw"""
        \begin{equation}
        \left[
        \begin{array}{c}
        1 \\
        2 \\
        3 \\
        \end{array}
        \right]\;\mathrm{m}
        \end{equation}
        """,
        raw"""
        \begin{equation}
        \left[
        \begin{array}{c}
        \num{1} \\
        \num{2} \\
        \num{3} \\
        \end{array}
        \right]\;\si{\meter}
        \end{equation}
        """,
        raw"""
        \begin{equation}
        \left[
        \begin{array}{c}
        \num{1} \\
        \num{2} \\
        \num{3} \\
        \end{array}
        \right]\;\si{m}
        \end{equation}
        """,
    )
    @test latexify(24.7e9u"Gm/s^2"; fmt="%.1e") ==
          L"$2.5e+10\;\mathrm{Gm}\,\mathrm{s}^{-2}$"
end

@testset "permode" begin
    p = 5u"m^3*s^2/H/kg^4"
    @test latexify(p) == LaTeXString(
        raw"$5\;\mathrm{m}^{3}\,\mathrm{s}^{2}\,\mathrm{kg}^{-4}\,\mathrm{H}^{-1}$"
    )
    @test latexify(p; permode=:power) == LaTeXString(
        raw"$5\;\mathrm{m}^{3}\,\mathrm{s}^{2}\,\mathrm{kg}^{-4}\,\mathrm{H}^{-1}$"
    )
    @test latexify(p; permode=:slash) == LaTeXString(
        raw"$5\;\mathrm{m}^{3}\,\mathrm{s}^{2}\,/\,\mathrm{kg}^{4}\,\mathrm{H}$"
    )
    @test latexify(p; permode=:frac) == LaTeXString(
        raw"$5\;\frac{\mathrm{m}^{3}\,\mathrm{s}^{2}}{\mathrm{kg}^{4}\,\mathrm{H}}$"
    )
    @test latexify(p; unitformat=:siunitx, permode=:frac) ==
          latexify(p; unitformat=:siunitx)
    @test latexify(u"m"; permode=:frac) == latexify(u"m")
    @test latexify(u"m^-1"; permode=:frac) == LaTeXString(raw"$\frac{1}{\mathrm{m}}$")
    @test_throws ErrorException latexify(p; permode=:wrogn)
end

@testset "Labels" begin
    @test latexslashunitlabel("x", u"m") == "\$x\\;/\\;\\mathrm{m}\$"
    @test latexroundunitlabel("x", u"m") == "\$x\\;\\left(\\mathrm{m}\\right)\$"
    @test latexsquareunitlabel("x", u"m") == "\$x\\;\\left[\\mathrm{m}\\right]\$"
    @test latexfracunitlabel("x", u"m") == "\$\\frac{x}{\\mathrm{m}}\$"
    @test latexify("x", u"m") == "\$x\\;/\\;\\mathrm{m}\$"
end

format(UnitfulLatexify; overwrite=false) || @warn """
Code is not formatted correctly. Please run
```
julia> using JuliaFormatter, UnitfulLatexify; format(UnitfulLatexify)
```.
"""
