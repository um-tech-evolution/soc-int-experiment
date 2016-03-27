# Social / Intelligence Simulation

## Prerequisites

  1. Julia 0.4.3
  2. Version 0.3.x of NKLandscapes.jl
  3. DataFrames.jl
  5. ProgressMeter.jl
  6. Gadfly.jl

To satisfy items (2) through (6) above:

  * Linux: `julia setup.jl`
  * Windows: `julia.exe setup.jl`

## Setup

You'll need to create a configuration file for your simulation run. There is an
example configuration, called `example.jl` in the `configs/` subdirectory.
You can copy this file and change the values if you'd like to add or run a new
configuration.

The configuration file is a Julia program that simply defines a set of
constants. You may create additional configurations and your may use any
valid Julia code within the configuration file.

## Running

To run the simulation once you have the prerequisites:

  * Linux: `./run.sh <config>`
  * Windows: `run.bat <config>`

The value you pass in as `<config>` should be the path to your configuration
file, but without the `.jl` extension. As an example, to run the example
configuration on Linux:

```
./run.sh configs/example
```

To do the same on Windows:

```
run.bat configs\example
```

This should create four additional files in the same directory as the
configuration file:

  1. `<config>.csv` - the raw results from the simulation
  2. `<config>_maxFitness.svg` - plot of max fitness in the population
  3. `<config>_meanFitness.svg` - plot of mean fitness in the population
  4. `<config>_medianFitness.svg` - plot of median fitness in the population

