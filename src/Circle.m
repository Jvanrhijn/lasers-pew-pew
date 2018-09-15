classdef Circle < Shape

  properties
    radius_
  end

  methods

    function set_dimensions(self, dims)
      self.radius_ = dims(1);
    end

    function on = intersects(self, ray)
      on = false;
    end

  end

end
