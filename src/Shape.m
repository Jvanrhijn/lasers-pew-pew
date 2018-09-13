classdef Shape < handle
  properties
    location_    
  end

  methods

    function self = Shape(location)
      self.location_ = location;
    end

    function set_dimensions(self, dims)
      % set shape dimensions
      % dims is a matlab array of dimensions, differs per shape
      % ex. circle has radius, rectangle width and height, etc
    end

    % to interact with a ray, the ray must intersect
    % the shape's surface
    function on = intersects(self, ray)
      on = false;
    end

  end

end
