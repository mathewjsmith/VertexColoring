module Benchmarks

export benchmark_dsatur, benchmark_ilp, benchmark_ilp_preprocessed, benchmark_splitcolor, G, generate_graphs, generate_graphs2

using GraphColoring
using GraphColoring.Algorithms

using LightGraphs
using BenchmarkTools
using DelimitedFiles
using Random
using Distributions
using Glob


const seed = 7


function benchmark_dsatur(timelimit)
    graphs = [ (name[11:end-2], readgraph(name)) for name in glob("instances/expdeg_*_72_*") ]

    # first do an untimed run on a small instance to ensure the function is pre-compiled.
    color_graph_dsatur(graphs[1][2])

    results = [
        begin
            task = @async result = @timed color_graph_dsatur(graph)

            seconds = 0
            for s in 1:timelimit
                if istaskdone(task)
                    seconds = s
                    break
                end

                sleep(1)
            end

            avg_degree = mean([ degree(graph, v) for v in vertices(graph) ])

            if seconds < timelimit
                result = [ name nv(graph) ne(graph) avg_degree Δ(graph) task.result.value[1] task.result.time false ]
            else
                result = [ name nv(graph) ne(graph) avg_degree Δ(graph) "" "" true ]
            end

            result
        end
        for (name, graph) in graphs
    ]

    open("benchmarks/dsatur_benchmarks.csv", "a") do file
        writedlm(file, results, ",")
    end
end


function benchmark_ilp(timelimit)
    graphs = [ (name[11:end-2], readgraph(name)) for name in glob("instances/expdeg_*_72_*") ]

    # first do an untimed run on a small instance to ensure the function is pre-compiled.
    color_graph_ilp(graphs[1][2]; timelimit=30)

    results = [
        begin
            result = @timed color_graph_ilp(graph; h = Δ(graph), timelimit = timelimit)

            avg_degree = mean([ degree(graph, v) for v in vertices(graph) ])

            if !isnothing(result.value)
                result = [ name nv(graph) ne(graph) avg_degree Δ(graph) result.value[1] result.time false ]
            else
                result = [ name nv(graph) ne(graph) avg_degree Δ(graph) "" "" true ]
            end

            result
        end
        for (name, graph) in graphs
    ]

    open("benchmarks/ilp_benchmarks_expdeg.csv", "a") do file
        writedlm(file, results, ",")
    end
end


function benchmark_ilp_preprocessed(timelimit)
    graphs = [ (name[11:end-2], readgraph(name)) for name in glob("instances/expdeg_12_72_*") ]

    # first do an untimed run on a small instance to ensure the function is pre-compiled.
    color_graph_ilp(graphs[1][2]; timelimit = 30, do_preprocess = true)

    for (name, graph) in graphs
        h, _ = color_graph_dsatur(graph)
        result = @timed color_graph_ilp(graph; h = h, timelimit = timelimit, do_preprocess = true)

        avg_degree = mean([ degree(graph, v) for v in vertices(graph) ])

        if !isnothing(result.value)
            result = [ name nv(graph) result.value[2] ne(graph) avg_degree Δ(graph) result.value[1] result.time false ]
        else
            result = [ name nv(graph) "" ne(graph) avg_degree Δ(graph) "" "" true ]
        end

        open("benchmarks/ilp_benchmarks_expdeg_preprocessed.csv", "a") do file
            writedlm(file, result, ",")
        end
    end
end


function benchmark_splitcolor(p, timelimit)
    graphs = [ (name[11:end-2], readgraph(name)) for name in glob("instances/expdeg_*") ]

    # first do an untimed run on a small instance to ensure the function is pre-compiled.
    color_graph_splitcolor(graphs[1][2], 2, timelimit=30)

    for (name, graph) in graphs, q in [2, 4, 8]
        result = @timed color_graph_splitcolor(graph, q, p; timelimit=timelimit)

        avg_degree = mean([ degree(graph, v) for v in vertices(graph) ])

        if !isnothing(result.value)
            result = [ name nv(graph) ne(graph) avg_degree Δ(graph) p q result.value[1] result.time false ]
        else
            result = [ name nv(graph) ne(graph) avg_degree Δ(graph) p q "" "" true ]
        end

        open("benchmarks/splitcolor_benchmarks_p$p.csv", "a") do file
            writedlm(file, result, ",")
        end
    end
end


"""
Creates a random graph using the G(n, p) model: the created graph has `n` nodes and each possible dyad has probability `p` of being included.
"""
G(n, p; seed = -1) = expected_degree_graph(fill(sqrt(p) * ((n * p) / 2), n), seed=seed)


"""
Creates sets of random graphs for benchmarking using the expected degree model. Each set is characterised by vertex count and expected degree.
"""
function generate_graphs2()
    Random.seed!(7)

    # create a normal distribution with μ = 3 and σ = 1.5
    dist = Normal(3, 1.5) 
    for i in 0:9
        # create a graph where the expected degree for each node is drawn from the given distribution.
        ω = [ max(x, 1) for x in rand(dist, 36) ]
        graph = expected_degree_graph(ω)
        writegraph(graph, "instances/expdeg_3_36_$i")
    end

    # create a normal distribution with μ = 6 and σ = 3
    dist = Normal(6, 3) 
    for i in 0:9
        # create a graph where the expected degree for each node is drawn from the given distribution.
        ω = [ max(x, 1) for x in rand(dist, 36) ]
        graph = expected_degree_graph(ω)
        writegraph(graph, "instances/expdeg_6_36_$i")
    end

    # create a normal distribution with μ = 12 and σ = 6
    dist = Normal(12, 6) 
    for i in 0:9
        # create a graph where the expected degree for each node is drawn from the given distribution.
        ω = [ max(x, 1) for x in rand(dist, 36) ]
        graph = expected_degree_graph(ω)
        writegraph(graph, "instances/expdeg_12_36_$i")
    end

    # create a normal distribution with μ = 6 and σ = 3
    dist = Normal(6, 3) 
    for i in 0:9
        # create a graph where the expected degree for each node is drawn from the given distribution.
        ω = [ max(x, 1) for x in rand(dist, 72) ]
        graph = expected_degree_graph(ω)
        writegraph(graph, "instances/expdeg_6_72_$i")
    end

    # create a normal distribution with μ = 6 and σ = 3
    dist = Normal(12, 6) 
    for i in 0:9
        # create a graph where the expected degree for each node is drawn from the given distribution.
        ω = [ max(x, 1) for x in rand(dist, 72) ]
        graph = expected_degree_graph(ω)
        writegraph(graph, "instances/expdeg_12_72_$i")
    end

    # create a normal distribution with μ = 24 and σ = 12
    dist = Normal(24, 12) 
    for i in 0:9
        # create a graph where the expected degree for each node is drawn from the given distribution.
        ω = [ max(x, 1) for x in rand(dist, 72) ]
        graph = expected_degree_graph(ω)
        writegraph(graph, "instances/expdeg_24_72_$i")
    end

end


end
