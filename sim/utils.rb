module Utils
  
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
  def path_loss(d, freq)
    d = d.abs/3.281   # convert to meters
    (44.9 - 6.55 * log10(BS_HEIGHT)) * log10(d/1000) + 45.5 + ( (35.46 - (1.1 * MS_HEIGHT) ) * log10(freq)) - 13.82 * log10(BS_HEIGHT) + (0.7 * MS_HEIGHT) + 3
  end
  
  # calculates distance between two cartesian coordinates
  def cartesian_dist(coord1, coord2)
    sqrt((coord1.x - coord2.x)**2 + (coord1.y - coord2.y)**2)
  end
  
  def bler_to_ber(block_size, bler)
    1 - (1 - bler)**(1/block_size)
  end
  
  def dB_to_watts(dB)
    10**(dB/10)
  end
  
  def watts_to_dB(watts)
    10 * log10(watts)
  end
  
  def q(x)
    0.5 * erfc(x / sqrt(2))
  end
end
