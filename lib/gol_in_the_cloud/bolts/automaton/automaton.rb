class Automaton < AutomatonNeighbor
  MAX_WIDTH = 14
  MAX_HEIGHT = 7
  
  def initialize x, y, state = "DEAD", state_prime = "DEAD", r = 0
    super
    @neighbors = Hash[
      ((-1..1).collect do |i|
        (-1..1).collect do |j|
          [(x + i) % MAX_WIDTH, (y + j) % MAX_HEIGHT]
        end
      end.flatten(1) - [[x, y]]).collect do |coordinates|
        [coordinates, AutomatonNeighbor.new(*coordinates)]
      end
    ]
  end
  
  def neighbor_coordinates
    @neighbors.keys
  end
  
  def number_of_live_neighbors_in_my_time
    count = 0
    @neighbors.values.each do |neighbor|
      if (neighbor.state == "LIVE" && neighbor.r == 0) || (neighbor.state_prime == "LIVE" && neighbor.r == 1)
        count += 1
      end
    end
    count
  end
  
  def update_neighbor x, y, state, state_prime, r
    @neighbors[[x, y]].update state, state_prime, r
  end
  
  def animate!
    @state, @state_prime = "LIVE", @state
  end
  
  def kill!
    @state, @state_prime = "DEAD", @state
  end
  
  def is_live?
    state == "LIVE"
  end
  
  def increment_r!
    @r = (@r + 1) % 3
  end
  
  def ready?
    @neighbors.all? do |k, v|
      v.r != (@r + 2) % 3
    end
  end
end
