class Client
  
  include Utils
  
  attr_accessor :x, :y, :cinr
  
  def initialize(x, y)
    @x    = x
    @y    = y
    @cinr = 0
  end
  
  def calc_opt_mcs
    @bit_error_rates['qpsk']   = qpsk_ber @cinr
    @bit_error_rates['16-qam'] = qam16_ber @cinr
    @bit_error_rates['64-qam'] = qam64_ber @cinr
    max = @bit_error_rates.values.max
  end
  
  def throughput
    
  end
  
end
