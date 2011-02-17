['client', 'utils', 'heatmap', 'environment', 'pp'].each { |lib| require lib }

# collect command line arguments
radius      = ARGV[0].to_f
power       = ARGV[1].to_f
block_size  = ARGV[2].to_f
target_bler = ARGV[3].to_f

# create environment object using command line args and random set of clients
e = Environment.new(radius, power, block_size, target_bler)
e.simulate

