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
        (:mathrm, :Celsius) => "^\\circ C",
        (:siunitx, :Celsius) => "\\celsius",
        (:siunitxsimple, :Celsius) => "\\celsius",
        (:mathrm, :Fahrenheit) => "^\\circ F",
        (:siunitx, :Fahrenheit) => "\\fahrenheit",
        (:siunitxsimple, :Fahrenheit) => "\\fahrenheit",
        (:siunitxsimple, :Angstrom) => "\\angstrom",
        (:mathrm, :Angstrom) => "\\AA",
    )
end
