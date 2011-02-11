module utils
  
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
  
end