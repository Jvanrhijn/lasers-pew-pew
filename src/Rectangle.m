classdef Rectangle < Shape

  properties(GetAccess=protected, SetAccess=protected)
    width_
    height_
    slant_ = 0
  end

  methods

    function set_dimensions(self, dims)
      self.width_ = dims(1);
      self.height_ = dims(2);
    end

    function int = intersects(self, ray)
      [xt, xb, yl, yr] = self.intersect_sides(ray);
      ray_moved = Ray(ray.start() - self.location_, ray.angle() - self.slant_);
      dir = ray_moved.direction();
      start = ray_moved.start();
      % tests for each side of the rectangle
      int = (-self.height_/2 < yl & yl < self.height_/2 ...
            & dir.dot(Vec(-1, 0)) < 0 & start.x < -self.width_/2)...
          | (-self.height_/2 < yr & yr < self.height_/2 ...
            & dir.dot(Vec(1, 0)) < 0 & start.x > self.width_/2)...
          | (-self.width_/2 < xt & xt < self.width_/2 ...
            & dir.dot(Vec(0, 1)) < 0 & start.y > self.height_/2)...
          | (-self.width_/2 < xb & xb < self.width_/2 ...
            & dir.dot(Vec(0, -1)) < 0 & start.y < -self.height_/2)...
          | self.inside(ray.start());
    end

    function [point, normal] = intersection_point(self, ray)
      if self.intersects(ray)
        ray_moved = Ray(ray.start() - self.location_, ray.angle() - self.slant_);
        [slope, offset] = ray_moved.line();
        [xt, xb, yl, yr] = self.intersect_sides(ray);
        % check all sides
        intersections = [];
        normals = [];
        if (-self.width_/2 < xt) & (xt < self.width_/2)
          intersections = [intersections, Vec(xt, slope*xt + offset)]; 
          normals = [normals, Vec(0, 1)];
        end
        if (-self.width_/2 < xb) & (xb < self.width_/2)
          intersections = [intersections, Vec(xb, slope*xb + offset)];
          normals = [normals, Vec(0, -1)];
        end
        if (-self.height_/2 < yl) & (yl < self.height_/2)
          intersections = [intersections, Vec((yl - offset)/slope, yl)];
          normals = [normals, Vec(-1, 0)];
        end
        if (-self.height_/2 < yr) & (yr < self.height_/2)
          intersections = [intersections, Vec((yr - offset)/slope, yr)];
          normals = [normals, Vec(1, 0)];
        end
        if length(intersections) ~= 2
          error('Ray intersecting rectangle in impossible way!');
        end
        distance = inf;
        for i=1:length(intersections)
          sep = ray_moved.start() - intersections(i);
          if ~self.inside(ray.start())
            if sep.norm() < distance
              distance = sep.norm();
              point = intersections(i) + self.location_;
              point.rotate(self.slant_);
              normal = normals(i).rotate(self.slant_);
            end
          else
            if normals(i).dot(ray_moved.direction()) > 0
              point = intersections(i) + self.location_;
              point.rotate(self.slant_);
              normal = normals(i).rotate(self.slant_);
            end
          end
        end
      else
        point = Vec([], []);
        normal = Vec([], []); % stub
      end
    end

    function move_to(self, point)
      self.location_ = point
    end

    function rotate(self, angle)
      self.slant_ = self.slant_ + angle;
    end

    function [w, h] = width_height(self)
      w = self.width_;
      h = self.height_;
    end

    function s = slant(self)
      s = self.slant_;
    end

    function in = inside(self, point)
      % rotate coordinates so rectangle has zero slant
      % and move coords so rectangle has centroid in origin
      rot_rect_loc = Vec(self.location_.x, self.location_.y).rotate(-self.slant_);
      point_rot = Vec(point.x, point.y).rotate(-self.slant_) - rot_rect_loc;
      in = (-self.width_/2 < point_rot.x) & (point_rot.x < self.width_/2)...
         & (-self.height_/2 < point_rot.y) & (point_rot.y < self.height_/2);
    end

  end
  
  methods(Access=private)

    function [xt, xb, yl, yr] = intersect_sides(self, ray)
      % return ray intersection with lines extending from rectangle sides
      % move coorindates so rectangle is in origin and not slanted
      ray_moved = Ray(ray.start() - self.location_, ray.angle() - self.slant_);
      [slope, offset] = ray_moved.line();
      % calculate intersection at sides
      yl = slope*(-self.width_/2) + offset;
      yr = slope*(self.width_/2) + offset;
      xt = (self.height_/2 - offset)/slope;
      xb = (-self.height_/2 - offset)/slope;
    end

  end

end
