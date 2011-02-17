module Utils
  
  GAMMA = 3.52
  
  include Math
  
  # TODO: derive noise_power
  def snr(tx_power, noise_power)
    tx_power/noise_power
  end
  
  def qpsk_ber(ebn0_db)
    erfc(sqrt(0.5 * (10**ebn0_db)))
  end
  
  def qam16_ber(ebn0_db)
    3/2 * erfc(sqrt(1/10 * (10**ebn0_db)))
  end
  
  def qam64_ber(ebn0_db)
    7/4 * erfc(sqrt(1/42 * (10**ebn0_db))) - (49/64 * erfc(sqrt(1/42 * (10**ebn0_db)))**2)
  end
  
  # returns sum of first tier interferers for a given polar coordinate
  def  first_tier_interference(coord)
    i1 = sqrt( (2 * @radius + coord[0])**2 + (2 * @radius + coord[1])**2 )
    i2 = sqrt( (2 * @radius + coord[0])**2 + (2 * @radius + coord[1])**2 )
    i3 = sqrt( (2 * @radius + coord[0])**2 + (2 * @radius + coord[1])**2 )
    [i1, i2, i3].map { |val| val**(-GAMMA) }.inject { |r,x| r += x }
  end
  
  def polar_to_cartesian(polar_coord)
    [polar_coord.last * cos(polar_coord.first * (Math::PI/180)), polar_coord.last * sin(polar_coord.first * (Math::PI/180))]
  end
  
end