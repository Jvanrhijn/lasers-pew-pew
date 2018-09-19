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
            y_ray = tan(ray.angle)*(x_ray - ray.start().x) - ray.start().y;
            
            side_onetwo = side(self, self.vertex_one_, self.vertex_two_);
            y_onetwo = slope*x_onetwo + offset;
            
            side_onethree = side(self, self.vertex_one, self.vertex_three);
            y_onethree = slope*x_onethree + offset;
            
            side_twothree = side(self, self.vertex_two, self.vertex_three);
            y_twothree = slope*x_twothree + offset;         
        end
    
        
    end
    
      
end
