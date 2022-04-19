## Instructions to install and run tests
Download and install Julia **v1.5** from https://julialang.org/downloads/

Starting in the `Exam` folder:
```bash
$ cd GraphColoring
$ julia
julia>
julia>]                             # typing a right square-bracket into the REPL puts you into pkg mode.
@v1.5) pkg> activate .              # activate the environment for the project.
(GraphColoring) pkg> instantiate    # download and install dependencies for the project.
(GraphColoring) pkg> test           # run unit tests
julia>                              # backspace to remove the square-bracket and go back into normal REPL mode.
```