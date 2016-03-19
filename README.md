# Social / Intelligence Simulation

## Prerequisites

  1) Julia 0.4.3
  2) The `bits-refactor` branch of NKLandscapes.jl
  3) DataFrames.jl and Gadfly.jl

To satisfy item (2) above:

```
julia> Pkg.add("NKLandscapes")
...
julia> Pkg.checkout("NKLandscapes", "bits-refactor")
...
```

To satisfy item (3) above:

```
julia> Pkg.add("DataFrames")
...
julia> Pkg.add("Gadfly")
...
```

## Running

To run the simulation once you have the prerequisites:

  1) `julia simulation.jl`
  2) `julia analysis.jl`

This will create an `output.csv` file and three plots of key results as SVG
files.

