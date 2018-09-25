classdef Component < handle

  properties(SetAccess=protected, GetAccess=protected)
    interaction_type_
  end

  properties(SetAccess=protected, GetAccess=public)
    shape
  end

  methods

    function self = Component(shape, int_type)
        self.interaction_type_ = int_type;
        self.shape = shape;
    end

    function loc = location(self)
      loc = self.shape.location();
    end

    function move_to(self, point)
      self.shape.move_to(point);
    end

    function self = rotate(self, angle)
      self.shape.rotate(angle);
    end
    
    function [point, normal] = intersection_point(self, ray)
      [point, normal] = self.shape.intersection_point(ray);
    end

    function in = inside(self, point)
      in = self.shape.inside(point);
    end

  end

  methods(Abstract)

    % Interaction method with a Ray object
    % @param ray Ray for which to compute interaction
    % @return new_ray Ray object that results from interaction
    interact_with(self, ray)

  end

end
