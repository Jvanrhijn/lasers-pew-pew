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

    function [int, nvec] = intersection_point(self, ray)
      if self.intersects(ray)
        % equation corresponding to ray:
        % y = mx + b
        m = tan(ray.angle());
        ray_start = ray.start();
        b = ray_start.y - ray_start.x*m;
        xc = self.location_.x;
        yc = self.location_.y;
        % circle top half has equation 
        % y - yc = sqrt(r^2 - (x-xc)^2)
        % setting equation of line equal to this and solving for x-xc:
        xmxc = roots([(m+1)^2, 2*m*(b-yc), (b-yc)^2-self.radius^2]);
        % this returns the intersections of the line and upper half of the circle
        % If there is a single real intersection xi, the other intersection with the circle
        % is at x = -xi
        xmxc = xmxc(xmxc == real(xmxc));
        if length(xmxc) == 1
          x_intersect = [xmxc -xmxc] + xc;
        else
          x_intersect = xmxc + xc;
        end
        y_intersect = m*x_intersect + b;
        % only keep the intersection closest to the ray start
        int_1 = Vec(x_intersect(1), y_intersect(1));
        int_2 = Vec(x_intersect(2), y_intersect(2));
        sep_1 = int_1 - ray_start;
        sep_2 = int_2 - ray_start;
        if sep_1.norm() < sep_2.norm()
          int = int_1;
        else
          int = int_2;
        end
        % normal vector at intersection:
        % calculate angular coordinate in circle coordinate system
        theta = atan2(int.y - yc, int.x - xc);
        nvec = Vec(cos(theta), sin(theta));
      else
        int = Vec([], []);
        nvec = Vec([], []);
      end
    end

  end

end
