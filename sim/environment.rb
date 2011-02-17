class Environment
  
  NUM_CLIENTS = 25
  
  include Utils
  include Math
  
  attr_accessor :radius, :tx_power, :block_size, :bler, :clients, :interference_grid
  
  def initialize(r, p, b_size, bler)
    @radius       = r * 5280
    @tx_power     = p
    @block_size   = b_size
    @bler         = bler
    @clients      = clients
    @cinrs        = {}
    init_grid_coords
  end
  
  def simulate
    calc_interference_grid                  # create grid of cartesian coordinates and calc first tier interference for each
    add_random_clients                      # add some number of clients to environment
    calc_opt_mcs_for_clients
    #generate_heatmap
  end
  
  # returns array of of cartesian coordinates
  # steps 5 degrees and 100ft at a time.
  def init_grid_coords
    angles  = (0..120).step(5).to_a                 # generate a list of angles through which to sweep
    lengths  = (0..@radius).step(100).to_a          # generate a list of lengths along those angles from 0 to radius
    polar_coords = angles.product lengths           # generate a list of pairs spanning all combinations
    @interference_grid = polar_coords.collect { |coord| polar_to_cartesian(coord) }      # convert polar coordinates to cartesian coordinates
  end
  
  # calculate total interference for all coordinates and store in a hash, indexed by the x, y pair
  def calc_interference_grid
    @interference_grid.each do |coord|
      fti = first_tier_interference(coord)            # calculate first_tier interference for coord
      @cinrs[coord] = (@radius**-GAMMA)/(fti)         # calculate cinr at coord and store in hash table for easy lookup
    end
  end
  
  def add_random_clients
    @clients = []
    NUM_CLIENTS.times do
      num_coords = @interference_grid.length
      rand_coord = @interference_grid[rand num_coords]
      c = Client.new( rand_coord.first, rand_coord.last )         # init client with random coord from interference grid
      c.cinr = @cinrs[[c.x, c.y]]                                 # lookup cinr at that coord and set attr in client
      @clients << c                                               # append client to clients list
    end
  end
  
  def generate_heatmap
    h = Heatmap.new(@coords, @cinrs)
    h.generate
  end

end