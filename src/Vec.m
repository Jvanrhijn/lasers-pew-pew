classdef Vec < handle
  % A class representing a vector in a 2D plane
  % exposes convenient interface for common
  % vector operations
  properties(SetAccess=protected)
    x
    y
  end

  methods

    % constructor
    function self = Vec(x, y)
      self.x = x;
      self.y = y;
    end

    function val = dot(self, other)
      val = self.x*other.x + self.y*other.y;
    end

    function val = norm(self)
      val = sqrt(self.dot(self));
    end

    function self = normalize(self)
      norm = self.norm();
      self.x = self.x/norm;
      self.y = self.y/norm;
    end

    function val = angle(self, other)
      val = acos(self.dot(other)/(self.norm()*other.norm()));
    end

    function val = angle_to_horizontal(self)
      % return angle to horizontal, between -pi, pi
      val = atan2(self.y, self.x);
    end

    function self = rotate(self, angle)
      x = self.x*cos(angle) - self.y*sin(angle);
      y = self.x*sin(angle) + self.y*cos(angle);
      self.x = x;
      self.y = y;
    end

    % operator overloads
    function vec = plus(self, other)
      vec = Vec(self.x+other.x, self.y+other.y);
    end

    function vec = minus(self, other)
      vec = Vec(self.x-other.x, self.y-other.y);
    end

  end

end
