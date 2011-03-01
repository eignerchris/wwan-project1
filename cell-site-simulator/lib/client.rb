
require 'fileutils'
require 'lib/utils'

class Client
  include FileUtils
  include Math
  include Utils
  
  attr_accessor :x, :y, :cinr, :opt_mcs, :bit_rate, :dist_from_tower
  
  def initialize(x, y)
    @x         = x
    @y         = y
    @cinr      = 0
  end
  
  # calculates optimum mcs for a client by comparing ber for each to target ber (converted from target bler)
  # in it's current form, if the client is unable to meet the target ber, it's opt_mcs is set to 'none'
  # and later dropped from the sector. this is mentioned as it has a direct effect on total capacity and
  # average bit rate
  def calc_opt_mcs(block_size, target_bler)
    # calculate all ber's and store in hash
    bit_error_rates           = {}
    bit_error_rates['qpsk']   = calc_qpsk_ber(dB_to_watts @cinr)
    bit_error_rates['16-qam'] = calc_qam16_ber(dB_to_watts @cinr)
    bit_error_rates['64-qam'] = calc_qam64_ber(dB_to_watts @cinr)
    
    # convert block error rate to bit error rate
    target_ber = bler_to_ber(block_size, target_bler)
    
    if bit_error_rates['64-qam'] < target_ber
      @opt_mcs = '64-qam'
      @ber     = bit_error_rates['64-qam']
    elsif bit_error_rates['16-qam'] < target_ber
      @opt_mcs = '16-qam'
      @ber     = bit_error_rates['16-qam']
    elsif bit_error_rates['qpsk'] < target_ber
      @opt_mcs = 'qpsk'
      @ber     = bit_error_rates['qpsk']
    else
      @opt_mcs = 'none'       # here we're identifying bad clients, ie. they don't meet the minimum requirement                
    end
    
    set_bit_rate
  end
  
  # helper function for calculating cartesian distance from the src tower
  def dist_from_tower
    cartesian_dist(origin, [x,y])
  end
  
  def stats
    puts ""
    puts "coord: (#{@x}, #{@y})"
    puts "cinr (dB): #{@cinr}"
    puts "cinr (watts): #{dB_to_watts(@cinr)}"
    puts "opt mcs: #{@opt_mcs}"
    puts "dist from tower: #{dist_from_tower} ft."
    puts "bit rate: #{@bit_rate}"
  end
  
  private 
  
  # calculates bit rate for opt_mcs
  def set_bit_rate
    case @opt_mcs
    when 'qpsk'
      @bit_rate = calc_bit_rate(2, @ber)
    when '16-qam'
      @bit_rate = calc_bit_rate(4, @ber)
    when '64-qam'
      @bit_rate = calc_bit_rate(6, @ber)
    end
  end
  
end
