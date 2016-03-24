module SocIntSim
import ProgressMeter
const PM = ProgressMeter
import NKLandscapes
const NK = NKLandscapes

if length(ARGS) == 0
    error("No simulation config specified.")
end
simname = ARGS[1]

include("$(simname).jl")

function writeheader(stream)
  write(stream, join([
    "# N=$(N)",
    "# K=$(K)",
    "# P=$(P)",
    "# G=$(G)",
    "# S=$(S)",
    "# E=$(E)",
    "# C=$(C)",
    "# M=$(M)",
    "# T=$(T)",
    "# W_soc=$(W_soc)",
    "# W_int=$(W_int)"
  ], "\n"), "\n")
  line = join([
    "trial",
    "simulationType",
    "K",
    "generation",
    "meanFitness",
    "medianFitness",
    "maxFitness"
  ], ",")
  write(stream, line, "\n")
end

function writerow(stream, trial, simtype, kval, generation, fits)
  line = join([
    trial,
    simtype,
    kval,
    generation,
    mean(fits),
    median(fits),
    maximum(fits)
  ], ",")
  write(stream, line, "\n")
end

function runtrial(trial, stream, progress, kval)
  l = NK.NKLandscape(N, kval)
  p = rand(NK.Population, l, P)

  # Social
  sp = NK.Population(p)
  for i = 1:G
    fits = NK.popfits(sp)
    writerow(stream, trial, "social", kval, i, fits)

    NK.bwmutate!(sp, W_soc)
    NK.elitesel!(sp, E)

    PM.next!(progress)
  end

  # Intelligence
  ip = NK.Population(p)
  for i = 1:G
    fits = NK.popfits(ip)
    writerow(stream, trial, "intelligence", kval, i, fits)

    for i = 1:NK.popsize(ip)
      g = ip.genotypes[i]
      choice = g
      for _ = 1:C
        option = NK.bwmutate(g, W_int)
        if NK.fitness(option) > NK.fitness(choice)
          choice = option
        end
      end
      ip.genotypes[i] = choice
    end

    if S == :M
      NK.moransel!(ip, M)
    elseif S == :P
      NK.propsel!(ip)
    elseif S == :T
      NK.tournsel!(ip, 2) # Use tournament size 2 for now
    elseif S == :N
      continue
    else
      error("Illegal selection type: ", S)
    end

    PM.next!(progress)
  end
end

# Run the simulation

stream = open("$(simname).csv", "w")

kvals = collect(K)

progress = PM.Progress(T * G * 2 * length(kvals), 1, "Running...", 40)

writeheader(stream)
for kval = kvals
  for trial = 1:T
    runtrial(trial, stream, progress, kval)
    flush(stream)
  end
end
close(stream)

end

