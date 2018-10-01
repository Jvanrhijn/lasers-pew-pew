classdef Shape < handle

  properties(SetAccess = protected, GetAccess = protected)
    location_    
  end

  methods

    function self = Shape(location)
      self.location_ = location;
    end

  end

  methods(Abstract)

    % set shape dimensions
    % dims is a matlab array of dimensions, differs per shape
    % ex. circle has radius, rectangle width and height, etc
    % @param dims Array of dimensions
    set_dimensions(self, dims)

    % to interact with a ray, the ray must intersect
    % the shape's surface
    % @param ray Ray object for which to check intersection
    % @return int True if ray intersects this shape
    intersects(self, ray)

    % Compute the closest point of intersection between ray and
    % shape object, as well as normal vector of Shape at that
    % point
    % @param ray Ray for which to compute intersection
    % @return int Intersection point and the normal
    % vector there, in that order
    intersection_point(self, ray)

    % Checks whether a given point is located inside the shape
    % @param point Vec representing location of point
    % @return in True if point is inside shape
    inside(self, point)

    % Moves the shape to the given point
    % @param point Point to move shape to
    move_to(self, point)

    % rotate the shape counter-clockwise about its centroidal axis
    rotate(self, angle)

  end

  methods(Access=public)

    function loc = location(self)
      loc = self.location_;
    end

  end

  methods(Access=protected)

    function point = lines_intersection(self, slope1, offset1, slope2, offset2)
      % find the intersection of two lines defined by given slopes and offsets
      if slope1 == slope2
        point = Vec([], []);
      else
        x = (offset2 - offset1)/(slope1 - slope2);
        y = slope1*x + offset1;
        point = Vec(x, y);
      end
    end

  end

  methods(Access=protected)       

    function [slope, offset] = side(self, v1, v2)
      v_diff = v1 - v2;
      angle = v_diff.angle_to_horizontal();
      slope = tan(angle);
      offset = v1.y - slope*v1.x;
    end
        
  end
    
end
