class Environment
  
  include Utils
  
  attr_accessor :radius, :tx_power, :block_size, :bler, :env_area, :clients, :coords, :intferences
  
  def initialize(r, p, b_size, bler, clients)
    @radius        = r * 5280
    @tx_power      = p
    @block_size    = b_size
    @bler          = bler
    @env_area      = Math::PI * (@radius ** 2)
    @clients       = clients
    @coords        = init_coords
    @interferences = {}
  end
  
  def simulate
    calc_interference
    heatmap
  end
  
  # returns array of of polar coordinates inside a sector
  # each sector is 120 degrees
  # steps 5 degrees and 20ft at a time.
  # e.g. [ [0, 50], [0, 100], ..., [120, 0], [120, 50] ]
  def init_coords
    angles  = (0..120).step(10).to_a
    lengths = (0..@radius).step(50).to_a
    angles.product lengths
  end
  
  def calc_interference
    @coords.each do |coord|
      @interferences[coord] = first_tier_interference(coord)
    end
  end
  
  def heatmap
    xs = @coords.collect { |coord| coord[1] * Math::cos(coord[0]) }
    ys = @coords.collect { |coord| coord[1] * Math::sin(coord[0]) }
    h = Heatmap.new(xs, ys)
    h.generate
    pp @coords
  end
end