classdef Rectangle < Shape

  properties(GetAccess=protected, SetAccess=protected)
    width_
    height_
    slant_ = 0
  end

  methods

    function c = copy(self)
      c = Rectangle(Vec(self.location_.x, self.location_.y));
      c.set_dimensions([self.width_, self.height_]);
      c.rotate(self.slant_);
    end

    function set_dimensions(self, dims)
      self.width_ = dims(1);
      self.height_ = dims(2);
    end

    function [x, y] = coordinates(self, res)
      res = int32(res);
      [w, h] = self.width_height(); 
      s = self.slant();
      p = self.location();
      x = [linspace(-1, 1, res./4), ones(1, res./4),...
           linspace(1, -1, res./4), -ones(1, res./4)]*w/2;
      y = [-ones(1, res./4), linspace(-1, 1, res./4),...
           ones(1, res./4), linspace(1, -1, res./4)]*h/2;
      xrot = x*cos(s) - y*sin(s);
      yrot = x*sin(s) + y*cos(s);
      x = xrot + p.x;
      y = yrot + p.y;
    end

    function int = intersects(self, ray)
      [xt, xb, yl, yr] = self.intersect_sides(ray);
      ray_moved_start = ray.start() - self.location_;
      ray_moved = Ray(ray_moved_start.rotate(-self.slant_), ray.angle() - self.slant_);
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
      point = Vec([], []);
      normal = Vec([], []); 
      if self.intersects(ray)
        ray_moved_start = ray.start() - self.location_;
        ray_moved = Ray(ray_moved_start.rotate(-self.slant_), ray.angle() - self.slant_);
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
              point = intersections(i);
              point = point.rotate(self.slant_) + self.location_;
              normal = normals(i).rotate(self.slant_);
            end
          else
            if normals(i).dot(ray_moved.direction()) > 0
              point = intersections(i);
              point = point.rotate(self.slant_) + self.location_;
              normal = normals(i).rotate(self.slant_);
            end
          end
        end
      end
    end

    function move_to(self, point)
      self.location_ = point;
    end

    function rotate(self, angle)
      self.slant_ = mod(self.slant_ + angle, pi);
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

    function [ll, ur] = bounding_box(self)
      % non-rotated, non-moved x coordinates
      xs = [-self.width_/2, self.width_/2, self.width_/2, -self.width_/2];
      ys = [-self.height_/2, -self.height_/2, self.height_/2, self.height_/2];
      xs_rot = xs*cos(self.slant_) - ys*sin(self.slant_);
      ys_rot = xs*sin(self.slant_) + ys*cos(self.slant_);
      ll = Vec(min(xs_rot), min(ys_rot)) + self.location_;
      ur = Vec(max(xs_rot), max(ys_rot)) + self.location_;
    end

  end
  
  methods(Access=private)

    function [xt, xb, yl, yr] = intersect_sides(self, ray)
      % return ray intersection with lines extending from rectangle sides
      % move coorindates so rectangle is in origin and not slanted
      ray_moved_start = ray.start() - self.location_;
      ray_moved = Ray(ray_moved_start.rotate(-self.slant_), ray.angle() - self.slant_);
      [slope, offset] = ray_moved.line();
      % calculate intersection at sides
      yl = slope*(-self.width_/2) + offset;
      yr = slope*(self.width_/2) + offset;
      xt = (self.height_/2 - offset)/slope;
      xb = (-self.height_/2 - offset)/slope;
    end

  end

end

