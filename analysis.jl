module SocIntAnalysis

using DataFrames
using Gadfly
import YAML

if length(ARGS) == 0
  error("No simulation config specified.")
end

simname = ARGS[1]

config = YAML.load_file("$(simname).yaml")

df = readtable("$(simname).csv", makefactors=true, allowcomments=true)

df = by(df, [:generation, :simulationType]) do d
  DataFrame(
    meanFitness=mean(d[:meanFitness]),
    medianFitness=median(d[:medianFitness]),
    maxFitness=maximum(d[:maxFitness])
  )
end

# Plot development

function drawPlot(variable)
  p = plot(df, x="generation", y=variable, color="simulationType",
    Geom.line,
    Guide.title("$(variable) (N=$(config["N"]), K=$(config["K"]))"))
  draw(SVG("$(simname)_$(variable).svg", 8inch, 8inch), p)
end

drawPlot("meanFitness")
drawPlot("medianFitness")
drawPlot("maxFitness")

end

