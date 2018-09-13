classdef Vec < handle

  properties
    x
    y
  end

  methods

    function val = dot(self, other)
      val = self.x*other.x + self.y*other.y;
    end

    function val = norm(self, other)
      val = sqrt(self.dot(self));
    end

    function normalize(self)
      norm = self.norm();
      self.x = self.x/norm;
      self.y = self.y/norm;
    end

    function val = angle(self, other)
      val = acos(self.dot(other)/(self.norm()*other.norm()));
    end

  end

end
