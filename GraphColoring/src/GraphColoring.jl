module GraphColoring

export readgraph, writegraph, plotcoloredgraph

using Revise
using Distributed 

include("Algorithms/Algorithms.jl")
include("Benchmarks.jl")
include("io.jl")
include("visualisations.jl")

end
