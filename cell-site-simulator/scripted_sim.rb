# require everything in lib
Dir.glob("lib/*.rb").each { |file| require file }

# require pretty print
require 'pp'

# set up some constants used throughout the simulator
BANDWIDTH_PER_SECTOR  = 10     # MHz
CLIENTS_PER_SECTOR    = 25
DEGREE_STEP           = 2      # degrees between coords in grid
DISTANCE_STEP         = 50     # distance between coords in grid (ft.)
BS_HEIGHT             = 30     # meters
MS_HEIGHT             = 1.5    # meters
MONTE_CARLO_SIM_TIMES = 15

# all input parameters
radiuses     = [0.5, 0.75, 1].map { |num| num * 5280 }
tx_powers    = [30, 40]
block_sizes  = [500, 1000, 1500]
target_blers = [0.05, 0.10, 0.20]

# generate all combinations of above parameters
args = radiuses.product tx_powers.product block_sizes.product target_blers

# append bs and ms height and flatten list of args
args.map! { |a| a.push([BS_HEIGHT, MS_HEIGHT]).flatten }

# for each combination of args, run the monte carlo sim
args.each  do |arg|
  bit_rates = []
  caps      = []
  fn        = arg.take(4).join('-')     # clean up filename
  f         = File.open("reports/#{fn}.txt", "w")  # setup file for report
  
  # run the simulator
  MONTE_CARLO_SIM_TIMES.times do |n|
    c = Cell.new(*arg)
    c.simulate
    
    # collect bit rate and capacity stats to be averaged below
    bit_rates << c.avg_bit_rate
    caps      << c.avg_capacity
  end
  
  # simple averages from set of simulations written to report file in reports dir
  f.puts "avg bit rate: #{bit_rates.flatten.sum/MONTE_CARLO_SIM_TIMES.to_f}"
  f.puts "avg capacity: #{caps.flatten.sum/MONTE_CARLO_SIM_TIMES.to_f}"
end
