require "rubygems"
require "bundler/setup"
Bundler.setup

require File.dirname(__FILE__) + "/../spouts/light_weight_space_ship_spout"

require File.dirname(__FILE__) + "/../bolts/util/notify"

require File.dirname(__FILE__) + "/../bolts/automaton/automaton_neighbor"
require File.dirname(__FILE__) + "/../bolts/automaton/automaton"
require File.dirname(__FILE__) + "/../bolts/automaton_bolt"

class Topology < RedStorm::SimpleTopology
  spout LifeWeightSpaceShip
  
  bolt AutomatonBolt, :parallelism => 12 do
    source LifeWeightSpaceShip, :fields => [ "x", "y" ]
    source AutomatonBolt, :fields => ["x", "y" ]
  end
  
  configure :gol do |env|
    case env
    when :local
      debug true
      max_task_parallelism 3
    when :cluster
      debug true
      num_workers 20
      max_spout_pending 1000
    end
  end
  
  on_submit do |env|
    if env == :local
      sleep 6000
      cluster.shutdown
    end
  end
end
