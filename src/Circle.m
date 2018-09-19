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
      ray_start = ray.start();
      sep_vec = ray_start - self.location_;
      xc = self.location_.x;
      yc = self.location_.y;
      if self.intersects(ray)
        [m, b] = ray.line();
        % circle top half has equation 
        % y - yc = sqrt(r^2 - (x-xc)^2)
        % setting equation of line equal to this and solving for x-xc:
        k = b - yc + m*xc;
        xmxc = roots([m^2+1, 2*m*k, k^2-self.radius^2]);
        % returns intersections of line and upper half of circle
        % If there is a single real intersection xi, the other intersection with the circle
        % is at x = -xi
        xmxc = xmxc(xmxc == real(xmxc));
        if length(xmxc) == 1
          x_intersect = [xmxc, -xmxc] + xc;
        elseif length(xmxc) == 0
          % edge case: if radius hits circle head on, roots might return zero solutions
          x_intersect = [xc - self.radius, xc + self.radius];
        else
          x_intersect = xmxc + xc;
        end
        y_intersect = m*x_intersect + b;
        % only keep the intersection closest to the ray start
        int_1 = Vec(x_intersect(1), y_intersect(1));
        int_2 = Vec(x_intersect(2), y_intersect(2));
        % because matlab is terrible, we have to name these things before calling norm on them
        sep_1 = int_1 - ray_start;
        sep_2 = int_2 - ray_start;
        % ray starts outside circle and ray starts inside
        if sep_vec.norm() > self.radius;
          if sep_1.norm() < sep_2.norm()
            int = int_1;
          else
            int = int_2;
          end
          % normal vector at intersection:
          % calculate angular coordinate in circle coordinate system
          nvec = self.normal_vector(int);
        else
          % if ray starts inside circle, we must have the intersection 
          % for which ray_vector.dot(normal_vector) > 0
          nvec1 = self.normal_vector(int_1);
          nvec2 = self.normal_vector(int_2);
          if ray.direction().dot(nvec1) > 0
            int = int_1;
            nvec = nvec1;
          else
            int = int_2;
            nvec = nvec2;
          end
        end
      else
        int = Vec([], []);
        nvec = Vec([], []);
      end
    end

    function in = inside(self, point)
      sep = self.location_ - point;
      in = sep.norm() <= self.radius;
    end

    function move_to(self, point)
      self.location_ = point;
    end

    function nvec = normal_vector(self, point)
      line = point - self.location_;
      theta = atan2(line.y, line.x);
      nvec = Vec(cos(theta), sin(theta));
    end

    function loc = location(self)
      loc = self.location_
    end

  end

end
