# main program
require 'env'
require 'client'

# CELL_RADIUESES      = [0.5, 0.75, 1]     # miles
# BS_TX_POWERS        = [30, 40]           # dBm
# BS_ANT_HEIGHT       = 30                 # meters
# TX_BLOCK_SIZES      = [500, 1000, 1500]  # bytes
# TARGET_BLER         = [0.05, 0.10, 0.20]
# MS_ANT_HEIGHT       = 1.5                # meters
# NUM_USERS_PER_CELL = 25
# CARRIER_FREQS      = []

radius      = ARGV[1]
power       = ARGV[2]
block_size  = ARGV[3]
target_bler = ARGV[4]

clients = []
25.times { clients << Client.new rand(radius * 2), rand(radius * 2) }

e = Environment.new(radius, power, block_size, target_bler, clients)
#e.simulate