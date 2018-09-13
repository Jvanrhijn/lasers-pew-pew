classdef Shape
  properties
    location_    
  end

  methods

    function obj = Shape(obj, location)
      obj.location_ = location;
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

    new_ray = function interact_with(self, obj)

    end
  

  end

end
