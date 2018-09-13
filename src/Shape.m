classdef Shape < handle
  properties
    location_    
  end

  methods

    function obj = Shape(location)
      self.location_ = location;
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
