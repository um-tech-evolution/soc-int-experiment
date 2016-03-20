import ProgressMeter
const PM = ProgressMeter
import NKLandscapes
const NK = NKLandscapes
import YAML

if length(ARGS) == 0
    error("No simulation config specified.")
end

simname = ARGS[1]

config = YAML.load_file("$(simname).yaml")

N = config["N"]
K = config["K"]
P = config["P"] # Population size
G = config["G"] # Generations
E = config["E"] # Elite carryover
C = config["C"] # Intelligence choices
M = config["M"] # Moran selection rounds
T = config["T"] # Number of trials

out = open("$(simname).csv", "w")

function writeheader()
  write(out, join([
    "# N=$(N)",
    "# K=$(K)",
    "# P=$(P)",
    "# G=$(G)",
    "# E=$(E)",
    "# C=$(C)",
    "# M=$(M)",
    "# T=$(T)"
  ], "\n"), "\n")
  line = join([
    "trial",
    "simulationType",
    "generation",
    "meanFitness",
    "medianFitness",
    "maxFitness"
  ], ",")
  write(out, line, "\n")
  flush(out)
end

function outputrow(trial, simtype, generation, fits)
  line = join([
    trial,
    simtype,
    generation,
    mean(fits),
    median(fits),
    maximum(fits)
  ], ",")
  write(out, line, "\n")
  flush(out)
end

writeheader()

progress = PM.Progress(T * G * 2, 1, "Running...", 40)

for trial = 1:T
  l = NK.NKLandscape(N, K)
  p = rand(NK.Population, l, P)

  # Social
  sp = NK.Population(p)
  for i = 1:G
    fits = NK.popfits(sp)
    outputrow(trial, "social", i, fits)

    NK.bwmutate!(sp, 1.0 / N)
    NK.elitesel!(sp, E)

    PM.next!(progress)
  end

  # Intelligence
  ip = NK.Population(p)
  for i = 1:G
    fits = NK.popfits(ip)
    outputrow(trial, "intelligence", i, fits)

    for i = 1:NK.popsize(ip)
      g = ip.genotypes[i]
      choice = g
      for _ = 1:C
        option = NK.bwmutate(g, 1.0 / N)
        if NK.fitness(option) > NK.fitness(choice)
          choice = option
        end
      end
      ip.genotypes[i] = choice
    end
    NK.moransel!(ip, M)

    PM.next!(progress)
  end
end

close(out)

