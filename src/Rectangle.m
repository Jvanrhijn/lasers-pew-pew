classdef Rectangle < Shape

  properties(GetAccess=protected, SetAccess=protected)
    self.width_
    self.height_
    self.slant_ = 0
  end

  methods

    function set_dimensions(self, dims)
      self.width_ = dims(1);
      self.height_ = dims(2);
    end

    function intersects(self, ray)
      [r_slope, r_offset] = ray.line();
      [v1, v2, v3, v4] = self.vertices();
    end

  end

  methods(Access=private)
  
    function [v1, v2, v3, v4] = vertices(self)
      % constructs vectors of the four vertices of the rectangle
      % v1 is bottom left, rest follows counter-clockwise
      v1 = self.location_ + Vec(-self.width_/2, -self.height_/2);
      v2 = self.location_ + Vec(self.width_/2, -self.height_/2);
      v3 = self.location_ + Vec(self.width_/2, self.height_/2); 
      v4 = self.location_ + Vec(-self.width_/2, self.height_/2);
    end

  end

end
