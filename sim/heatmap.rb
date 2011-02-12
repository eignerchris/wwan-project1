require 'rubygems'
require 'gnuplot'

class Heatmap
  
  def initialize(xs, ys)
    @xs = xs
    @ys = ys
    pp @xs
    pp @ys
  end
  
  def generate
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.title  "Sector Heatmap"
        plot.xrange "[0:5000]"
        plot.yrange "[-5000:5000]"
        plot.data << Gnuplot::DataSet.new( [@xs, @ys] ) do |ds|
          ds.with = "points"
        end
      end
    end
  end
  
end