using Test
using LightGraphs

using GraphColoring
using GraphColoring.Algorithms

@testset "DSatur" begin
    
    @testset "Bipartite Graph" begin
        g = complete_bipartite_graph(5, 5)

        k, assignments = color_graph_dsatur(g)
        
        # DSatur should produce an optimal coloring for bipartite graphs.
        @test k == 2 

        @test verify_coloring(g, assignments)
    end

    @testset "Complete Graph" begin
        g = complete_graph(10)

        k, assignments = color_graph_dsatur(g)

        # in the case of a complete graph, it should not be possible to do worse than the optimal.
        @test k == 10
        @test verify_coloring(g, assignments)
    end

end
