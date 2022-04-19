using Test
using LightGraphs

using GraphColoring
using GraphColoring.Algorithms

@testset "ILP" begin

    @testset "Bipartite Graph" begin
        g = complete_bipartite_graph(5, 5)

        k, assignments = color_graph_dsatur(g)
        
        # Solution should be optimal and valid
        @test k == 2 
        @test verify_coloring(g, assignments)
    end

    @testset "Complete Graph" begin
        g = complete_graph(10)

        k, assignments = color_graph_dsatur(g)

        # Solution should be optimal and valid
        @test k == 10
        @test verify_coloring(g, assignments)
    end

    @testset "Edgeless" begin
        g = SimpleGraph(10)

        k, assignments = color_graph_dsatur(g)

        # Solution should be optimal and valid
        @test k == 1
        @test verify_coloring(g, assignments)
    end
    
end