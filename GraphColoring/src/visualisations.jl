using LightGraphs
using GraphPlot
using Colors

function plotcoloredgraph(graph, assignments, k)
    colors = distinguishable_colors(
        k, 
        [RGB(1,1,1), RGB(0,0,0)], 
        lchoices=[75],
        dropseed=true
    )

    gplot(graph, nodefillc=[ colors[k] for k in assignments])
end
