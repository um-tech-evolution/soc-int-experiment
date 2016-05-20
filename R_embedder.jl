using RCall
R"library(poweRlaw)"

function power_law_estimates(data_vector, threshold_vector)
    R"m_pl =displ$new($data_vector)"
    xmin = rcopy(R"estimate_xmin(m_pl)")[:gof]
    R"
        threshold_array = $threshold_vector
        est_scan = 0*threshold_array
        for(i in seq_along(threshold_array)){
            m_pl$setXmin(threshold_array[i])
            est_scan[i] = estimate_pars(m_pl)$pars
        }
    "
    alpha_vals = rcopy(R"est_scan")
    vals = Dict(
                "xmin" => xmin,
                "alpha_vector" => alpha_vals
                )
    return vals
end

function test_driver()
    answer = power_law_estimates(1:50:1000,1:100)
    #answer = power_law_estimates([1,2,3,4,5],[1,2,3])
end
