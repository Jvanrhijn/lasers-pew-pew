classdef Triangle < Shape
    
  properties (SetAccess=private, GetAccess=private)
    vertex_one_
    vertex_two_
    vertex_three_
  end
    
  methods
    
    function set_dimensions(self, dims)
      self.vertex_one = dims(1);
      self.vertex_two = dims(2);
      self.vertex_three = dims(3);                    
    end
        
    function intersect = intersects(self, ray)
      [ray_slope, ray_offset] = ray.line();
      
      point_onetwo = lines_intersection(
      
      lines_intersection
    end
    
        
  end
    
end
