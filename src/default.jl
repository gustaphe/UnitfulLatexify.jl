@latexrecipe function f(p::Unit)
    insert_deprecated_unitformat!(kwargs)

    fmt = get_formatter(kwargs)
    env --> get_format_env(fmt)
    return fmt(p)
end

@latexrecipe function f(u::Units; permode=:power)
    insert_deprecated_unitformat!(kwargs)
    fmt = get_formatter(kwargs)
    env --> get_format_env(fmt)
    return fmt(u)
end

@latexrecipe function f(q::AbstractQuantity)
    insert_deprecated_unitformat!(kwargs)
    fmt = get_formatter(kwargs)
    env --> get_format_env(fmt)
    operation := :*

    return fmt(q)
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

function(fmt::SiunitxNumberFormatter)(u::Unit)
    prefix = prefixes[(:siunitx, tens(u))]
    pow = power(u)
    unitname = getunitname(u, :siunitx)
    per = pow < 0 ? "\\per" : ""
    pow = abs(pow)
    expo = pow == 1//1 ? "" : "\\tothe{$(latexify(pow; fmt="%g", env=:raw))}"
    return LaTeXString("$per$prefix$unitname$expo")
end
function (fmt::AbstractNumberFormatter)(u::Unit)
    prefix = prefixes[(:mathrm, tens(u))]
    unitname = getunitname(u, :mathrm)
    pow = power(u)
    expo = pow == 1//1 ? "" : "^{$(latexify(pow; fmt="%g", env=:raw))}"
    return LaTeXString("\\mathrm{$prefix$unitname}$expo")
end

get_format_env(fmt::SiunitxNumberFormatter) = :raw
get_format_env(fmt) = :inline

function (fmt::SiunitxNumberFormatter)(u::Units)
    opening = fmt.version < 3 ? "\\si{" : "\\unit{"
    return Expr(:latexifymerge, opening, NakedUnits(u), "}")
end
(::AbstractNumberFormatter)(u::Units) = Expr(:latexifymerge, NakedUnits(u))

function (fmt::SiunitxNumberFormatter)(q::AbstractQuantity)
    opening = fmt.version < 3 ? "\\SI{" : "\\qty{"
    return Expr(:latexifymerge, opening, NakedNumber(q.val), "}{", NakedUnits(unit(q)), "}")
end
function (::AbstractNumberFormatter)(q::AbstractQuantity)
    Expr(
         :latexifymerge,
         NakedNumber(q.val),
         has_unit_spacing(unit(q)) ? "\\;" : nothing,
         NakedUnits(unit(q)),
        )
end
(::SiunitxNumberFormatter)(n::NakedNumber) = PlainNumberFormatter(n.n)


function insert_deprecated_unitformat!(kwargs)
    unitformat = pop!(kwargs, :unitformat, nothing)
    siunitxlegacy = pop!(kwargs, :siunitxlegacy, nothing)
    if ~isnothing(unitformat)
        Base.depwarn("`unitformat` kwarg is deprecated, use e.g. `fmt=SiunitxNumberFormatter()` instead", :latexify)
        if unitformat === :mathrm
            kwargs[:fmt] = FancyNumberFormatter()
        end
        if unitformat === :siunitx
            kwargs[:fmt] = SiunitxNumberFormatter()
        end
    end
    if ~isnothing(siunitxlegacy)
        Base.depwarn("`siunitxlegacy` kwarg is deprecated, use SiunitxNumberFormatter(version=1)` instead", :latexify)
        fmt = get_formatter(kwargs)
        if fmt isa SiunitxNumberFormatter
            kwargs[:fmt] = SiunitxNumberFormatter(fmt.format_options, siunitxlegacy ? 1 : 3)
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
