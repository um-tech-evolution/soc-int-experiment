import NKLandscapes
const NK = NKLandscapes

const N = 32
const K = 16
const P = 1000 # Population size
const G = 100  # Generations
const E = 2    # Elite carryover
const C = 5    # Intelligence choices
const M = 100  # Moran selection rounds

l = NK.NKLandscape(N, K)
p = rand(NK.Population, l, P)

println("simulationType,generation,meanFitness,medianFitness,maxFitness")

# Social

sp = NK.Population(p)
for i = 1:G
  fits = NK.popfits(sp)
  println("social,$(i),$(mean(fits)),$(median(fits)),$(maximum(fits))")

  NK.bsmutate!(sp, 1.0)
  NK.elitesel!(sp, E)
end

# Intelligence

ip = NK.Population(p)
for i = 1:G
  fits = NK.popfits(ip)
  println("intelligence,$(i),$(mean(fits)),$(median(fits)),$(maximum(fits))")

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

