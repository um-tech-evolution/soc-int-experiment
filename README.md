# Social / Intelligence Simulation

## Prerequisites

  1. Julia 0.4.3
  2. The `bits-refactor` branch of NKLandscapes.jl
  3. DataFrames.jl, YAML.jl, ProgressMeter.jl, and Gadfly.jl

To satisfy items (2) and (3) above:

  * Linux: `julia setup.jl`
  * Windows: `julia.exe setup.jl`

## Setup

You'll need to create a configuration file for your simulation run. There is an
example configuration, called `example.yaml` in the `configs/` subdirectory.
You can copy this file and change the values if you'd like to add or run a new
configuration.

## Running

To run the simulation once you have the prerequisites:

  * Linux: `./run.sh <config>`
  * Windows: `run.bat <config>`

The value you pass in as `<config>` should be the path to your YAML
configuration file, but without the `.yaml` extension. As an example, to run
the example configuration on Linux:

```
./run.sh configs/example
```

This should create four additional files in the same directory as the YAML
file:

  1. `<config>.csv` - the raw results from the simulation
  2. `<config>_maxFitness.svg` - plot of max fitness in the population
  3. `<config>_meanFitness.svg` - plot of mean fitness in the population
  4. `<config>_medianFitness.svg` - plot of median fitness in the population

