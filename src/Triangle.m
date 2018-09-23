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
        
        % intersection on slope onetwo
        [side_onetwo_slope, side_onetwo_offset] = side(self.vertex_one_, self.vertex_two_);
        intersection_onetwo = lines_intersection(ray_slope, ray_offset, side_onetwo_slope, side_onetwo_offset);
        
        % intersection of slope onethree
        [side_onethree_slope, side_onethree_offset] = side(self.vertex_one_, self.vertex_three_);
        intersection_onethree = lines_intersection(ray_slope, ray_offset, side_onethree_slope, side_onethree_offset);
        
        % intersection on slope onethree
        [side_twothree_slope, side_twothree_offset] = side(self.vertex_two_, self.vertex_three_);
        intersection_twothree = lines_intersection(ray_slope, ray_offset, side_twothree_slope, side_twothree_offset);
      end
      
    end
    
    function in = inside(self, point)
    
    
    end
    
    
  end
  
  methods(Access=private)
    
    function int_side = intersects_side(v1, v2, ray)
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
        sorted_yvalue = customsort([v1, v2], @(v1, v2)(v1.y > v2.y); %sorts y values from small to large
        int_side = sorted_yvalue.y(1) < point_of_intersection.y < sorted_yvalue.y(2);
      
      % slope is not inf
      else
        sorted_xvalue = custom_sort([v1 v2], @(v1, v2)(v1.x > v2.x)); %sorts x values from small to large
        int_side = sorted_xvalue.x(1) < point_of_intersection.x < sorted_xvalue.x(2);
      end 
    end
    
    function v3 = third_vertex(v1, v2, location)
      % determines the third vertex of a triangle based on the first two
      % verticed and the location of it's center of mass
      x_comp = 3*location.x - v1.x - v2.x;
      y_comp = 3*location.y - v1.y - v2.y;
      v3 = Vec(x_comp, y_comp);
    end
            
  end
    
end
