using LightGraphs


"""
Reduces the size of a graph prior to coloring by searching for dominating vertices. A vertex v dominates u if the neighborhood of u is a subset of v's. A dominated vertex can be removed from the graph, then assigned the color of its dominator.
"""
function preprocess(graph)
    dominated = dominated_vertices(graph)

    reduced_graph = deepcopy(graph)
    rem_vertices!(reduced_graph, collect(keys(dominated)))

    remaining_vertices = [ v for v in vertices(graph) if !(v in keys(dominated)) ]

    mapping = [
        if v in remaining_vertices
            findfirst(remaining_vertices .== v)
        else
            findfirst(remaining_vertices .== dominated[v])
        end
        for v in vertices(graph)
    ]

    reduced_graph, mapping
end


"""
Given the color assignments of a preprocessed graph and the mapping defined in preprocessing, assigns the appropriate colors to vertices that were removed from the graph.
"""
function postprocess(graph, assignments, mapping)
    [ assignments[mapping[v]] for v in vertices(graph) ]
end


"""
Searches for dominated vertices. Returns a dictionary with dominated vertices as keys, and their dominators as values.
"""
function dominated_vertices(graph)
    dominated = Dict{Int, Int}()

    for v in vertices(graph), u in vertices(graph)
        if ispropersubset(neighbors(graph, v), neighbors(graph, u))
            # if u's neighborhood is a superset of v's, u dominates v.
            dominated[v] = u
            # if v dominated any vertices, u takes over as the dominator.
            for (a, b) in dominated
                if b == v
                    dominated[a] == u
                end
            end
        end
    end

    dominated
end

ispropersubset(s, t) = issubset(s, t) & (length(s) < length(t))