using UnitfulLatexify
using Unitful
using Latexify
using Latexify: FancyNumberFormatter, SiunitxNumberFormatter
using LaTeXStrings
using Test
using JuliaFormatter

function unitfullatexifytest(val, mathrmexpected, siunitxexpected, siunitxsimpleexpected)
    @test latexify(val; fmt=FancyNumberFormatter()) ==
        LaTeXString(replace(mathrmexpected, "\r\n" => "\n"))
    @test latexify(val; fmt=SiunitxNumberFormatter()) ==
        LaTeXString(replace(siunitxexpected, "\r\n" => "\n"))
    @test latexify(val; fmt=SiunitxNumberFormatter(simple=true)) ==
        LaTeXString(replace(siunitxsimpleexpected, "\r\n"=>"\n"))
end

@testset "Latexify units" begin
    unitfullatexifytest(
        u"H*J/kg",
        raw"$\mathrm{H}\,\mathrm{J}\,\mathrm{kg}^{-1}$",
        raw"\unit{\henry\joule\per\kilo\gram}",
        raw"\unit{H.J.kg^{-1}}",
    )
    unitfullatexifytest(
        24.7e9u"Gm/s^2",
        raw"$2.47 \cdot 10^{10}\;\mathrm{Gm}\,\mathrm{s}^{-2}$",
        raw"\qty{2.47e10}{\giga\meter\per\second\tothe{2}}",
        raw"\qty{2.47e10}{Gm.s^{-2}}",
    )
    # @test_deprecated latexify(6.02214076e23u"one")
    # unitfullatexifytest(
    #     6.02214076e23u"one",
    #     latexify(6.02214076e23; fmt=FancyNumberFormatter()),
    #     latexify(6.02214076e23; fmt=SiunitxNumberFormatter()),
    #     latexify(6.02214076e23; fmt=SiunitxNumberFormatter()),
    # )
    unitfullatexifytest(
        u"percent", raw"$\mathrm{\%}$", raw"\unit{\percent}", raw"\unit{\%}"
    )
    unitfullatexifytest(
        2u"°C", raw"$2\;\mathrm{^\circ C}$", raw"\qty{2}{\celsius}", raw"\qty{2}{\celsius}"
    )
    unitfullatexifytest(
        1u"°", raw"$1\mathrm{^{\circ}}$", raw"\qty{1}{\degree}", raw"\qty{1}{\degree}"
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
        \right]\;\unit{\meter}
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
        \right]\;\unit{m}
        \end{equation}
        """,
    )
    @test latexify(24.7e9u"Gm/s^2"; fmt="%.1e") ==
        L"$2.5e+10\;\mathrm{Gm}\,\mathrm{s}^{-2}$"

    @test latexify(5.9722e24u"kg"; fmt=SiunitxNumberFormatter(version=2)) ==
        raw"\SI{5.9722e24}{\kilo\gram}"
    @test latexify(u"eV"; fmt=SiunitxNumberFormatter(version=2)) == raw"\si{\electronvolt}"
    # @test_deprecated latexify(24.7e9u"Gm/s^2"; unitformat=:siunitx)
    # @test_deprecated latexify(24.7e9u"Gm/s^2"; siunitxlegacy=true)
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
    @test latexify(p; permode=:frac, fmt=SiunitxNumberFormatter()) ==
        latexify(p; fmt=SiunitxNumberFormatter())
    @test latexify(u"m"; permode=:frac) == latexify(u"m")
    @test latexify(u"m^-1"; permode=:frac) == LaTeXString(raw"$\frac{1}{\mathrm{m}}$")
    @test_throws ErrorException latexify(p; permode=:wrogn)
end

@testset "Labels" begin
    @test latexify("x", u"m"; labelformat=:slash) == "\$x\\;\\left/\\;\\mathrm{m}\\right.\$"
    @test latexify("x", u"m"; labelformat=:round) == "\$x\\;\\left(\\mathrm{m}\\right)\$"
    @test latexify("x", u"m"; labelformat=:square) == "\$x\\;\\left[\\mathrm{m}\\right]\$"
    @test latexify("x", u"m"; labelformat=:frac) == "\$\\frac{x}{\\mathrm{m}}\$"
    @test latexify("x", u"m") == "\$x\\;\\left/\\;\\mathrm{m}\\right.\$"
end

@testset "Parentheses" begin
    if isdefined(Latexify, :_getoperation)
        @test @latexify($(3u"mm")^2 - 4 * $(2u"mm^2")) ==
            raw"$\left( 3\;\mathrm{mm} \right)^{2} - 4 \cdot 2\;\mathrm{mm}^{2}$"
    end
end

format(UnitfulLatexify; overwrite=false) || @warn """
Code is not formatted correctly. Please run
```
julia> using JuliaFormatter, UnitfulLatexify; format(UnitfulLatexify)
```.
"""
