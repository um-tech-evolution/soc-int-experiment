module SocIntSim
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
getconfig(key) = config[key] |> string |> parse |> eval

N     = getconfig("N")
K     = getconfig("K")
P     = getconfig("P")     # Population size
G     = getconfig("G")     # Generations
E     = getconfig("E")     # Elite carryover
C     = getconfig("C")     # Intelligence choices
M     = getconfig("M")     # Moran selection rounds
T     = getconfig("T")     # Number of trials
W_soc = getconfig("W_soc") # Bitwise mutation rate (social)
W_int = getconfig("W_int") # Bitwise mutation rate (intelligence)

function writeheader(stream)
  write(stream, join([
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
  write(stream, line, "\n")
end

function writerow(stream, trial, simtype, generation, fits)
  line = join([
    trial,
    simtype,
    generation,
    mean(fits),
    median(fits),
    maximum(fits)
  ], ",")
  write(stream, line, "\n")
end

function runtrial(trial, stream, progress)
  l = NK.NKLandscape(N, K)
  p = rand(NK.Population, l, P)

  # Social
  sp = NK.Population(p)
  for i = 1:G
    fits = NK.popfits(sp)
    writerow(stream, trial, "social", i, fits)

    NK.bwmutate!(sp, W_soc)
    NK.elitesel!(sp, E)

    PM.next!(progress)
  end

  # Intelligence
  ip = NK.Population(p)
  for i = 1:G
    fits = NK.popfits(ip)
    writerow(stream, trial, "intelligence", i, fits)

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
    NK.moransel!(ip, M)

    PM.next!(progress)
  end
end

# Run the simulation

stream = open("$(simname).csv", "w")
progress = PM.Progress(T * G * 2, 1, "Running...", 40)
writeheader(stream)
for trial = 1:T
  runtrial(trial, stream, progress)
  flush(stream)
end
close(stream)

end

