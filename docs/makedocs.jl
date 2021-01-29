#!/bin/julia
using LaTeXStrings, Unitful, Latexify, UnitfulLatexify, PrettyTables

commands = [
            :(latexify(612.2u"nm")),
            :(latexify(u"kg*m/s^2")),
            :(latexify(612.2u"nm",  unitformat=:siunitx)),
            :(latexify(u"kg*m/s^2", unitformat=:siunitx)),
            :(latexify(24u"one",    unitformat=:siunitx)),
           ]

open("examples.tex","w") do f
    print(f, """
            \\documentclass{standalone}
            \\usepackage{booktabs}
            \\usepackage{siunitx}
            \\begin{document}
            """)
    pretty_table(f,
                 hcat(
                      "\\verb+".*string.(commands).*"+",
                      "\\verb+".*eval.(commands).*"+",
                      eval.(commands),
                     ),
                 ["\\tt julia","\\LaTeX","Result"],
                 tf=tf_latex_booktabs,
                 alignment=[:l,:l,:l],
                 wrap_table=false,
                )
    print(f,"""
          \\end{document}
          """)
end


