#!/bin/julia

# premake.jl
# Run locally (rarely) to generate a couple of figures needed by the
# documentation

using LaTeXStrings, Unitful, Latexify, UnitfulLatexify, PrettyTables

dir = mktempdir(; cleanup=false)

commands = [
    :(latexify(612.2u"nm")),
    :(latexify(u"kg*m/s^2")),
    :(latexify(612.2u"nm"; unitformat=:siunitx)),
    :(latexify(u"kg*m/s^2"; unitformat=:siunitx)),
    :(latexify(2.4e6u"one"; unitformat=:siunitx)),
    :(latexify(612.2u"nm"; unitformat=:siunitxsimple)),
    :(latexify(u"kg*m/s^2"; unitformat=:siunitxsimple)),
    #:(latexify(u"percent"; unitformat=:mathrm)), # Messes with comments
    :(latexify((1:5)u"m"; unitformat=:siunitx)),
    :(latexify((1, 2, 4) .* u"m"; unitformat=:siunitx)),
    :(latexify((1, 2, 4) .* u"one"; unitformat=:siunitx)),
]

open(joinpath(dir, "examples.tex"), "w") do f
    print(
        f,
        """
        \\documentclass{standalone}
        \\usepackage{booktabs}
        \\usepackage{siunitx}
        \\begin{document}
        """,
    )
    pretty_table(
        f,
        hcat(
            "\\verb+" .* string.(commands) .* "+",
            "\\verb+" .* eval.(commands) .* "+",
            eval.(commands),
        ),
        ["\\tt julia", "\\LaTeX", "Result"];
        tf=tf_latex_booktabs,
        alignment=[:l, :l, :l],
        wrap_table=false,
    )
    print(
        f,
        """
        \\end{document}
        """,
    )
end

# List manually imported from Unitful/src/pkgdefaults.jl
# Could be automated by temporarily redefining @unit, @affineunit ... and include()ing this file.
functions = [
    x -> "\\verb+$(string(x))+",
    x -> latexify.(x, unitformat=:mathrm),
    x -> latexify.(x, unitformat=:siunitx),
    x -> latexify(x; unitformat=:siunitxsimple),
]
allunits = begin
    uparse.([
        "nH*m/Hz",
        "m",
        "s",
        "A",
        "K",
        "cd",
        "g",
        "mol",
        "sr",
        "rad",
        "°",
        "Hz",
        "N",
        "Pa",
        "J",
        "W",
        "C",
        "V",
        "S",
        "F",
        "H",
        "T",
        "Wb",
        "lm",
        "lx",
        "Bq",
        "Gy",
        "Sv",
        "kat",
        #"percent", # Messes with comments
        "permille", # Undefined in all formats
        "pertenthousand", # Undefined in all formats (butchered)
        "°C",
        "°F",
        "minute",
        "hr",
        "d",
        "wk", # Undefined in siunitx
        "yr", # Undefined in siunitx
        "rps", # Undefined in siunitx
        "rpm", # Undefined in siunitx
        "a", # Undefined in siunitx
        "b",
        "L",
        "M", # Undefined in siunitx
        "eV",
        "Hz2π", # Butchered by encoding
        "bar",
        "atm", # Undefined in siunitx
        "Torr", # Undefined in siunitx
        "c", # Undefined in siunitx
        "u", # Undefined in siunitx
        "ge", # Undefined in siunitx
        "Gal", # Undefined in siunitx
        "dyn", # Undefined in siunitx
        "erg", # Undefined in siunitx
        "Ba", # Undefined in siunitx
        "P", # Undefined in siunitx
        "St", # Undefined in siunitx
        #"Gauss", # errors in testing, maybe from Unitful.jl's dev branch?
        #"Oe", # errors in testing, maybe from Unitful.jl's dev branch?
        #"Mx", # errors in testing, maybe from Unitful.jl's dev branch?
        "inch", # Undefined in siunitx
        "mil", # Undefined in siunitx
        "ft", # Undefined in siunitx
        "yd", # Undefined in siunitx
        "mi", # Undefined in siunitx
        "angstrom", # Undefined in mathrm,siunitxsimple
        "ac", # Undefined in siunitx
        "Ra", # Undefined in siunitx
        "lb", # Undefined in siunitx
        "oz", # Undefined in siunitx
        "slug", # Undefined in siunitx
        "dr", # Undefined in siunitx
        "gr", # Undefined in siunitx
        "lbf", # Undefined in siunitx
        "cal", # Undefined in siunitx
        "btu", # Undefined in siunitx
        "psi", # Undefined in siunitx
        #"dBHz", # Cannot *yet* be latexified.
        #"dBm", # Cannot *yet* be latexified.
        #"dBV", # Cannot *yet* be latexified.
        #"dBu", # Cannot *yet* be latexified.
        #"dBμV", # Cannot *yet* be latexified.
        #"dBSPL", # Cannot *yet* be latexified.
        #"dBFS", # Cannot *yet* be latexified.
        #"dBΩ", # Cannot *yet* be latexified.
        #"dBS", # Cannot *yet* be latexified.
    ])
end

open(joinpath(dir, "allunits.tex"), "w") do f
    print(
        f,
        """
        \\documentclass{standalone}
        \\usepackage{booktabs}
        \\usepackage{siunitx}
        \\begin{document}
        """,
    )
    pretty_table(
        f,
        [fun(s) for s in allunits, fun in functions],
        ["Name", "\\tt :mathrm", "\\tt :siunitx", "\\tt :siunitxsimple"];
        tf=tf_latex_booktabs,
        alignment=[:l, :l, :l, :l],
        wrap_table=false,
    )
    print(
        f,
        """
        \\end{document}
        """,
    )
end

for s in ["examples", "allunits"]
    try
        run(
            `xelatex -interaction=nonstopmode -output-directory $dir $(joinpath(dir,s*".tex"))`,
        )
    catch
    end

    try
        run(
            `convert -fill white -opaque none -density 600 -quality 90 $(joinpath(dir,s*".pdf")) $(joinpath(pkgdir(UnitfulLatexify),"docs","src","assets",s*".png"))`,
        )
    catch
    end
end
