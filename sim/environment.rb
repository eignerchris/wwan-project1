class Environment
  
  include Utils
  include Math
  
  attr_accessor :radius, :tx_power, :block_size, :bler, :clients, :coords
  
  def initialize(r, p, b_size, bler, clients)
    @radius       = r * 5280
    @tx_power     = p
    @block_size   = b_size
    @bler         = bler
    @clients      = clients
    @cinrs        = []
    init_grid_coords
  end
  
  def simulate
    calc_interference
    heatmap
  end
  
  # returns array of of cartesian coordinates
  # steps 5 degrees and 100ft at a time.
  def init_grid_coords
    angles  = (0..120).step(5).to_a                 # generate a list of angles through which to sweep
    lengths  = (0..@radius).step(100).to_a          # generate a list of lengths along those angles from 0 to radius
    polar_coords = angles.product lengths           # generate a list of pairs spanning all combinations
    @coords = polar_to_cartesian(polar_coords)      # convert polar coordinates to cartesian coordinates
  end
  
  # calculate total interference for all coordinates and store in a hash, indexed by the x, y pair
  def calc_interference
    @coords.each do |coord|
      fti = first_tier_interference(coord)
      @cinrs << (@radius**-GAMMA)/(fti)
    end
  end
  
  def heatmap
    h = Heatmap.new(@coords, @cinrs)
    h.generate
  end

end