class LifeWeightSpaceShip < RedStorm::SimpleSpout
  set :is_distributed => false
  output_fields :x, :y, :from_x, :from_y, :from_state, :from_state_prime, :from_r, :propagate
  
  on_init do
    @queue = [
      [0, 0, 0, 0, "DEAD", "DEAD", 1, true],
      [0, 0, 0, 0, "DEAD", "DEAD", 1, true],
      [0, 0, 0, 0, "DEAD", "DEAD", 1, true],
      [5, 4, 5, 4, "LIVE", "DEAD", 0, false],
      [5, 3, 5, 3, "LIVE", "DEAD", 0, false],
      [5, 2, 5, 2, "LIVE", "DEAD", 0, false],
      [4, 4, 4, 4, "LIVE", "DEAD", 0, false],
      [4, 1, 4, 1, "LIVE", "DEAD", 0, false],
      [3, 4, 3, 4, "LIVE", "DEAD", 0, false],
      [2, 4, 2, 4, "LIVE", "DEAD", 0, false],
      [1, 3, 1, 3, "LIVE", "DEAD", 0, false],
      [1, 1, 1, 1, "LIVE", "DEAD", 0, false]
    ]
  end
  
  on_send do
    unless @queue.empty?
      @queue.pop
    end
  end
end
