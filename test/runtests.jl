using UnitfulLatexify
using Unitful
using Latexify
using LaTeXStrings
using Test

u = u"H*J/kg"
q = 24.7e9u"Gm/s^2"
n = 6.02214076e23u"one"

@testset "UnitfulLatexify.jl" begin
    @test latexify(u) == L"$\mathrm{H}\,\mathrm{J}\,\mathrm{kg}^{-1}$"
    @test latexify(u,unitformat=:siunitx) == LaTeXString("\\si{\\henry\\joule\\per\\kilo\\gram}")
    @test latexify(q) == L"$2.47e10\;\mathrm{Gm}\,\mathrm{s}^{-2}$"
    @test latexify(q,unitformat=:siunitx) == LaTeXString("\\SI{2.47e10}{\\giga\\meter\\per\\second\\tothe{2}}")
    @test latexify(n) == L"$6.022 \cdot 10^{23}$"
    @test latexify(n,unitformat=:siunitx) == LaTeXString("\\num{6.02214076e23}")
end
