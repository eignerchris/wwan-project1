module Utils
  
  GAMMA          = 3.52
  
  include Math
  
  # TODO: derive noise_power
  def snr(tx_power, noise_power)
    tx_power/noise_power
  end
  
  # TODO: fill out this function
  def cinr(gamma)
  end
  
  # TODO: lookup table for mcs? 
  def opt_mcs
  end
  
  def avg_sector_cap
  end
  
  # returns sum of first tier interferers for a given polar coordinate
  # args:
  #   - coord of the form [angle, distance]
  def  first_tier_interference(coord)
    i1 = sqrt( (2 * coord[1] + coord[1] * cos(coord[0]))**2 + (coord[1] * sin(coord[0]))**2 )
    i2 = sqrt( (2 * coord[1] + coord[1] * cos(coord[0]))**2 + (coord[1] * sin(coord[0]))**2 )
    i3 = sqrt( (2 * coord[1] + coord[1] * sin(coord[0]))**2 + (coord[1] * cos(coord[0]))**2 )
    [i1, i2, i3].map { |val| val**(-GAMMA) }.inject { |r,x| r += x }
  end
end