# require everything in lib
Dir.glob("lib/*").each { |file| require file }

# require pretty print
require 'pp'

# set some constants used throughout simulator
BANDWIDTH_PER_SECTOR = 10     # MHz
CLIENTS_PER_SECTOR   = 25
DEGREE_STEP          = 2      # degrees between coords in grid
DISTANCE_STEP        = 50     # distance between coords in grid (ft.)
BS_HEIGHT            = 30     # meters
MS_HEIGHT            = 1.5    # meters

# collect command line arguments
radius      = ARGV[0].to_f * 5280  # convert fraction to ft.
power       = ARGV[1].to_f
block_size  = ARGV[2].to_f
target_bler = ARGV[3].to_f

# print info about simulation
puts "running simulator with following params:"
puts "   radius     : #{radius}"
puts "   power      : #{power}"
puts "   block_size : #{block_size}"
puts "   target_bler: #{target_bler}"

# create a new cell with input params
c = Cell.new(radius, power, block_size, target_bler, BS_HEIGHT, MS_HEIGHT)

# run cell simulation
c.simulate

# uncomment this line to generate a heatmap
# c.generate_heatmap

# print some VERY simple statistics about the simulation
# TODO: expand on these
c.stats