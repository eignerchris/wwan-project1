class Client
  
  include Math
  include Utils
  
  attr_accessor :x, :y, :cinr, :opt_mcs, :throughput, :dist_from_tower
  
  def initialize(x, y)
    @x                = x
    @y                = y
    @cinr             = 0
    @dist_from_tower  = cartesian_dist([0,0], [x,y])
  end
  
  def calc_opt_mcs(target_bler)
    # calculate all ber's and store in hash
    bit_error_rates           = {}
    bit_error_rates['qpsk']   = calc_qpsk_ber(dB_to_watts @cinr)
    bit_error_rates['16-qam'] = calc_qam16_ber(dB_to_watts @cinr)
    bit_error_rates['64-qam'] = calc_qam64_ber(dB_to_watts @cinr)
    
    puts "#{dB_to_watts @cinr}: #{bit_error_rates.inspect}"
    # delete all greater than target ber
    bit_error_rates.delete_if { |k, v| v > target_bler }
    
    # grab the max ber
    max = bit_error_rates.max { |x, y| x.last <=> y.last }

    # set opt_mcs
    @opt_mcs = max.nil? ? 'none' : max.first
    
    # calculate throughput based on opt_mcs
    set_throughput
  end
  
  def set_throughput
    case @opt_mcs
    when 'qpsk'
      @throughput = calc_throughput(4)
    when '16-qam'
      @throughput = calc_throughput(16)
    when '64-qam'
      @throughput = calc_throughput(64)
    else
      @throughput = 0
    end
  end
  
  def calc_throughput(n)
    (BANDWIDTH_PER_SECTOR.to_f/NUM_CLIENTS.to_f) * 2 * n
  end
  
  def calc_qpsk_ber(cinr)
    puts "CINR: #{cinr}"
    return 0 if cinr.abs == 1.0/0
    2 * q( sqrt(2*cinr) )
  end
  
  def calc_qam16_ber(cinr)
    puts "CINR: #{cinr}"
    return 0 if cinr.abs == 1.0/0
    k = log2(16)
    1 - (1 - (2 * q(sqrt(((3 * k)/15) * cinr))))**2
  end
  
  def calc_qam64_ber(cinr)
    puts "CINR: #{cinr}"
    return 0 if cinr.abs == 1.0/0
    k = log2(64)
    1 - (1 - (2 * q(sqrt(((3 * k)/63) * cinr))))**2
  end
  
end
