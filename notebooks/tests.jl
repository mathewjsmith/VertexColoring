### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 7bfd5128-7e92-11eb-2fca-ed0708191399
begin
	using Revise
	using GraphColoring
	import GraphColoring.ILP
	import GraphColoring.DSatur
	import GraphColoring.Splitting
	using LightGraphs
	using GraphPlot
	using Colors
	using JuMP
	using Cbc
	using Glob
	using Distributed
end

# ╔═╡ 026060dc-7f71-11eb-152f-21f7f401b117
begin
	n = 80
	m = Int(ceil((n - 1)^2 / 4))
	graph = SimpleGraph(n, m, seed=-1)
end

# ╔═╡ 8139b23a-7f4b-11eb-396b-690837ddeb9b
k_dsatur, assignment_dsatur = DSatur.color_graph_dsatur(graph)

# ╔═╡ 68631e0a-8035-11eb-1bdd-13c0babc30a7
verify_coloring(graph, assignment_dsatur)

# ╔═╡ 2446f7c6-7f79-11eb-19ea-730f297135f7
plotcoloredgraph(graph, assignment_dsatur, Int(k_dsatur))

# ╔═╡ 7d0735d4-7f78-11eb-3410-4debfa22508b
# k_ilp, assignment_ilp = ILP.color_graph_ilp(graph, h=k_dsatur)

# ╔═╡ 72246e30-8035-11eb-186a-33462a732660
# verify_coloring(graph, assignment_ilp)

# ╔═╡ b85cbbe2-7f53-11eb-1d39-4110affa8232
# plotcoloredgraph(graph, assignment_ilp, Int(k_ilp))

# ╔═╡ 2e5c6c74-8054-11eb-247a-ddf3c19f1957
k_split1, assignment_split1 = Splitting.color_graph_splitting(graph, 4, p=1)

# ╔═╡ 939e7a10-801c-11eb-0150-3d8b70feddc1
k_split8, assignment_split8 = Splitting.color_graph_splitting(graph, 8, p=1)

# ╔═╡ 0a35258c-8024-11eb-2d94-5f9b89e87850
plotcoloredgraph(graph, assignment_split8, Int(k_split8))

# ╔═╡ b769989e-8030-11eb-3c55-2b80332ed628
verify_coloring(graph, assignment_split8)

# ╔═╡ Cell order:
# ╠═7bfd5128-7e92-11eb-2fca-ed0708191399
# ╠═026060dc-7f71-11eb-152f-21f7f401b117
# ╠═8139b23a-7f4b-11eb-396b-690837ddeb9b
# ╠═68631e0a-8035-11eb-1bdd-13c0babc30a7
# ╠═2446f7c6-7f79-11eb-19ea-730f297135f7
# ╠═7d0735d4-7f78-11eb-3410-4debfa22508b
# ╠═72246e30-8035-11eb-186a-33462a732660
# ╠═b85cbbe2-7f53-11eb-1d39-4110affa8232
# ╠═2e5c6c74-8054-11eb-247a-ddf3c19f1957
# ╠═939e7a10-801c-11eb-0150-3d8b70feddc1
# ╠═0a35258c-8024-11eb-2d94-5f9b89e87850
# ╠═b769989e-8030-11eb-3c55-2b80332ed628
