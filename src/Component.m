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

  end

  methods(Abstract)

    % Interaction method with a Ray object
    % @param ray Ray for which to compute interaction
    % @return new_ray Ray object that results from interaction
    interact_with(self, ray)

  end

end
