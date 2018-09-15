classdef Circle < Shape

  properties
    radius_
  end

  methods

    function set_dimensions(self, dims)
      self.radius_ = dims(1);
    end

    function on = intersects(self, ray)
      difference_vec = self.location_ - ray.start();
      distance = difference_vec.norm();
      if distance > self.radius_
        % circle on x-axis
        circle = Circle(Vec(distance, 0));
        circle.set_dimensions(self.radius_);
        % transformed ray
        angle = difference_vec.angle_to_horizontal();
        ray_tr = Ray(Vec(0, 0), ray.angle() - angle);
        delta = asin(circle.radius()/distance);
        on = (-delta < ray_tr.angle()) & (ray_tr.angle() < delta);
      else
        on = true; 
      end
    end

    % getters
    function r = radius(self)
      r = self.radius_;
    end

  end

end
