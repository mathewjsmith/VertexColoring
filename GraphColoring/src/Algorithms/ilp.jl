using JuMP
using Cbc
using LightGraphs

include("preprocess.jl")

"""
Finds a minimal graph coloring via an Integer Linear Program. `h` is an upper bound on the number of colors. It can be calculated by a heuristic and passed in as a paramater, else it will be set to |V|.
"""
function color_graph_ilp(graph; h=nothing, do_preprocess=false, timelimit=nothing)
    if do_preprocess
        reduced_graph, mapping = preprocess(graph)
        original_graph = graph
        graph = reduced_graph
    end

    n = nv(graph)

    if isnothing(h)
        h = n
    end

    model = Model(Cbc.Optimizer)

    # color variables.
    @variable(model, 0 <= colors[1:h] <= 1, Int)

    # variables for each vertex/color pair.
    @variable(model, 0 <= vertices[1:n, 1:h] <= 1, Int) 

    # minimise the number of colors.
    @objective(model, Min, sum(colors))

    # each vertex should have just 1 color assigned.
    @constraint(
        model, 
        [v in 1:n],
        sum(vertices[v, :]) == 1
    )

    # adjacent edges should not have the same color assigned.
    @constraint(
        model,
        [e in edges(graph), c in 1:h],
        vertices[src(e), c] + vertices[dst(e), c] <= colors[c]
    )

    # colors assigned to a vertex must have their variables assigned.
    @constraint(
        model,
        [v in 1:n, c in 1:h],
        vertices[v, c] <= colors[c] 
    )

    set_optimizer_attribute(model, "threads", 1)

    if !isnothing(timelimit)
        set_optimizer_attribute(model, "seconds", timelimit)
    end

    optimize!(model)

    if termination_status(model) == MOI.OPTIMAL
        assignments = read_assignments(vertices, colors, n, h)

        if do_preprocess
            try
                # map excluded vertices to their colorings.
                assignments = postprocess(original_graph, assignments, mapping)
                return objective_value(model), nv(reduced_graph), assignments
            catch e
                return nothing
            end
        elseif !isnothing(assignments)
            return objective_value(model), assignments
        end
    end

    nothing
end


"""
From a solved model, derives the color assignments in the form of an array of the indices of the assigned colors for each vertex.
"""
function read_assignments(vertices, colors, n, h)
    ncolors = 1
    assigned_colors = Dict()

    for (i, color) in enumerate(colors)
        c = value(color)
        if c == 1
            assigned_colors[i] = ncolors
            ncolors += 1
        end
    end

    vertex_assignments = []
    for v in 1:n
        for (i, color) in enumerate(vertices[v, :])
            c = value(color)
            if c == 1
                push!(vertex_assignments, assigned_colors[i])
            end
        end
    end

    vertex_assignments
end
