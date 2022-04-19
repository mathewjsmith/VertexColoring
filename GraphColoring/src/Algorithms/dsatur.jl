using LightGraphs, MetaGraphs
using DataStructures


"""
Finds a graph coloring using the DSatur heuristic.
"""
function color_graph_dsatur(graph)
    n = nv(graph)
    graph = MetaGraph(graph)

    queue = PriorityQueue{Int, Int}(Base.Order.Reverse)

    for v in 1:n
        queue[v] = 0
        set_prop!(graph, v, :adjacent_colors, Set())
    end

    while !isempty(queue)
        v = dequeue!(queue)
        color = first_available_color(graph, v)
        set_prop!(graph, v, :color, color)

        for w in neighbors(graph, v)
            if haskey(queue, w)
                update_saturation_degree!(graph, queue, w, color)
            end
        end
    end

    assignments = [ get_prop(graph, v, :color) for v in 1:n ]
    k = maximum(assignments)

    k, assignments
end


""" 
The saturation degree of a vertex is the number of unique colors the vertex is adjacent to.
"""
function saturation_degree(graph, v)
    length(Set([
        get_prop(graph, w, :color) 
        for w in neighbours(v) 
        if has_prop(graph, w, :color)
    ]))
end


"""
Returns the color with the lowest index that `v` is not adjacent to.
"""
function first_available_color(graph, v)
    colorset = Set([ 
        get_prop(graph, w, :color) 
        for w in neighbors(graph, v) 
        if has_prop(graph, w, :color)
    ])

    color = 1

    while true
        if !(color in colorset)
            return color
        end
        color += 1
    end
end


"""
Adds `color` to the adjacent color set of `v`, and updates the priority of `v` in the queue accordingly. To be called upon coloring a vertex adjacent to `v`.
"""
function update_saturation_degree!(graph, queue, v, color)
    adjacent_colors = union(color, get_prop(graph, v, :adjacent_colors))
    set_prop!(graph, v, :adjacent_colors, adjacent_colors)
    queue[v] = length(adjacent_colors)
end
