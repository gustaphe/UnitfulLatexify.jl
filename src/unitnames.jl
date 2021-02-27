""""
`unitnames`

Unit names generally follow a simple scheme, but there are exceptions, listed in this
dictionary: `(unitformat::Symbol, name::Symbol) => unitname::String`
"""
const unitnames = begin
    Dict(
         (:mathrm, :Percent) => "\\%",
         (:siunitxsimple, :Percent) => "\\%",
         (:mathrm, :Degree) => "^{\\circ}",
         (:siunitx, :eV) => "\\electronvolt",
         (:mathrm, :Ohm) => "\\Omega",
        )
end
