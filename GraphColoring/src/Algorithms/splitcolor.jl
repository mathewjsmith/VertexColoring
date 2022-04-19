using Distributed
using LightGraphs


"""
Finds a `q`-approximation of a minimum graph coloring by running an exact algorithm on `q` subgraphs then merging the results. The algorithm is parallelised; `p` specifies the number of cores to be used. `p` cores must be available, to ensure this start julia with `julia -p n` where `n >= p`.
"""
function color_graph_splitcolor(graph, q, p=1; timelimit=nothing)
    if (nworkers() < p)
        throw(ErrorException("Number of available cores is less than the parallelisation parameter. To run with $p cores, start julia with julia -p $p."))
    end

    # choose p available threads.
    pids = workers()[end + 1 - p : end]

    # divide timelimit between subgraphs.
    if !isnothing(timelimit)
        timelimit = ceil(timelimit / max(q / p, 1))
    end

    # partition vertices into q subsets.
    partitions = collect(partition(1:nv(graph), q))

    solutions = [
        @spawnat pids[(i % p) + 1] begin
            subgraph = induced_subgraph(graph, part)[1]
            color_graph_ilp(subgraph; h = Δ(subgraph), timelimit = timelimit)
        end
        for (i, part) in enumerate(partitions)
    ]

    solutions = [ fetch(solution) for solution in solutions ]

    if any(solutions .== nothing)
        return nothing
    else
        return merge_solutions(solutions)
    end
end


"""
Partitions the array `x` into `q` subarrays. Subarrays will be of equal length if `length(x)` is divisible by `q`, otherwise length may vary by one element.
"""
function partition(x, q)
    n = length(x)
    subarrays = Dict([ (i, Array{Int, 1}()) for i in 1:q ])

    for i in 1:length(x)
        push!(subarrays[(i % q) + 1], i)
    end

    values(subarrays)
end


"""
Merges the colorings for each subgraph into a single coloring by iteratively appending each set of color assignments and incrementing the color indices by the number of colors used for previous subgraphs.
"""
function merge_solutions(solutions)
    assignments = []
    k = 0
    for s in solutions
        append!(assignments, s[2] .+ Int(k))
        k += s[1]
    end
    k, assignments
end
