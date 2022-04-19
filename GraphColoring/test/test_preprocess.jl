using Test
using LightGraphs

using GraphColoring
using GraphColoring.Algorithms

@testset "Pre-Processing" begin
    
    g = SimpleGraph(4)
    add_edge!(g, 1, 2)
    add_edge!(g, 1, 3)
    add_edge!(g, 4, 3)

    """
    The generated graph looks like the following
    (1)---(2)
     |
    (3)---(4)
    The neighborhood of 4 is a subset of the neighborhood of 1, therefore 1 should dominate 4. Likewise, 3 should dominate 2.
    """
    dominated = dominated_vertices(g)

    @test dominated[4] == 1
    @test dominated[2] == 3

    reduced_g, mapping = preprocess(g)

    # the dominated vertices should be removed from the processed graph.
    @test nv(reduced_g) == 2
    
    k, assignments = color_graph_ilp(reduced_g)
    complete_assignments = postprocess(g, assignments, mapping)

    # the resulting assignments should be valid and optimal.
    @test k == 2
    @test verify_coloring(g, complete_assignments)

end
