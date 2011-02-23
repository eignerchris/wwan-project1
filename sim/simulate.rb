deps = ['utils', 'client', 'heatmap', 'sector', 'extensions', 'pp']
deps.each { |dep| require dep }

BANDWIDTH_PER_SECTOR     = 10     # MHz
NUM_CLIENTS              = 25
NUM_DEGREES              = 120    # degrees in sector
DEGREE_STEP              = 5      # degrees between coords in grid
DISTANCE_STEP            = 100    # distance between coords in grid (ft.)
BS_HEIGHT                = 30     # meters
MS_HEIGHT                = 1.5    # meters

# collect command line arguments
radius      = ARGV[0].to_f
power       = ARGV[1].to_f
block_size  = ARGV[2].to_f
target_ber  = ARGV[3].to_f

freq1 = 2505 
freq2 = 2515
freq3 = 2530

# create sector object using command line args and random set of clients

s1 = Sector.new(radius, power, block_size, target_ber, freq1)
s2 = Sector.new(radius, power, block_size, target_ber, freq2)
s3 = Sector.new(radius, power, block_size, target_ber, freq3)

[s1, s2, s3].each do |s|
  s.simulate
  s.print_report
end
