
class Cell
  
  FREQS = [2505, 2515, 2530]

  attr_accessor :sector_a, :sector_b, :sector_c, :sectors
  
  def initialize(r, power, block_size, target_bler, bs_height, ms_height)
    @radius      = r
    @tx_power    = power
    @block_size  = block_size
    @target_bler = target_bler
    @bs_height   = bs_height
    @ms_height   = ms_height
    init_sectors
  end
  
  def simulate
    @sectors = [@sector_a, @sector_b, @sector_c]
    # run setup on each sector
    @sectors.map { |s| s.setup }
  end
  
  # create each sector
  def init_sectors
    @sector_a = Sector.new(@radius, @tx_power, @block_size, @target_bler, FREQS[0], @bs_height, @ms_height, -60, 60, sector_a_intfx_coords)
    @sector_b = Sector.new(@radius, @tx_power, @block_size, @target_bler, FREQS[1], @bs_height, @ms_height, 181, 300, sector_b_intfx_coords)
    @sector_c = Sector.new(@radius, @tx_power, @block_size, @target_bler, FREQS[2], @bs_height, @ms_height, 61, 180, sector_c_intfx_coords)
  end
  
  # average bit_rate across all sectors and all users
  def avg_bit_rate
    @sectors.collect { |s| s.avg_bit_rate }.sum/@sectors.length.to_f
  end
  
  # average of sector capacities (capacity = sum of all bit_rates for all clients)
  def avg_capacity
    @sectors.collect { |s| s.total_capacity }.sum/@sectors.length.to_f
  end
  
  # uses gnuplot script to generate a heatmap from heatmap.dat, saved in heatmaps/
  def generate_heatmap
    gen_heatmap_datafile
    `gnuplot colorpts.gp`
    if File.exists? 'tmp.png'
      fn = "heatmaps/#{@radius/5280.to_f}-#{@tx_power.to_i}-#{@block_size.to_i}-#{@target_bler}.png"
      FileUtils.cp 'tmp.png', fn
    end
  end
  
  def stats
    puts ""
    puts "avg bit rate: #{avg_bit_rate}"
    puts "average sector capacity: #{avg_capacity}"
    puts "supported users:"
    puts "   sector a: #{@sector_a.clients.length}"
    puts "   sector b: #{@sector_b.clients.length}"
    puts "   sector c: #{@sector_c.clients.length}"
  end
  
  private 
  
  # generates a heatmap datafile to be handled by gnuplots script
  def gen_heatmap_datafile
    f = File.open("heatmap.dat", "w")
    @sectors.each do |sector|
      sector.cinrs.each do |data|
        coord = data.first
        cinr  = data.last
        f.write "#{coord.x} #{coord.y} #{cinr}\n"
      end
    end
  end
  
  ### these are gross and hardcoded based on geometry. ###
  def sector_a_intfx_coords
    [ [-1.5 * @radius, @radius], [-1.5 * @radius, -@radius], 
    [-1.5 * @radius, 3 * @radius], [-3 * @radius, 2 * @radius],
    [-3 * @radius, 0], [-3 * @radius, -2 * @radius],
    [-1.5 * @radius, -3 * @radius] ]
  end
  
  def sector_b_intfx_coords
    [ [0, 2 * @radius], [1.5 * @radius, @radius],                           
    [-1.5 * @radius, 3 * @radius], [0, 4 * @radius], 
    [1.5 * @radius, 3 * @radius], [3 * @radius, 2 * @radius], 
    [3 * @radius, 0] ]
  end
  
  def sector_c_intfx_coords
    [ [0, -2 * @radius], [1.5 * @radius, -@radius],
    [3 * @radius, 0], [3 * @radius, -2 * @radius],
    [1.5 * @radius, -3 * @radius], [0, -4 * @radius],
    [-1.5 * @radius, -3 * @radius] ]
  end
end
