classdef Shape
  properties
    location_    
  end

  methods

    function obj = Shape()

    end
    
    % to interact with a ray, the ray must intersect
    % the shape's surface
    function on = point_on_surface(self, point)
      on = false;
    end

    new_ray = function interact_with(self, obj)

    end
  

  end

end
