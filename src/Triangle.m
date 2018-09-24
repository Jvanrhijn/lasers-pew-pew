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
      self.vertex_three_ = third_vertex(self.vertex_one, self.vertex_two, self.location);
      
    end
    
    function int = intersects(self, ray)
    % tests if there is an intersection on any side of the triangle
        
    int = intersects_side(self.vertex_one_, self.vertex_two_, ray)... 
        | intersects_side(self.vertex_one_, self.vertex_three_, ray)...
        | intersects_side(self.vertex_two_, self.vertex_three_, ray);
      
    end
    
    function [point, normal] = intertection_point(self, ray)
      % finds the point of intersection between the ray and the side of the triangle and it's normal
      % to this side
      if self.intersects(ray)
        
        intersections = []; %lege lijst met intersections
        
        % ray
        [ray_slope, ray_offset] = ray.line();
        
        % sorts the points of the triangle counter clockwise
        pointed_sorted = counter_clockwise_sort(self)
        
        % the counter-clockwise sides of the triangle
        vec_cc =  veccc(self);
        
        % the normal vectors of these sides
        normal = norm(self);
        
        % intersection on slope one
        [side_one_slope, side_one_offset] = side();
        intersection_onetwo = lines_intersection(ray_slope, ray_offset, side_onetwo_slope, side_onetwo_offset);
        intersections = [intersections intersection_onetwo];
        
        % intersection of slope two
        
        % intersection on slope three

        
      end
      
    end
    
    function in = inside(self, point)
      checks if a point lies in the triangle
      barypoint = self.barycentric(point);
      in = ~(barypoint.x < 0 | barypoint.y < 0 | barypoint.z < 0);
    end
    
    
  end
  
  methods(Access=private)
    
    function int_side = intersects_side(self, v1, v2, ray)
      % check if the ray intersects with a side between vertex 1 and 2
      
      % get slopes and offsets of lines that describe ray and side
      [ray_slope, ray_offset] = ray.line();
      [side_slope, side_offset] = side(v1, v2);
      
      % slope of ray = slope of side, so no intersection
      if ray_slope == side_slope 
        int_side = false;
        
      point_of_intersection = lines_intersection(ray_slope, ray_offset, side_slope, side_offset);
      
      % slope is inf (vertices have same x value)
      elseif v1.x == v2.x
        sorted_yvalue = customsort([v1, v2], @(v1, v2)(v1.y > v2.y)); %sorts y values from small to large
        int_side = sorted_yvalue.y(1) < point_of_intersection.y < sorted_yvalue.y(2);
      
      % slope is not inf
      else
        sorted_xvalue = custom_sort([v1 v2], @(v1, v2)(v1.x > v2.x)); %sorts x values from small to large
        int_side = sorted_xvalue.x(1) < point_of_intersection.x < sorted_xvalue.x(2);
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
    
    function pointed_sorted = counter_clockwise_sort(self)
      % sorts the points of the triangle counter clockwise
      % list of vertices of triangle
      points = [self.vertex_one_,...
                self.vertex_two_,...
                self.vertex_three_];
      
      % vectors that point from barycenter to vertices
      vec_baryone = self.vertex_one_ - self.location_;
      vec_barytwo = self.vertex_two_ - self.location_;
      vec_barythree = self.vertex_three_ - self.location_;
      
      % angles of these vectors to horizontal
      angles = [vec_baryone.angle_to_horizontal(),...
                vec_barytwo.angle_to_horizontal(),...
                vec_barythree.angle_to_horizontal()];
              
      [angles, OG_index] = sort(angles);  % angles sorted from small to large. The respective 
                                          % elements in OG_index are the previous locations of 
                                          % angles, before it was sorted
      
      % sorts points on triangle with respect to their angle (from above)
      % from small to large angle(counter-clockwise)
      point_sorted = [points(OG_index(1)), points(OG_index(2)), points(OG_index(3))];
    end
        
    function vec_cc = counter_clockwise_vectors(self)
      % finds the three counter-clockwise sides of the triangle, vec_cc =
      % [side_one, side_two, side_three]
      
      % sorts the points of the triangle counter clockwise
      pointed_sorted = counter_clockwise_sort(self)
            
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
      normal_one = vec_cc(1).cross(Vec(0, 0, 1))/vec_cc(1).norm();
      normal_two = vec_cc(2).cross(Vec(0, 0, 1))/vec_cc(2).norm();
      normal_three = vec_cc(3).cross(Vec(0, 0, 1))/vec_cc(3).norm();
      
      normal = [normal_one, normal_two, normal_three];
    end
    
  end
    
end
