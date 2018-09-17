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
    % @return int Cell array containing intersection point and the normal
    % vector there
    intersection_point(self, ray)

  end

end
