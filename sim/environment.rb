class Environment
  
  attr_accessor :radius, :tx_power, :block_size, :bler, :env_area, :clients
  
  def initialize(r, p, b_size, bler, clients)
    @radius     = r
    @tx_power   = p
    @block_size = b_size
    @bler       = bler
    @env_area   = Math::PI * @radius ** 2
    @clients    = clients
  end
  
  # TODO: derive noise_power
  def snr(noise_power)
    @tx_power/noise_power
  end
  
  # TODO: fill out this function
  def cinr(gamma)
  end
  
  # TODO: lookup table for mcs? 
  def opt_mcs
  end
  
  def avg_sector_cap
  end
  
end