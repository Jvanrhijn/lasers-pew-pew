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
            
            slope_side_onetwo = (self.vertex_two.y - self.vertex_one.y)/(self.vertex_two.x - self.vertex_one.x);
            y_side_onetwo = slope_side_onetwo*(x_onetwo - self.vertex_one.x) - self.vertex_one.y;
            
            slope_side_onethree = (self.vertex_three.y - self.vertex_one.y)/(self.vertex_three.x - self.vertex_one.x);
            y_side_onethree = slope_side_onethree*(x_onethree - self.vertex_one.x) - self.vertex_one.y;
            
            slope_side_twothree = (self.vertex_three.y - self.vertex_two.y)/(self.vertex_three.x - self.vertex_two.x);
            y_side_twothree = slope_side_twothree*(x_twothree - self.vertex_two.x) - self.vertex_two.y;
        end
                    
    end    
end
