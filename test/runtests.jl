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

@testset "UnitfulLatexify.jl" begin
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
        2u"°C",
        raw"$2\;\mathrm{^\circ C}$",
        raw"\SI{2}{\celsius}",
        raw"\SI{2}{degreeCelsius}",
    )
    unitfullatexifytest(
        1u"°", raw"$1\mathrm{^{\circ}}$", raw"\SI{1}{\degree}", raw"\SI{1}{°}"
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
    @test latexslashunitlabel("x", u"m") == "\$x\\;/\\;\\mathrm{m}\$"
    @test latexroundunitlabel("x", u"m") == "\$x\\;\\left(\\mathrm{m}\\right)\$"
    @test latexsquareunitlabel("x", u"m") == "\$x\\;\\left[\\mathrm{m}\\right]\$"
    @test latexfracunitlabel("x", u"m") == "\$\\frac{x}{\\mathrm{m}}\$"
    @test format(pkgdir(UnitfulLatexify), BlueStyle(); overwrite=false)
end
