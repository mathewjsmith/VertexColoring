using Test
using LightGraphs

using GraphColoring
using GraphColoring.Algorithms

@testset "SplitColor" begin
    
    @testset "Bipartite Graph" begin
        g = complete_bipartite_graph(5, 5)
        q = 2

        k, assignments = color_graph_splitcolor(g, q)
        
        # the resulting coloring should be withi a factor of q of the optimal.
        @test k <= q * 2
        @test verify_coloring(g, assignments)
    end

end