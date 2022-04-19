# script to be run when running algorithms in parallel to ensure that all cores have access to the necessary code.
@everywhere using Pkg
@everywhere Pkg.activate(".")
using GraphColoring
using GraphColoring.Algorithms
