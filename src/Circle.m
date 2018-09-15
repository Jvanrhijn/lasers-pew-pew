classdef Circle < Shape

  properties
    radius_
  end

  methods

    function set_dimensions(self, dims)
      self.radius_ = dims(1);
    end

    function on = intersects(self, ray)
      difference_vec = ray.start() - self.location_;
      distance = difference_vec.norm();
      if distance > self.radius_
        % only works if ray starts outside circle
        delta = asin(self.radius_/distance);
        theta = difference_vec.angle(Vec(1, 0));
        on = (-delta < ray.angle() - theta) & (ray.angle() - theta < delta);
      else
        on = true; 
      end
    end

  end

end
