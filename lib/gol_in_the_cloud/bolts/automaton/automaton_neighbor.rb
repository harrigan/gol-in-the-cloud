class AutomatonNeighbor
  attr_reader :x, :y, :state, :state_prime, :r
  
  def initialize x, y, state = "DEAD", state_prime = "DEAD", r = 0
    @x, @y, @state, @state_prime, @r = x, y, state, state_prime, r
  end
  
  def update state, state_prime, r
    @state = state
    @state_prime = state_prime
    @r = r
  end
end
