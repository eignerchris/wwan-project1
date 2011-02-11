class Environment
  
  attr_accessor :radius, :tx_power, :block_size, :bler, :env_area, :clients, :coords
  
  def initialize(r, p, b_size, bler, clients)
    @radius     = r * 5280
    @tx_power   = p
    @block_size = b_size
    @bler       = bler
    @env_area   = Math::PI * @radius ** 2
    @clients    = clients
    @coords     = init_coords
  end
  
  def simulate
  end
  
  # coordinates are polar coordinates e.g. (45, 5280)
  def init_coords
    angles  = (0..120).step(5).to_a
    lengths = (0..@radius).step(20).to_a
    angles.zip lengths
  end
  
  def calc_interference
    @coords.each do |coord|
      
    end
  end
  
end