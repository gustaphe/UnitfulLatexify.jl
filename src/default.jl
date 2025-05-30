@latexrecipe function f(p::Unit)
    insert_deprecated_unitformat!(kwargs)

    fmt = get_formatter(kwargs)
    env --> get_format_env(fmt)
    return _transform(p, fmt)
end

@latexrecipe function f(u::Units; permode=:power)
    insert_deprecated_unitformat!(kwargs)
    fmt = get_formatter(kwargs)
    env --> get_format_env(fmt)
    return _transform(u, fmt)
end

@latexrecipe function f(q::AbstractQuantity)
    insert_deprecated_unitformat!(kwargs)
    fmt = get_formatter(kwargs)
    env --> get_format_env(fmt)
    operation := :*

    return _transform(q, fmt)
end

struct NakedUnits
    u::Units
end
struct NakedNumber
    n::Number
end

@latexrecipe function f(u::NakedUnits; permode=:power)
    insert_deprecated_unitformat!(kwargs)
    fmt = get_formatter(kwargs)
    unitlist = listunits(u.u)
    if fmt isa SiunitxNumberFormatter
        fmt.simple && return Expr(:latexifymerge, intersperse(unitlist, ".")...)
        return Expr(:latexifymerge, unitlist...)
    end
    if permode === :power
        return Expr(:latexifymerge, intersperse(unitlist, "\\,")...)
    end

    numunits = [x for x in unitlist if power(x) >= 0]
    denunits = [typeof(x)(tens(x), -power(x)) for x in unitlist if power(x) < 0]

    numerator = intersperse(numunits, "\\,")
    if isempty(denunits)
        return Expr(:latexifymerge, numerator...)
    end
    if isempty(numunits)
        numerator = [1]
    end
    denominator = intersperse(denunits, "\\,")

    if permode === :slash
        return Expr(:latexifymerge, numerator..., "\\,/\\,", denominator...)
    end
    if permode === :frac
        return Expr(:latexifymerge, "\\frac{", numerator..., "}{", denominator..., "}")
    end
    return error("permode $permode undefined.")
end

@latexrecipe function f(n::NakedNumber)
    fmt = get_formatter(kwargs)
    if fmt isa SiunitxNumberFormatter
        fmt := PlainNumberFormatter()
    end
    return n.n
end

function _transform(p::Unit, fmt::SiunitxNumberFormatter)
    unitformat = fmt.simple ? :siunitxsimple : :siunitx
    prefix = prefixes[(unitformat, tens(p))]
    pow = power(p)
    unitname = getunitname(p, unitformat)
    if fmt.simple
        per = ""
        expo = pow == 1//1 ? "" : "^{$(latexify(pow; fmt="%g", env=:raw))}"
    else
        per = pow < 0 ? "\\per" : ""
        pow = abs(pow)
        expo = pow == 1//1 ? "" : "\\tothe{$(latexify(pow; fmt="%g", env=:raw))}"
    end
    return LaTeXString("$per$prefix$unitname$expo")
end
function _transform(p::Unit, fmt::AbstractNumberFormatter)
    prefix = prefixes[(:mathrm, tens(p))]
    unitname = getunitname(p, :mathrm)
    pow = power(p)
    expo = pow == 1//1 ? "" : "^{$(latexify(pow; fmt="%g", env=:raw))}"
    return LaTeXString("\\mathrm{$prefix$unitname}$expo")
end

function _transform(u::Units, fmt::SiunitxNumberFormatter)
    opening = fmt.version < 3 ? "\\si{" : "\\unit{"
    return Expr(:latexifymerge, opening, NakedUnits(u), "}")
end
_transform(u::Units, ::AbstractNumberFormatter) = Expr(:latexifymerge, NakedUnits(u))

function _transform(q::AbstractQuantity, fmt::SiunitxNumberFormatter)
    opening = fmt.version < 3 ? "\\SI{" : "\\qty{"
    return Expr(:latexifymerge, opening, NakedNumber(q.val), "}{", NakedUnits(unit(q)), "}")
end
function _transform(q::AbstractQuantity, ::AbstractNumberFormatter)
    Expr(
        :latexifymerge,
        NakedNumber(q.val),
        has_unit_spacing(unit(q)) ? "\\;" : nothing,
        NakedUnits(unit(q)),
    )
end
_transform(n::NakedNumber, ::SiunitxNumberFormatter) = PlainNumberFormatter(n.n)

function insert_deprecated_unitformat!(kwargs)
    unitformat = pop!(kwargs, :unitformat, nothing)
    siunitxlegacy = pop!(kwargs, :siunitxlegacy, nothing)
    if ~isnothing(unitformat)
        Base.depwarn(
            "`unitformat` kwarg is deprecated, use e.g. `fmt=SiunitxNumberFormatter()` instead",
            :latexify,
        )
        if unitformat === :mathrm
            kwargs[:fmt] = FancyNumberFormatter()
        end
        if unitformat === :siunitx
            kwargs[:fmt] = SiunitxNumberFormatter()
        end
    end
    if ~isnothing(siunitxlegacy)
        Base.depwarn(
            "`siunitxlegacy` kwarg is deprecated, use SiunitxNumberFormatter(version=2)` instead",
            :latexify,
        )
        fmt = get_formatter(kwargs)
        if fmt isa SiunitxNumberFormatter
            kwargs[:fmt] = SiunitxNumberFormatter(fmt.format_options, siunitxlegacy ? 2 : 3)
        end
    end
end

function get_formatter(kwargs)
    fmt = get(kwargs, :fmt, FancyNumberFormatter())
    if fmt isa String
        fmt = StyledNumberFormatter(fmt)
    end
    return fmt
end
get_format_env(fmt::SiunitxNumberFormatter) = :raw
get_format_env(fmt) = :inline
