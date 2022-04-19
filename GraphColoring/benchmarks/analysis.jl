### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 0af4ed68-84fc-11eb-0259-17da5e613364
begin
	using CSV
	using DataFrames
	using Statistics
	using Plots
	using StatsPlots
	using Colors
	using CategoricalArrays
	using GraphColoring
	using Glob
	using LightGraphs
	using GLM
end

# ╔═╡ 093b1826-84ff-11eb-0777-6597897ac3d6
begin
	dsatur_results = CSV.File("dsatur_benchmarks.csv") |> DataFrame
	dsatur_groups = combine(
		groupby(dsatur_results, [:n, :exp_deg]),
		:n => mean,
		:m => mean,
		:max_deg => mean => :max_deg,
		:colors => mean ∘ skipmissing => :colors, 
		:time => mean ∘ skipmissing => :time,
		:failed => sum => :nfailed,
	)
	sort!(dsatur_groups, [:n, :exp_deg])
end

# ╔═╡ dc776b04-867d-11eb-231a-df97309b4381
begin
	ilp_results = CSV.File("ilp_benchmarks_expdeg.csv") |> DataFrame
	ilp_groups = combine(
		groupby(ilp_results, [:n, :exp_deg]),
		:n => mean,
		:m => mean,
		:max_deg => mean => :max_deg,
		:colors => mean ∘ skipmissing => :colors,
		:time => mean ∘ skipmissing => :time,
		:failed => sum => :nfailed
	)
	sort!(ilp_groups, [:n, :exp_deg])
end

# ╔═╡ db85711e-867d-11eb-276b-47a13568627b
begin
	split_results = CSV.File("splitcolor_benchmarks_p1.csv.old") |> DataFrame
	split_groups = combine(
		groupby(split_results, [:n, :exp_deg, :q]),
		:n => mean,
		:m => mean,
		:max_deg => mean,
		:colors => mean ∘ skipmissing => :colors,
		:time => mean ∘ skipmissing => :time,
		:failed => sum => :nfailed
	)
	sort!(split_groups, [:n, :exp_deg])
end

# ╔═╡ ec757f30-867f-11eb-3a48-5dabaef22ec8
begin
	methods = repeat([
		"ILP",
		"DSatur",
		"SplitColor-2", 
		"SplitColor-4", 
		"SplitColor-8"
	], 6)
	
	graphsets = repeat([
		"(a) expdeg(3, 36)",
		"(b) expdeg(6, 36)",
		"(c) expdeg(12, 36)",
		"(d) expdeg(6, 72)",
		"(e) expdeg(12, 72)",
		"(f) expdeg(24, 72)",
	], inner = 5)
	
	colors = distinguishable_colors(
        5, 
        [RGB(1,1,1), RGB(0,0,0)], 
        lchoices=[66],
        dropseed=true
    )
end

# ╔═╡ 914cdec6-8686-11eb-3349-5519c1212578
begin
	experiment1_color_data = hcat( 
		ilp_groups.colors,
		dsatur_groups.colors,
		filter(:q => q -> q == 2, split_groups).colors,
		filter(:q => q -> q == 4, split_groups).colors,
		filter(:q => q -> q == 8, split_groups).colors
	)'
	
	exp1_colors_plot = groupedbar(graphsets, experiment1_color_data, groups = methods, 
		legend = :topleft, 
		color = colors',
		xrotation = 45,
		ylabel = "number of colors (mean)"
	)
end

# ╔═╡ a378c352-868c-11eb-2e7f-31c097a2fa63
savefig(exp1_colors_plot, "exp1_colors.pdf")

# ╔═╡ a7efc99a-868b-11eb-287d-e5e1cc9d1355
begin
	experiment1_time_data = hcat( 
		ilp_groups.time,
		dsatur_groups.time,
		filter(:q => q -> q == 2, split_groups).time,
		filter(:q => q -> q == 4, split_groups).time,
		filter(:q => q -> q == 8, split_groups).time
	)'
	
	exp1_time_plot = groupedbar(graphsets, experiment1_time_data, groups = methods, 
		legend = :topleft, 
		color = colors',
		xrotation = 45,
		ylabel = "runtime (seconds)",
	)
end

# ╔═╡ a8084918-868c-11eb-14b3-816139a336f6
savefig(exp1_time_plot, "exp1_time.pdf")

# ╔═╡ aa0d0800-873f-11eb-3eeb-bb001cd878bf
split_p1_groups = split_groups

# ╔═╡ a913f0c6-873f-11eb-27e7-4b343f927b7e
begin
	split_p2_results = CSV.File("splitcolor_benchmarks_p2.csv") |> DataFrame
	split_p2_groups = combine(
		groupby(split_results, [:n, :exp_deg, :q]),
		:n => mean,
		:m => mean,
		:max_deg => mean,
		:colors => mean ∘ skipmissing => :colors,
		:time => mean ∘ skipmissing => :time,
		:failed => sum => :nfailed
	)
	sort!(split_p2_groups, [:n, :exp_deg])
end

# ╔═╡ ce94bf3a-873f-11eb-0f2f-df63393c5e24
begin
	split_p4_results = CSV.File("splitcolor_benchmarks_p4.csv.old") |> DataFrame
	split_p4_groups = combine(
		groupby(split_p4_results, [:n, :exp_deg, :q]),
		:n => mean,
		:m => mean,
		:max_deg => mean,
		:colors => mean ∘ skipmissing => :colors,
		:time => mean ∘ skipmissing => :time,
		:failed => sum => :nfailed
	)
	sort!(split_p4_groups, [:n, :exp_deg])
end

# ╔═╡ ca4996f6-873f-11eb-00ce-019824bf7a52
begin
	split_p8_results = CSV.File("splitcolor_benchmarks_p8.csv.old") |> DataFrame
	split_p8_groups = combine(
		groupby(split_p8_results, [:n, :exp_deg, :q]),
		:n => mean,
		:m => mean,
		:max_deg => mean,
		:colors => mean ∘ skipmissing => :colors,
		:time => mean ∘ skipmissing => :time,
		:failed => sum => :nfailed
	)
	sort!(split_p8_groups, [:n, :exp_deg])
end

# ╔═╡ f4fca1c2-873f-11eb-0361-2f6041d3b585
begin
	methods2 = repeat([
		"SplitColor-8-1", 
		"SplitColor-8-2", 
		"SplitColor-8-4",
		"SplitColor-8-8",
	], 6)
	
	graphsets2 = repeat([
		"(a) expdeg(3, 36)",
		"(b) expdeg(6, 36)",
		"(c) expdeg(12, 36)",
		"(d) expdeg(6, 72)",
		"(e) expdeg(12, 72)",
		"(f) expdeg(24, 72)",
	], inner = 4)
	
	colors2 = distinguishable_colors(
        4, 
        [RGB(1,1,1), RGB(0,0,0)], 
        lchoices=[66],
        dropseed=true
    )
end

# ╔═╡ 019af4a8-8740-11eb-30e5-279ff26a2b8b
begin
	experiment2_time_data = hcat(
		dsatur_groups.time,
		filter(:q => q -> q == 4, split_p1_groups).time,
		filter(:q => q -> q == 4, split_p2_groups).time,
		filter(:q => q -> q == 4, split_p4_groups).time,
		filter(:q => q -> q == 4, split_p8_groups).time
	)'
	
	exp2_time_plot = groupedbar(graphsets2, experiment2_time_data, groups = methods2, 
		legend = :topleft, 
		color = colors',
		xrotation = 45,
		ylabel = "runtime (seconds)",
	)
end

# ╔═╡ 17a536a4-8762-11eb-2285-2dc4952a1038
savefig(exp2_time_plot, "splitcolor_par.pdf")

# ╔═╡ 861304ac-8750-11eb-1d61-5f66368893be
graphs = readgraph.(glob("../instances/expdeg_*_72_*"))

# ╔═╡ d2e0b856-8750-11eb-273f-01a361fd3a30
begin
	independent = filter(:n => n -> n == 72, ilp_results)
	
	df = [
		(
			density = ne(g) / (nv(g) * (nv(g) - 1) / 2),
			max_degree = Δ(g),
			max_clique = length(maximal_cliques(g)[1]),
			runtime = independent[i, :time],
			colors = independent[i, :colors],
			failed = independent[i, :failed]
		)
		for (i, g) in enumerate(graphs) if (nv(g) == 72)
	] |> DataFrame
	
	filter!(:failed => f -> !f, df)
	
	independent = filter(:failed => f -> !f, independent).time
	
	model_density = lm(@formula(runtime ~ density), df)
	model_max_degree = lm(@formula(runtime ~ max_degree), df)
	model_max_clique = lm(@formula(runtime ~ max_clique), df)
	model_colors = lm(@formula(runtime ~ colors), df)
	model_all = lm(@formula(runtime ~ density + max_degree + max_clique + colors), df)
end

# ╔═╡ bf58830e-8755-11eb-1251-9b22474c08c4
adjr2(model_density), adjr2(model_max_degree), adjr2(model_max_clique), adjr2(model_all), adjr2(model_colors)

# ╔═╡ 96737c1c-876b-11eb-1d9c-c314fa3870b4
begin
	ilpp_results = CSV.File("ilp_benchmarks_expdeg_preprocessed.csv") |> DataFrame
	ilpp_groups = combine(
		groupby(ilpp_results, [:n, :exp_deg]),
		:reduced_n => mean,
		:time => mean ∘ skipmissing => :time
	)
	sort!(ilpp_groups, [:n, :exp_deg])
end

# ╔═╡ dceb1fce-876b-11eb-1310-27f8bba9315e
begin
	methods3= repeat([
		"ILP", 
		"ILP-Preprocessed"
	], 2)
	
	graphsets3= repeat([
		"(a) expdeg(6, 72)",
		"(b) expdeg(12, 72)"
	], inner = 2)
	
	colors3= distinguishable_colors(
        2,
        [RGB(1,1,1), RGB(0,0,0)], 
        lchoices=[66],
        dropseed=true
    )
end

# ╔═╡ 0a559b10-876c-11eb-2336-0f106a45e095
begin
	experiment3_time_data = hcat(
		filter([:n, :exp_deg] => (n, e) -> (n == 72) & (e in [12, 6]), ilp_groups).time,
		ilpp_groups.time
	)'
	
	exp3_time_plot = groupedbar(graphsets3, experiment3_time_data, groups = methods3, 
		legend = :topleft, 
		color = colors',
		xrotation = 45,
		ylabel = "runtime (seconds)",
	)
end

# ╔═╡ 62ed8bfc-876c-11eb-1cac-cd5e64541200
savefig(exp3_time_plot, "preprocessing.pdf")

# ╔═╡ Cell order:
# ╠═0af4ed68-84fc-11eb-0259-17da5e613364
# ╠═093b1826-84ff-11eb-0777-6597897ac3d6
# ╠═dc776b04-867d-11eb-231a-df97309b4381
# ╠═db85711e-867d-11eb-276b-47a13568627b
# ╠═ec757f30-867f-11eb-3a48-5dabaef22ec8
# ╠═914cdec6-8686-11eb-3349-5519c1212578
# ╠═a378c352-868c-11eb-2e7f-31c097a2fa63
# ╠═a7efc99a-868b-11eb-287d-e5e1cc9d1355
# ╠═a8084918-868c-11eb-14b3-816139a336f6
# ╠═aa0d0800-873f-11eb-3eeb-bb001cd878bf
# ╠═a913f0c6-873f-11eb-27e7-4b343f927b7e
# ╠═ce94bf3a-873f-11eb-0f2f-df63393c5e24
# ╠═ca4996f6-873f-11eb-00ce-019824bf7a52
# ╠═f4fca1c2-873f-11eb-0361-2f6041d3b585
# ╠═019af4a8-8740-11eb-30e5-279ff26a2b8b
# ╠═17a536a4-8762-11eb-2285-2dc4952a1038
# ╠═861304ac-8750-11eb-1d61-5f66368893be
# ╠═d2e0b856-8750-11eb-273f-01a361fd3a30
# ╠═bf58830e-8755-11eb-1251-9b22474c08c4
# ╠═96737c1c-876b-11eb-1d9c-c314fa3870b4
# ╠═dceb1fce-876b-11eb-1310-27f8bba9315e
# ╠═0a559b10-876c-11eb-2336-0f106a45e095
# ╠═62ed8bfc-876c-11eb-1cac-cd5e64541200
