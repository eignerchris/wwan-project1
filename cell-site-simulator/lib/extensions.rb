class Array
  
  class NotCartesianCoordException < Exception; end
  
  def sum
    self.inject { |r,x| r += x }
  end
  
  def x
    if self.length == 2
      return self.first
    else
      raise NotCartesianCoordException
    end
  end
  
  def y
    if self.length == 2
      return self.last
    else
      raise NotCartesianCoordException
    end
  end
end