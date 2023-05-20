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
        (:siunitxsimple, :Degree) => "\\degree",
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
        (:mathrm, :DoubleTurn) => "\\S",
        (:mathrm, :Turn) => "\\tau",
        (:mathrm, :HalfTurn) => "\\pi",
        (:mathrm, :Quadrant) => "\\frac{\\pi}{2}",
        (:mathrm, :Sextant) => "\\frac{\\pi}{3}",
        (:mathrm, :Octant) => "\\frac{\\pi}{4}",
        (:mathrm, :ClockPosition) => "\\frac{\\pi}{12}",
        (:mathrm, :HourAngle) => "\\frac{\\pi}{24}",
        (:mathrm, :CompassPoint) => "\\frac{\\pi}{32}",
        (:mathrm, :Hexacontade) => "\\frac{\\pi}{60}",
        (:mathrm, :BinaryRadian) => "\\frac{\\pi}{256}",
        (:mathrm, :DiameterPart) => "\\oslash", # This is slightly wrong
        (:mathrm, :Gradian) => "^g",
        (:mathrm, :Arcminute) => "'",
        (:mathrm, :Arcsecond) => "''",
        (:mathrm, :ArcsecondShort) => "''",
    )
end
