class Client
  
  include Math
  include Utils
  
  attr_accessor :x, :y, :cinr, :opt_mcs, :bit_rate, :dist_from_tower
  
  def initialize(x, y)
    @x                = x
    @y                = y
    @cinr             = 0
  end
  
  def calc_opt_mcs(block_size, target_bler)
    # calculate all ber's and store in hash
    bit_error_rates           = {}
    bit_error_rates['qpsk']   = calc_qpsk_ber(dB_to_watts @cinr)
    bit_error_rates['16-qam'] = calc_qam16_ber(dB_to_watts @cinr)
    bit_error_rates['64-qam'] = calc_qam64_ber(dB_to_watts @cinr)
    
    if bit_error_rates.has_value? 0.0
      puts "*" * 20
      puts "ZERO BUG!!!"
      puts "COORD: (#{@x}, #{@y})"
      puts "CINR (dB): #{@cinr}"
      puts "CINR (watts): #{dB_to_watts @cinr}"
    end
    
    # convert block error rate to bit error rate
    target_ber = bler_to_ber(block_size, target_bler)
    
    if bit_error_rates['64-qam'] < target_ber
      @opt_mcs = '64-qam'
      @ber     = bit_error_rates['64-qam']
    elsif bit_error_rates['16-qam'] < target_ber
      @opt_mcs = '16-qam'
      @ber     = bit_error_rates['16-qam']
    else
      @opt_mcs = 'qpsk'
      @ber     = bit_error_rates['qpsk']
    end
    
    set_bit_rate
  end
  
  def dist_from_tower
    cartesian_dist(origin, [x,y])
  end
  
  private 
  
  def set_bit_rate
    case @opt_mcs
    when 'qpsk'
      @bit_rate = calc_bit_rate(4, @ber)
    when '16-qam'
      @bit_rate = calc_bit_rate(16, @ber)
    when '64-qam'
      @bit_rate = calc_bit_rate(64, @ber)
    else
      @bit_rate = 0
    end
  end
  
  def calc_qpsk_ber(cinr)
    return 0 if cinr.abs == 1.0/0
    2 * q( sqrt(2*cinr) )
  end
  
  def calc_qam16_ber(cinr)
    return 0 if cinr.abs == 1.0/0
    k = log2(16)
    1 - (1 - (2 * q(sqrt(((3 * k)/15) * cinr))))**2
  end
  
  def calc_qam64_ber(cinr)
    return 0 if cinr.abs == 1.0/0
    k = log2(64)
    1 - (1 - (2 * q(sqrt(((3 * k)/63) * cinr))))**2
  end
  
end
