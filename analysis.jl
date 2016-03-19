using DataFrames
using Gadfly

df = readtable("output.csv", makefactors=true)

# Plot development

function drawPlot(variable)
  p = plot(df, x="generation", y=variable, color="simulationType", Geom.line)
  draw(SVG("$(variable).svg", 6inch, 6inch), p)
end

drawPlot("meanFitness")
drawPlot("medianFitness")
drawPlot("maxFitness")

