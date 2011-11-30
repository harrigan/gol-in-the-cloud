class AutomatonBolt < RedStorm::SimpleBolt
  include Notify
  output_fields :x, :y, :from_x, :from_y, :from_state, :from_state_prime, :from_r, :propagate
  
  on_init do
    init_notify
    @automatons = Hash.new do |h, coordinates|
      h[coordinates] = Automaton.new *coordinates
    end
  end
  
  on_receive :emit => false do |tuple|
    x = tuple.getLongByField "x"
    y = tuple.getLongByField "y"
    from_x = tuple.getLongByField "from_x"
    from_y = tuple.getLongByField "from_y"
    from_state = tuple.getStringByField "from_state"
    from_state_prime = tuple.getStringByField "from_state_prime"
    from_r = tuple.getLongByField "from_r"
    propagate = tuple.getBooleanByField "propagate"
    
    automaton = @automatons[[x, y]]
    
    dirty = false
    if from_x == x && from_y == y
      automaton.update from_state, from_state_prime, from_r
      dirty = true
    else
      automaton.update_neighbor from_x, from_y, from_state, from_state_prime, from_r
    end
    
    if propagate && automaton.ready?
      if automaton.r == 0
        live_neighbors = automaton.number_of_live_neighbors_in_my_time
        if automaton.is_live?
          if live_neighbors < 2 || live_neighbors > 3
            automaton.kill!
          else
            automaton.animate!
          end
        else
          if live_neighbors == 3
            automaton.animate!
          else
            automaton.kill!
          end
        end
      end
      automaton.increment_r!
      dirty = true
    end
    
    emit = lambda do |to_x, to_y, next_propagate|
      unanchored_emit(
        to_x,
        to_y,
        x,
        y,
        automaton.state,
        automaton.state_prime,
        automaton.r,
        next_propagate
      )
    end
    if dirty
      automaton.neighbor_coordinates.each do |coordinates|
        emit.call coordinates[0], coordinates[1], false
      end
      notify({
        :x => x,
        :y => y,
        :state => automaton.state,
        :state_prime => automaton.state_prime,
        :r => automaton.r
      })
    end
    if propagate
      neighbor_coordinates = automaton.neighbor_coordinates
      coordinates = neighbor_coordinates[rand(neighbor_coordinates.length)]
      emit.call coordinates[0], coordinates[1], true
    end
  end
end
