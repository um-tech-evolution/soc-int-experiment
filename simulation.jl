import NKLandscapes
const NK = NKLandscapes

const N = 32
const K = 1
const P = 100  # Population size
const G = 100  # Generations
const E = 2    # Elite carryover
const C = 5    # Intelligence choices
const M = 100  # Moran selection rounds
const T = 10   # Number of trials

function outputrow(trial, simtype, generation, fits)
  println("$(trial),$(simtype),$(generation),$(mean(fits)),$(median(fits)),$(maximum(fits))")
end

println("trial,simulationType,generation,meanFitness,medianFitness,maxFitness")

for trial = 1:T
  l = NK.NKLandscape(N, K)
  p = rand(NK.Population, l, P)

  # Social
  sp = NK.Population(p)
  for i = 1:G
    fits = NK.popfits(sp)
    outputrow(trial, "social", i, fits)

    NK.bsmutate!(sp, 1.0)
    NK.elitesel!(sp, E)
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
        option = NK.bsmutate(g, 1.0)
        if NK.fitness(option) > NK.fitness(choice)
          choice = option
        end
      end
      ip.genotypes[i] = choice
    end
    NK.moransel!(ip, M)
  end
end

