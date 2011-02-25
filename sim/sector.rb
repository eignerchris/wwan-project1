class Sector
  
  include Math
  include Utils
  
  attr_accessor :clients, :radius, :tx_power, :block_size, :target_bler
  
  def initialize(r, p, b_size, bler, freq)
    @radius       = r * 5280
    @tx_power     = p
    @block_size   = b_size
    @target_bler  = bler
    @freq         = freq
    @clients      = clients
    @cinrs        = {}
  end
  
  def simulate
    # setup grid and coordinates for sector
    init_grid_coords
    
    # calc interference for each point in sector 
    calc_interference_grid
    
    # add some number of clients to environment
    init_random_clients
    
    # iterate through each client in sector and determine opt mcs
    @clients.each { |c| c.calc_opt_mcs(@block_size, @target_bler) }
    
    #heatmap
    gen_heatmap_datafile
  end
  
  # returns array of of cartesian coordinates
  # steps 5 degrees and 100ft at a time.
  def init_grid_coords
    # generate a list of angles through which to sweep
    angles       = (0..NUM_DEGREES).step(DEGREE_STEP).to_a
    
    # generate a list of lengths along those angles from 0 to radius
    lengths      = (0..@radius).step(DISTANCE_STEP).to_a
    
    # generate a list of all combinations of pairs using #product
    polar_coords = angles.product lengths
    
    # convert all polar coordinates to cartesian coordinates, convert coords to ints
    @grid        = polar_coords.collect { |coord| polar_to_cartesian(coord).map {|val| val.to_i } }
    
    
  end
  
  # calculate total interference for all coordinates and store in a hash, indexed by the x, y pair
  def calc_interference_grid
    @data = []
    @grid.each do |coord|
      src_path_loss = path_loss(cartesian_dist(origin, coord), @freq)
      rx_power      = @tx_power - src_path_loss
      cinr          = rx_power - (10 * log10(total_interference(coord)))
      @cinrs[coord] = cinr
      @data         << cinr
    end
  end
  
  def init_random_clients
    @clients = []
    NUM_CLIENTS.times do
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
  
  def total_interference(coord)
    first_tier_interference(coord) + second_tier_interference(coord)
  end
  
  # returns sum of first tier interferers for a given coordinate
  # calculated using pythagorean theorem and some simple geometry
  def first_tier_interference(coord)
    # find coords for interferers
    fti_coords = [ [-2 * @radius, @radius], [-2 * @radius, -@radius] ]
    
    # calculate distances from coord for each
    distances = fti_coords.map {|infx_coord| cartesian_dist(coord, infx_coord) }
    
    infx = distances.map do |dist|
      dB_to_watts(@tx_power - path_loss(dist, @freq))
    end
    
    infx.sum
    
  end
   
  # returns sum of second tier interferers for a given coordinate
  # calculated using pythagorean theorem and some simple geometry
  def second_tier_interference(coord)
    # coords for interferers
    sti_coords = [ [-2 * @radius, 3 * @radius], [-4 * @radius, 2 * @radius], [-4 * @radius, 0],
                   [-4 * @radius, -2 * @radius], [-2 * @radius, -3 * @radius] ] 
    
    # calculate distances from coord for each
    distances = sti_coords.map { |infx_coord| cartesian_dist(coord, infx_coord) }
    
    # collect infx from each interfering tower
    infx = distances.map do |dist|
      dB_to_watts(@tx_power - path_loss(dist, @freq))
    end
    
    infx.sum
    
  end
  
  def heatmap
    h = Heatmap.new(@grid, @cinrs)
    h.generate
  end
  
  def gen_heatmap_datafile
    f = File.open("heatmap.dat", "w")
    @grid.each do |point|
      f.write "#{point.x} #{point.y} #{@cinrs[point] }\n"
    end
  end
  
  def print_report
    puts "", "Sector Report"
    puts "*" * 100
    puts "params: "
    puts "  radius: #{radius} ft."
    puts "  power (dB): #{tx_power}"
    puts "  block size: #{block_size} bytes"
    puts "  target ber: #{target_bler * 100} %"
    puts "*" * 100
    puts "", "Client Info"
    puts "=" * 100
    @clients.each do |client|
      puts "coord: (#{client.x}, #{client.y})"
      puts "cinr: #{client.cinr}"
      puts "opt mcs: #{client.opt_mcs}"
      puts "dist from tower: #{client.dist_from_tower} ft."
      puts "bit rate: #{client.bit_rate}"
      puts ""
    end
  end
  
end
