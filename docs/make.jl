using Documenter

makedocs(;
    sitename="UnitfulLatexify.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", nothing) == "true", mathengine=MathJax3()
    ),
    doctest=false,
    pages=["index.md"],
    checkdocs=:exports,
)

deploydocs(; devbranch="main", repo="github.com/gustaphe/UnitfulLatexify.jl.git", 
    versions=["dev" => "2.0", "1.7", "1.4"])
