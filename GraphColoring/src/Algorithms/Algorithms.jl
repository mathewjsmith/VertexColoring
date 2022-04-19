module Algorithms

export color_graph_dsatur, color_graph_ilp, color_graph_splitcolor, verify_coloring, preprocess, postprocess, dominated_vertices

include("dsatur.jl")
include("ilp.jl")
include("splitcolor.jl")
include("preprocess.jl")


"""
Checks if the given coloring is valid. Returns false if any adjacent vertices are assigned the same color.
"""
function verify_coloring(graph, assignments)
    for (v, c) in enumerate(assignments)
        for w in neighbors(graph, v)
            if assignments[w] == c
                false
            end
        end
    end

    true
end

end
