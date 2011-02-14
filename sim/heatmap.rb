require 'rubygems'
require 'gnuplot'

class Heatmap
  
  # heatmap rgb gradient generated using: http://www.perbang.dk/rgbgradient/
  GRADIENT = ['ED2421', 'E22C1F', 'D7341D', 'CC3C1B', 'C2441A', 'B74C18', 'AC5416', 'A15D14', '976513',
              '8C6D11', '81750F', '767D0D', '6C850C', '618E0A', '569608', '4B9E06', '41A605', '36AE03',
              '2BB601', '21BE00']
  
  def initialize(coords, cinrs)
    @xs        = coords.collect { |coord| coord.first }
    @ys        = coords.collect { |coord| coord.last }
    @cinrs     = cinrs
  end
  
  def generate
    Gnuplot.open do |gp|
      Gnuplot::SPlot.new( gp ) do |plot|
        plot.title  "Sector Heatmap"
        plot.pm3d "map"
        plot.xrange "[#{@xs.min - 1000}:#{@xs.max + 1000}]"
        plot.yrange "[#{@ys.min - 1000}:#{@ys.max + 1000}]"
        plot.palette 'defined (-3 "blue", 0 "white", 1 "red")'
        plot.data << Gnuplot::DataSet.new( [@xs, @ys, @cinrs] ) do |ds|
          #ds.with = "pm3d"
          ds.with = "circles lc rgb variable"
        end
      end
    end
  end
  
end