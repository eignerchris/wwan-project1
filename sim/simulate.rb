require 'client'
require 'utils'
require 'pp'
require 'environment'
require 'heatmap'
require 'extensions'

# collect command line arguments
radius      = ARGV[0].to_f
power       = ARGV[1].to_f
block_size  = ARGV[2].to_f
target_bler = ARGV[3].to_f

# create 25 clients at random positions in a sector
clients = []
# 25.times do 
#   angle = rand(120)
#   length = rand(radius)
#   clients << Client.new( length * Math::cos(angle), length * Math::sin(angle) )
# end

# create environment object using command line args and random set of clients
e = Environment.new(radius, power, block_size, target_bler, clients)
e.simulate

