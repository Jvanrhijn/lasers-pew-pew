classdef Circle < Shape

  properties(SetAccess=private, GetAccess=public)
    radius
  end

  methods

    function set_dimensions(self, dims)
      self.radius = dims(1);
    end

    function on = intersects(self, ray)
      difference_vec = self.location_ - ray.start();
      distance = difference_vec.norm();
      if distance > self.radius
        % circle on x-axis
        circle = Circle(Vec(distance, 0));
        circle.set_dimensions(self.radius);
        % transformed ray
        angle = difference_vec.angle_to_horizontal();
        ray_tr = Ray(Vec(0, 0), ray.angle() - angle);
        delta = asin(circle.radius/distance);
        on = (-delta < ray_tr.angle()) & (ray_tr.angle() < delta);
      else
        on = true; 
      end
    end

  end

end
