
class Sector
  
  include Math
  include Utils
  
  attr_accessor :clients, :radius, :tx_power, :block_size, :target_bler, :grid, :cinrs
  
  def initialize(r, p, b_size, bler, freq, bs_height, ms_height, start_angle, end_angle, interferers)
    @radius       = r
    @tx_power     = p
    @block_size   = b_size
    @target_bler  = bler
    @freq         = freq 
    @bs_height    = bs_height
    @ms_height    = ms_height   
    @start_angle  = start_angle
    @end_angle    = end_angle
    @interferers  = interferers
    setup
  end
  
  def setup
    # setup grid and coordinates for sector
    init_grid_coords
    
    # calc interference for each point in sector 
    calc_interference_grid
    
    # add some number of clients to environment
    init_random_clients
    
    # iterate through each client in sector and determine opt mcs
    calc_mcs_for_clients
    
    # drop clients with 'none' as opt_mcs
    drop_bad_clients
    
    #@clients.each { |c| c.stats }
  end

  def init_grid_coords

    # generate a list of angles through which to sweep
    angles       = (@start_angle..@end_angle).step(DEGREE_STEP).to_a
    
    # generate a list of distances along those angles, 5ft offset from base station
    # to avoid inifinity in some calculations
    distances    = (5..@radius).step(DISTANCE_STEP).to_a
    
    # generate a list of all combinations of pairs using #product
    polar_coords = angles.product distances
    
    # convert all polar coordinates to cartesian coordinates, convert coords to ints for convenience
    @grid        = polar_coords.collect { |coord| polar_to_cartesian(coord).map {|val| val.to_i } }
  end
  
  # calculate total interference for all coordinates and store in a hash, indexed by the x, y pair
  def calc_interference_grid
    @cinrs = {}
    
    @grid.each do |coord|
      src_distance  = cartesian_dist(origin, coord)
      src_path_loss = path_loss(src_distance, @freq, @bs_height, @ms_height)
      rx_power      = @tx_power - src_path_loss
      cinr          = rx_power - watts_to_dB(total_interference(coord))
      @cinrs[coord] = cinr
    end
  end
  
  # create clients list from random grid coordinates.
  def init_random_clients
    @clients = []
    
    ::CLIENTS_PER_SECTOR.times do
      # grab random coord from known grid coordinates
      rand_coord  = @grid[rand @grid.length]
      
      # init client with random coord from interference grid
      client      = Client.new( rand_coord.x, rand_coord.y )
      
      # lookup cinr at that coord and set cinr attr in client
      client.cinr = @cinrs[[client.x, client.y]]
      
      # append client to clients list
      @clients    << client 
    end
  end
  
  # iterate through each client in sector and determine opt mcs
  def calc_mcs_for_clients
    @clients.each { |c| c.calc_opt_mcs(@block_size, @target_bler) }
  end
  
  # drop clients with 'none' as opt_mcs
  def drop_bad_clients
    # bad_clients = @clients.collect { |c| c if c.opt_mcs == 'none' }.compact
    #     bad_clients.each do |bc|
    #       puts ""
    #       puts "coord: #{bc.x}, #{bc.y}"
    #       puts "cinr: #{bc.cinr}"
    #       puts "dist: #{bc.dist_from_tower}"
    #     end
    @clients.delete_if { |c| c.opt_mcs == 'none' }
  end
  
  # sum of all interference for a given coordinate
  def total_interference(coord)
   # calculate distances from coord for each
    distances = @interferers.map { |infx_coord| cartesian_dist(coord, infx_coord) }
    
    # collect infx from each interfering tower
    infx = distances.map do |dist|
      dB_to_watts(@tx_power - path_loss(dist, @freq, @bs_height, @ms_height))
    end

    infx.sum
  end
  
  # average bit rate for all clients
  def avg_bit_rate
    @clients.collect { |c| c.bit_rate }.sum/@clients.length.to_f
  end
  
  # sum of all bit rates for each client
  def total_capacity
    @clients.collect { |c| c.bit_rate }.sum
  end
  
  def stats
    puts "avg cinr (dB): #{@clients.collect { |c| c.cinr}.sum/@clients.length.to_f}"
    puts "avg dist from tower: #{@clients.collect { |c| c.dist_from_tower }.sum/@clients.length.to_f} ft."
    puts "avg bit rate: #{@clients.collect { |c| c.bit_rate }.sum/@clients.length.to_f}"
    puts "num clients: #{@clients.length}"
    puts ""
  end
  
end
