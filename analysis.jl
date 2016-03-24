module SocIntAnalysis

using DataFrames
using Gadfly

if length(ARGS) == 0
  error("No simulation config specified.")
end

simname = ARGS[1]

include("$(simname).jl")

df = readtable("$(simname).csv", makefactors=true, allowcomments=true)

df = by(df, [:generation, :simulationType, :K]) do d
  DataFrame(
    meanFitness=mean(d[:meanFitness]),
    medianFitness=mean(d[:medianFitness]),
    maxFitness=mean(d[:maxFitness])
  )
end

# Plot development

function drawPlot(variable)
  for kval = collect(K)
    fdf = df[df[:K] .== kval,:]
    p = plot(fdf, x="generation", y=variable, color="simulationType",
      Geom.line,
      Guide.title("$(variable) (N=$(N), K=$(kval), SEL=$(S), Trials=$(T))"))
    kvalstr = @sprintf("%02d", kval)
    draw(SVG("$(simname)_$(variable)_K$(kvalstr).svg", 8inch, 8inch), p)
  end
end

drawPlot("meanFitness")
drawPlot("medianFitness")
drawPlot("maxFitness")

end

