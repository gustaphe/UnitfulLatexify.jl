@latexrecipe function f(a::AbstractArray{<:AbstractQuantity{N,D,U}};unitformat=:mathrm) where {N<:Number,D,U}
    # Array of quantities with the same unit
    env --> :equation
    return LaTeXString(join(
                            (
                             latexarray((ustrip.(a).*u"one");kwargs...,unitformat),
                             latexify(unit(first(a));kwargs...,unitformat,env=:raw)
                            ),"\\;"
                           ))
end

@latexrecipe function f(r::AbstractRange{<:AbstractQuantity{N,D,U}};unitformat=:mathrm) where {N<:Number,D,U}
    if unitformat == :siunitx
        return LaTeXString(join((
                                 "\\SIrange{",
                                 latexify(r.start.val;kwargs...,env=:raw),
                                 "}{",
                                 latexify(r.stop.val;kwargs...,env=:raw),
                                 "}{",
                                 latexify.(listunits(unit(r.start));kwargs...,unitformat,env=:raw)...,
                                 "}",
                                ))
                          )
    end
    if unitformat == :siunitxsimple
        return LaTeXString(join((
                                 "\\SIrange{",
                                 latexify(r.start.val;kwargs...,env=:raw),
                                 "}{",
                                 latexify(r.stop.val;kwargs...,env=:raw),
                                 "}{",
                                 join(
                                      latexify.(listunits(unit(r.start));kwargs...,unitformat,env=:raw),
                                      "."
                                     ),
                                 "}",
                                ))
                          )
    end
    return LaTeXString(join(
                            (latexarray((ustrip.(r).*u"one");kwargs...,unitformat,env=:raw),
                             latexify(unit(r.start);kwargs...,unitformat,env=:raw)
                            ),"\\;"
                           ))
end

@latexrecipe function f(r::T;unitformat=:mathrm) where T <: AbstractRange{<:AbstractQuantity{N,D,U}} where {N<:Number,D,U<:Units{(Unit{:One,NoDims}(0,1),),NoDims,nothing}}
    if unitformat == :siunitx || unitformat == :siunitxsimple
        return LaTeXString(join((
                                 "\\numrange{",
                                 latexify(r.start.val;kwargs...,env=:raw),
                                 "}{",
                                 latexify(r.stop.val;kwargs...,env=:raw),
                                 "}"
                                ))
                          )
    end
    return latexarray((ustrip.(r)))
end


@latexrecipe function f(l::Tuple{T,Vararg{T}};unitformat=:mathrm) where T <: AbstractQuantity{N,D,U} where {N<:Number,D,U}
    if unitformat == :siunitx
        return LaTeXString(join(
                                (
                                 "\\SIlist{",
                                 join(latexify.(ustrip.(l);kwargs...,unitformat,env=:raw),";"),
                                 "}{",
                                 latexify.(listunits(unit(first(l)));kwargs...,unitformat,env=:raw)...,
                                 "}",
                                )
                               ))

    end
    if unitformat == :siunitxsimple
        return LaTeXString(join(
                                (
                                 "\\SIlist{",
                                 join(latexify.(ustrip.(l);kwargs...,unitformat,env=:raw),";"),
                                 "}{",
                                 join(latexify.(listunits(unit(first(l)));kwargs...,unitformat,env=:raw),"."),
                                 "}",
                                )
                               ))
    end
    return [l...]
end

@latexrecipe function f(l::Tuple{T,Vararg{T}};unitformat=:mathrm) where T <: AbstractQuantity{N,D,U} where {N<:Number,D,U<:Units{(Unit{:One,NoDims}(0,1),),NoDims,nothing}}
    if unitformat == :siunitx || unitformat == :siunitxsimple
        return LaTeXString(join(
                                (
                                 "\\numlist{",
                                 join(latexify.(ustrip.(l);kwargs...,unitformat,env=:raw),";"),
                                 "}"
                                )
                               ))
    end
    return [ustrip.(l)...]
end

