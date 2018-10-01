classdef Triangle < Shape
    
  properties (SetAccess=private, GetAccess=private)
    vertex_one_
    vertex_two_
    vertex_three_
  end
    
  methods
    
    function set_dimensions(self, dims)
      self.vertex_one_ = dims(1);
      self.vertex_two_ = dims(2);
      self.vertex_three_ = self.third_vertex(self.vertex_one_, self.vertex_two_, self.location_);
      disp(self.vertex_three_)
      
    end
    
    function int = intersects(self, ray)
    % tests if there is an intersection on any side of the triangle
    
    % sorts the points of the triangle counter clockwise
    point_sorted = counter_clockwise_sort(self, [self.vertex_one_,...
                                          self.vertex_two_,...
                                          self.vertex_three_]);

    % normal vectors of sides
    normal = norm(self);
    norm1 = normal(1);
    norm2 = normal(2);
    norm3 = normal(3);
    
    % direction of the ray
    direction_ray = direction(ray);
    
    int = (self.intersects_side(point_sorted(2), point_sorted(1), ray)...
        &&  norm1.dot(direction_ray) < 0)...
        || (self.intersects_side(point_sorted(3), point_sorted(2), ray)...
        && norm2.dot(direction_ray) < 0)...
        || (self.intersects_side(point_sorted(1), point_sorted(3), ray)...
        && norm3.dot(direction_ray) < 0);
      
    end
    
    function [point, normal] = intersection_point(self, ray)
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
        point_sorted = counter_clockwise_sort(self, [self.vertex_one_,...
                                                     self.vertex_two_,...
                                                     self.vertex_three_]);
        
        % the counter-clockwise sides of the triangle
        vec_cc =  counter_clockwise_vectors(self);
        
        % the normal vectors of these sides
        normal = norm(self);
        
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
          if ray.dot(int_norm(2)) > 0
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
      barypoint = self.barycentric(point);
      in = ~(barypoint.x < 0 | barypoint.y < 0 | barypoint.z < 0);
    end
    
    function move_to(self, point)
      % moves triangle to a given point
      
      % vector that points from old to new barycenter
      difference_vector = point - self.location;
      
      self.vertex_one_ = self.vertex_one_ + difference_vector;
      self.vertex_two_ = self.vertex_two_ + difference_vector;
      self.vertex_three_ = self.vertex.three + difference_vector;
      self.location_ = point;
    end
    
    function rotate(self, angle)
      % rotates the triangle
      
      % vectors that point from barycenter to vertices
      vec_baryone = self.vertex_one_ - self.location_;
      vec_barytwo = self.vertex_two_ - self.location_;
      vec_barythree = self.vertex_three_ - self.location_;
      
      % rotate these vectors 
      vec_baryone_rotate = vec_baryone.rotate(angle);
      vec_barytwo_rotate = vec_barytwo.rotate(angle);
      vec_barythree_rotate = vec_barythree.rotate(angle);
      
      % determine new vertex location
      self.vertex_one_ = self.location_ + vec_baryone_rotate;
      self.vertex_two_ = self.location_ + vec_barytwo_rotate;
      self.vertex_three_ = self.location_ + vec_barythree_rotate;
      
    end
            
  end
  
  methods(Access=private)
    
    function int_side = intersects_side(self, v1, v2, ray)
      % check if the ray intersects with a side between vertex 1 and 2
      
%       % sort vertices of input counter clockwise with respect to location
%       % of the triangle
%       v1_sort = v1 - self.location_;
%       v2_sort = v2 - self.location_;
%       sorted_v = self.counter_clockwise_sort([v1_sort, v2_sort]);
%       v1 = sorted_v(1);
%       v2 = sorted_v(2);
%       
%       % counter-clockwise vector of side between v1 and v2
%       vec_cc = 
      
      % ---- above this line is code to try and fix intersects-----------
      
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
    
    function v3 = third_vertex(self, v1, v2, location)
      % determines the third vertex of a triangle based on the first two
      % verticed and the location of it's center of mass
      x_comp = 3*location.x - v1.x - v2.x;
      y_comp = 3*location.y - v1.y - v2.y;
      v3 = Vec(x_comp, y_comp);
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
      point_sorted = counter_clockwise_sort(self, [self.vertex_one_,...
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