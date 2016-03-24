const N     = 32      # N parameter of NK
const K     = 16      # K parameter of NK
const P     = 100     # Population size
const G     = 100     # Generations
const S     = :M      # Type of selection for intelligence:
                      # :M = Moran, :P = Proportional, :T = Tournament
const E     = 2       # Elite carryover
const C     = 5       # Intelligence choices
const M     = 100     # Moran selection rounds
const Tk    = 3       # Tournament selection tournament size
const T     = 10      # Number of trials
const W_soc = 1.0 / N # Bitwise mutation rate (social)
const W_int = 1.0 / N # Bitwise mutation rate (intelligence)
