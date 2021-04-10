using Documenter
using UnitfulLatexify
using LaTeXStrings

Base.show(io::IO, mime::MIME"text/html", l::LaTeXString) = show(io, mime, l.s)

makedocs(;
    sitename="UnitfulLatexify.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", nothing) == "true", mathengine=MathJax3()
    ),
    modules=[UnitfulLatexify],
    doctest=false,
    pages=["index.md"],
)

deploydocs(; devbranch="main", repo="github.com/gustaphe/UnitfulLatexify.jl.git")
