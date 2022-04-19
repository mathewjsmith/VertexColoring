using LightGraphs

function readgraph(filename)
    graph = nothing

    open(filename) do file
        n = 0
        edges = []

        for line in split.(readlines(file))
            if line[1] == "n"
                n = parse(Int64, line[2])
            elseif line[1] == "e"
                push!(edges, Edge(parse(Int64, line[2]), parse(Int64, line[3])))
            end
        end

        graph = SimpleGraph(n)

        for edge in edges
            add_edge!(graph, edge)
        end
    end

    graph
end

function writegraph(graph, filename)
    open(filename, "w") do file
        println(file, "n $(nv(graph))")

        for edge in edges(graph)
            println(file, "e $(src(edge)) $(dst(edge))")
        end
    end
end
