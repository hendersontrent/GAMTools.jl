"""
    PlotSmooth(Model; smooth_index)
Plot a smooth.
Usage:
```julia-repl
PlotSmooth(Model; smooth_index)
```
Arguments:
- `Model` : `GAMModel` containing the fitted GAM.
- `smooth_index` : `Int64` denoting the index of the smooth in `Model.covariateFits` to plot. Defaults to `2` as `1` is the Intercept.
"""

function PlotSmooth(Model::GAMModel; smooth_index::Int64=2, kwargs...)

    # Check that the smooth_index is a smooth and not a discrete covariate

    if typeof(Model.covariateFits[smooth_index]) == SmoothData
        p = scatter(Model.data[!, Model.covariateFits[smooth_index].variable], Model.data[!, Model.y_var], label = "Data", color = :black; kwargs...)
        xlabel!(String(Model.covariateFits[smooth_index].variable))
        ylabel!(String(Model.y_var))
        plot!(Model.data[!, Model.covariateFits[smooth_index].variable], Model.covariateFits[smooth_index].Spline_opt_lower.(Model.data[!, Model.covariateFits[smooth_index].variable]) .+ Model.covariateFits[1].β_opt, fillrange = Model.covariateFits[smooth_index].Spline_opt_upper.(Model.data[!, Model.covariateFits[smooth_index].variable]) .+ Model.covariateFits[1].β_opt, fillalpha = 0.2, pointalpha = 0.0, color = :grey, label = "CI")
        plot!(Model.data[!, Model.covariateFits[smooth_index].variable], Model.covariateFits[smooth_index].Spline_opt.(Model.data[!, Model.covariateFits[smooth_index].variable]) .+ Model.covariateFits[1].β_opt, color = :grey, linewidth = 2, label = "Optimal λ = $(round(Model.covariateFits[smooth_index].λ_opt,digits=3))")
        return p 
    else
        error("Specified smooth_index is not a smooth.")
    end
end
