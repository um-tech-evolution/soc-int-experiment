using DataFrames
using Gadfly

df = readtable("output.csv", makefactors=true)

df = by(df, [:generation, :simulationType]) do d
  DataFrame(
    meanFitness=mean(d[:meanFitness]),
    medianFitness=median(d[:medianFitness]),
    maxFitness=maximum(d[:maxFitness])
  )
end

# Plot development

function drawPlot(variable)
  p = plot(df, x="generation", y=variable, color="simulationType", Geom.line)
  draw(SVG("$(variable).svg", 6inch, 6inch), p)
end

drawPlot("meanFitness")
drawPlot("medianFitness")
drawPlot("maxFitness")

