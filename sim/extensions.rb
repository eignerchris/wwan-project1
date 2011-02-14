class Array
  def to_gsplot
      f = ""

      if ( self[0].kind_of? Array ) then
        xs = self[0]
        ys = self[1]
        ds = self[2]

        xs.each_with_index do |xv, i|
          f << [ xs[i], ys[i], ds[i] ].join(" ") << "\n"
        end
      end

      f
    end
  
end