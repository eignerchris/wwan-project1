require 'client'
require 'utils'
require 'pp'
require 'environment'

# CELL_RADIUESES      = [0.5, 0.75, 1]     # miles
# BS_TX_POWERS        = [30, 40]           # dBm
# BS_ANT_HEIGHT       = 30                 # meters
# TX_BLOCK_SIZES      = [500, 1000, 1500]  # bytes
# TARGET_BLER         = [0.05, 0.10, 0.20]
# MS_ANT_HEIGHT       = 1.5                # meters
# NUM_USERS_PER_CELL = 25
# CARRIER_FREQS      = []

radius      = ARGV[0].to_f
power       = ARGV[1].to_f
block_size  = ARGV[2].to_f
target_bler = ARGV[3].to_f

clients = []
25.times do 
  angle = rand(120)
  clients << Client.new( radius * Math::cos(angle), radius * Math::sin(angle) )
end

e = Environment.new(radius, power, block_size, target_bler, clients)
e.simulate