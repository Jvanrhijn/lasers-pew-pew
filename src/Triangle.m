classdef Triangle < Shape
    
  properties (SetAccess=private, GetAccess=public)
    vertex_one_
    vertex_two_
    vertex_three_
  end
    
  methods
    
    function set_dimensions(self, dims)
      error('Triangles not implemented');
      self.vertex_one_ = dims(1);
      self.vertex_two_ = dims(2);
      self.vertex_three_ = self.location_*3 - self.vertex_one_ - self.vertex_two_;
    end

    function c = copy(self)
      c = Triangle(self.location_);
      v1 = Vec(self.vertex_one_.x, self.vertex_one_.y);
      v2 = Vec(self.vertex_two_.x, self.vertex_two_.y);
      c.set_dimensions([v1, v2]);
    end

    function [x, y] = coordinates(self, res)
      res = int32(res);
      x = [linspace(self.vertex_one_.x, self.vertex_two_.x, res./4),...
           linspace(self.vertex_two_.x, self.vertex_three_.x, res./4),...
           linspace(self.vertex_three_.x, self.vertex_one_.x, res./4)];
      y = [linspace(self.vertex_one_.y, self.vertex_two_.y, res./4),...
           linspace(self.vertex_two_.y, self.vertex_three_.y, res./4),...
           linspace(self.vertex_three_.y, self.vertex_one_.y, res./4)];
    end
    
    function int = intersects(self, ray)
    % tests if there is an intersection on any side of the triangle
    % if ray starts inside triangle there must be an intersection
    if self.inside(ray.start())
      int = true;
    else
      % sorted points
      point_sorted = self.counter_clockwise_sort([self.vertex_one_, self.vertex_two_, self.vertex_three_]);
      point_one = point_sorted(1);
      point_two = point_sorted(2);
      point_three = point_sorted(3);

      % sorted vectors of sides
      vec_cc = self.counter_clockwise_vectors();

      % rotate sides so side lies on x axis

      % side 1
      vec_one_cc = -vec_cc(1);
      % angle to rotate the side around point 2 in such a manner that both points have same
      % x coordinate
      angle_one = -pi/2 - vec_one_cc.angle_to_horizontal();
      % rotate start of ray
      ray_point_one = ray.start() - point_two;
      rotated_ray_point_one = ray_point_one.rotate(angle_one);
      ray_start_one = point_two + rotated_ray_point_one;
      % rotate angle of ray
      ray_angle_one = ray.angle() + angle_one;
      ray_one = Ray(ray_start_one, ray_angle_one);
      dir_ray_one = ray_one.direction();

      % side 2
      vec_two_cc = -vec_cc(2);
      % angle to rotate the side around point 3 in such a manner that both points have same
      % x coordinate
      angle_two = -pi/2 - vec_two_cc.angle_to_horizontal();
      % rotate start of ray
      ray_point_two = ray.start() - point_three;
      rotated_ray_point_two = ray_point_two.rotate(angle_two);
      ray_start_two = point_three + rotated_ray_point_two;
      % rotate angle of ray
      ray_angle_two = ray.angle() + angle_two;
      ray_two = Ray(ray_start_two, ray_angle_two);
      dir_ray_two = ray_two.direction();

      % side 3
      vec_three_cc = -vec_cc(3);
      % angle to rotate the side around point 1 in such a manner that both points have same
      % x coordinate
      angle_three = -pi/2 - vec_three_cc.angle_to_horizontal();
      % rotate start of ray
      ray_point_three = ray.start() - point_one;
      rotated_ray_point_three = ray_point_three.rotate(angle_three);
      ray_start_three = point_one + rotated_ray_point_three;
      % rotate angle of ray
      ray_angle_three = ray.angle() + angle_three;
      ray_three = Ray(ray_start_three, ray_angle_three);
      dir_ray_three = ray_three.direction();

      int = ((self.intersects_side(point_two, point_one, ray))...
          && ((ray_start_one.x < point_two.x) || (dir_ray_one.x < 0))...
          && ((ray_start_one.x > point_two.x) || (dir_ray_one.x > 0)))...
          ...
          || ((self.intersects_side(point_three, point_two, ray))...
          && ((ray_start_two.x < point_three.x) || (dir_ray_two.x < 0))...
          && ((ray_start_two.x > point_three.x) || (dir_ray_two.x > 0)))...
          ...         
          || ((self.intersects_side(point_one, point_three, ray))...
          && ((ray_start_three.x < point_one.x) || (dir_ray_three.x < 0))...
          && ((ray_start_three.x > point_one.x) || (dir_ray_three.x > 0)));
    end
      
    end
    
    function [point, normal] = intersection_point(self, ray)
      point = Vec([], []);
      normal = Vec([], []);
      % finds the point of intersection between the ray and the side of the triangle and it's normal
      % to this side
      
      % check wether there's an intersection on the sides of the triangle
      if self.intersects(ray)
        
        % empty list that wil be filled with intersections and respective
        % normal vector
        int_norm = []; 
        
        % ray
        [ray_slope, ray_offset] = ray.line();
        
        % sorts the points of the triangle counter clockwise
        point_sorted = self.counter_clockwise_sort([self.vertex_one_,...
                                                     self.vertex_two_,...
                                                     self.vertex_three_]);
        
        % the counter-clockwise sides of the triangle
        vec_cc =  self.counter_clockwise_vectors();
        
        % the normal vectors of these sides
        normal = self.norm();
        
        % intersection on side one
        % check wether intersection is on side of triangle
        if self.intersects_side(point_sorted(1), point_sorted(1) + vec_cc(1), ray)
          % determinde intersection
          [side_one_slope, side_one_offset] = self.side(point_sorted(1), point_sorted(1) + vec_cc(1));
          intersection_one = self.lines_intersection(ray_slope, ray_offset, side_one_slope, side_one_offset);
          int_norm = [int_norm, intersection_one, normal(1)];
        end

        % intersection of side two
        % check wether intersection is on side of triangle
        if self.intersects_side(point_sorted(2), point_sorted(2) + vec_cc(2), ray)
          % determine intersection
          [side_two_slope, side_two_offset] = self.side(point_sorted(2), point_sorted(2) + vec_cc(2));
          intersection_two = self.lines_intersection(ray_slope, ray_offset, side_two_slope, side_two_offset);
          int_norm = [int_norm, intersection_two, normal(2)];
        end
        
        % intersection on side three
        % check wether intersection is on side of triangle
        if self.intersects_side(point_sorted(3), point_sorted(3) + vec_cc(3), ray)
          % determine intersection
          [side_three_slope, side_three_offset] = self.side(point_sorted(3), point_sorted(3) + vec_cc(3));
          intersection_three = self.lines_intersection(ray_slope, ray_offset, side_three_slope, side_three_offset);
          int_norm = [int_norm, intersection_three, normal(3)];
        end
        
        % case inside triangle
        if self.inside(ray.start())
          if ray.direction().dot(int_norm(2)) > 0
            point = int_norm(1);
            normal = int_norm(2);
          else
            point = int_norm(3);
            normal = int_norm(4);
          end
        
        % case outside triangle   
        else
          % distance from start of ray to point of intersection
          distance_one = ray.start() - int_norm(1);
          distance_two = ray.start() - int_norm(3);
          
          % check which point is closest to the start of the ray
          if distance_one < distance_two
            point = int_norm(1);
            normal = int_norm(2);
          else
            point = int_norm(3);
            normal = int_norm(4);
          end
        end
      end
    end
    
    function in = inside(self, point)
      % checks if a point lies in the triangle
      %barypoint = self.barycentric(point);
      %disp(barypoint);
      %in = ~(barypoint.x < 0 | barypoint.y < 0 | barypoint.z < 0);
      b1 = self.sgn(point, self.vertex_one_, self.vertex_two_) < 0;
      b2 = self.sgn(point, self.vertex_two_, self.vertex_three_) < 0;
      b3 = self.sgn(point, self.vertex_three_, self.vertex_one_) < 0;
      in = (b1 == b2) && (b2 == b3);
    end
    
    function move_to(self, point)
      % moves triangle to a given point
      
      % vector that points from old to new barycenter
      difference_vector = point - self.location;
      
      self.vertex_one_ = self.vertex_one_ + difference_vector;
      self.vertex_two_ = self.vertex_two_ + difference_vector;
      self.vertex_three_ = self.vertex_three_ + difference_vector;
      self.location_ = point;
    end
    
    function rotate(self, angle)
      % rotates the triangle
      vertices = [self.vertex_one_, self.vertex_two_, self.vertex_three_];
      % functional style chained mapping
      vec_bary_move = map(...
                        map(...
                          map(vertices, @(x)(x - self.location_)),...
                        @(x)(x.rotate(angle))),...
                      @(x)(x + self.location_));
      self.vertex_one_ = vec_bary_move(1);
      self.vertex_two_ = vec_bary_move(2);
      self.vertex_three_ = vec_bary_move(3);
    end
    
    function [ll, ur] = bounding_box(self)
      vertices = [self.vertex_one_, self.vertex_two_, self.vertex_three_];
      xs = map(vertices, @(x)(x.x));
      ys = map(vertices, @(y)(y.y));
      ll = Vec(min(xs), min(ys));
      ur = Vec(max(xs), max(ys));
    end
            
  end
  
  methods(Access=private)
    
    function int_side = intersects_side(self, v1, v2, ray)
      % check if the ray intersects with a side between vertex 1 and 2
      % get slopes and offsets of lines that describe ray and side
      [ray_slope, ray_offset] = ray.line();
      [side_slope, side_offset] = self.side(v1, v2);
      
      % point of intersection
      point_of_intersection = self.lines_intersection(ray_slope, ray_offset, side_slope, side_offset);
      
      % slope of ray = slope of side, so no intersection
      if ray_slope == side_slope 
        int_side = false;
            
      % slope is inf (vertices have same x value), use y value
      elseif v1.x == v2.x
        sorted_yvalue = customsort([v1, v2], @(v1, v2)(v1.y > v2.y)); %sorts y values from small to large
        int_side = sorted_yvalue(1).y < point_of_intersection.y && point_of_intersection.y < sorted_yvalue(2).y;
      
      % slope is not inf
      else
        sorted_xvalue = custom_sort([v1 v2], @(v1, v2)(v1.x > v2.x)); %sorts x values from small to large
        int_side = sorted_xvalue(1).x < point_of_intersection.x && point_of_intersection.x < sorted_xvalue(2).x;
      end 
    end
    
    function bvec = barycentric(self, point)
      % determines coordinates of point in barycentric coordinate system of
      % this triangle. Implementation from 
      % https://github.com/ssloy/tinyrenderer/wiki/Lesson-2:-Triangle-rasterization-and-back-face-culling
      side_onetwo = self.vertex_two_ - self.vertex_one_;
      side_onethree = self.vertex_three_ - self.vertex_one_;
      vec_point_one = self.vertex_one_ - point;
      
      first = Vec(side_onetwo.x, side_onethree.x, vec_point_one.x);
      second = Vec(side_onetwo.y, side_onethree.y, vec_point_one.y);
      
      u = first.cross(second);
      
      if abs(u.z) < 1 
        bvec = Vec(-1, 1, 1);
      else
        bvec = Vec(1 - (u.x + u.y)/u.z, u.y/u.z, u.x/u.z);
      end
      
    end

    function s = sgn(self, p1, p2, p3)
      s = (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
    end
    
    function point_sorted = counter_clockwise_sort(self, points)
      % sorts the points counter clockwith with respect to location of the
      % triangle
      vec_bary = map(points, @(x)(x - self.location_));
      angles = map(vec_bary, @(x)(x.angle_to_horizontal()));
      [angles, OG_index] = sort(angles);  % angles sorted from small to large. The respective 
                                          % elements in OG_index are the previous locations of 
                                          % angles, before it was sorted
      % sorts points on triangle with respect to their angle (from above)
      % from small to large angle(counter-clockwise)
      point_sorted = [];
      for i=1:length(points)
        point_sorted = [point_sorted, points(OG_index(i))];
      end
    end
        
    function vec_cc = counter_clockwise_vectors(self)
      % finds the three counter-clockwise sides of the triangle, vec_cc =
      % [side_one, side_two, side_three]
      
      % sorts the points of the triangle counter clockwise
      point_sorted = self.counter_clockwise_sort([self.vertex_one_,...
                                            self.vertex_two_,...
                                            self.vertex_three_]);
      % sides described by counter-clockwise vector
      side_one_CC = point_sorted(2) - point_sorted(1);
      side_two_CC = point_sorted(3) - point_sorted(2);
      side_three_CC = point_sorted(1) - point_sorted(3);
      
      vec_cc =[side_one_CC, side_two_CC, side_three_CC];
    end
    
    function normal = norm(self)
      % determines normal of the sides of triangle, normal = [normal_one, normal_two, normal_three]
      
      % the counter-clockwise sides of the triangle
      vec_cc =  counter_clockwise_vectors(self);
      
      % determines normal vectors
      normal_one = vec_cc(1).cross(Vec(0, 0, 1))./vec_cc(1).norm();
      normal_two = vec_cc(2).cross(Vec(0, 0, 1))./vec_cc(2).norm();
      normal_three = vec_cc(3).cross(Vec(0, 0, 1))./vec_cc(3).norm();
      
      normal = [normal_one, normal_two, normal_three];
    end
    
  end
    
end
