
module Utils
  
  include Math
  
  # converts a polar coordinate to a cartesian coordinate
  def polar_to_cartesian(polar_coord)
    angle = polar_coord.first
    dist  = polar_coord.last
    x     = dist * cos(angle * (Math::PI/180))
    y     = dist * sin(angle * (Math::PI/180))
    [x, y]
  end
  
  # calculates path loss
  # bs_height in meters, ms_height in meters, d in meters (converted to km), freq in MHz
  # returns path loss in dB
  def path_loss(d, freq, bs_height, ms_height)
    # convert to meters
    d = d.abs/3.281
    (44.9 - 6.55 * log10(bs_height)) * log10(d/1000) + 45.5 + ( (35.46 - (1.1 * ms_height) ) * log10(freq)) - 13.82 * log10(bs_height) + (0.7 * ms_height) + 3
  end
  
  # calculates distance between two cartesian coordinates
  def cartesian_dist(coord1, coord2)
    sqrt((coord1.x - coord2.x)**2 + (coord1.y - coord2.y)**2)
  end
  
  # converts a block error rate to a bit error rate
  def bler_to_ber(block_size, bler)
    1 - (1 - bler)**(1/block_size.to_f)
  end
  
  # converts a bit error rate to a block error rate
  def ber_to_bler(block_size, ber)
    1 - (1 - ber)**(block_size.to_f)
  end
  
  # converts dB to watts
  def dB_to_watts(dB)
    10**(dB/10.to_f)
  end
  
  # converts watts to dB
  def watts_to_dB(watts)
    10 * log10(watts.to_f)
  end
  
  # helper function for calculating bit error rates
  def q(x)
    0.5 * erfc(x / sqrt(2.0))
  end
  
  # calculates bit rate for given encoding level and bit rate
  def calc_bit_rate(n, ber)
    symbol_rate * n * (1 - ber.to_f)
  end
  
  # calculates symbol rate based on bandwidth per sector and clients per sector
  # TODO: could be modularized so as not to rely on constants
  def symbol_rate
    2 * (::BANDWIDTH_PER_SECTOR.to_f/::CLIENTS_PER_SECTOR)
  end
  
  # calculates QPSK bit error rate
  def calc_qpsk_ber(cinr)
    2 * q( sqrt(cinr.to_f) )
  end
  
  # calculates 16-QAM bit error rate
  def calc_qam16_ber(cinr)
    1 - (1 - (2 * q(sqrt((3.0/15.0) * cinr.to_f))))**2
  end
  
  # calculates 64-QAM bit error rate
  def calc_qam64_ber(cinr)
    1 - (1 - (2 * q(sqrt((3.0/63.0) * cinr.to_f))))**2
  end
  
  # helper function for quickly referencing the origin of grid
  def origin
    [0,0]
  end
end
