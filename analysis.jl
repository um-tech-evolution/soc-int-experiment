module SocIntAnalysis

using DataFrames
using Gadfly

if length(ARGS) == 0
  error("No simulation config specified.")
end

simname = ARGS[1]

include("$(simname).jl")

df = readtable("$(simname).csv", makefactors=true, allowcomments=true)

df = by(df, [:generation, :simulationType]) do d
  DataFrame(
    meanFitness=mean(d[:meanFitness]),
    medianFitness=mean(d[:medianFitness]),
    maxFitness=mean(d[:maxFitness])
  )
end

# Plot development

function drawPlot(variable)
  p = plot(df, x="generation", y=variable, color="simulationType",
    Geom.line,
    Guide.title("$(variable) (N=$(N), K=$(K), SEL=$(S), Trials=$(T))"))
  draw(SVG("$(simname)_$(variable).svg", 8inch, 8inch), p)
end

drawPlot("meanFitness")
drawPlot("medianFitness")
drawPlot("maxFitness")

end

