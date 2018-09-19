classdef ComponentFactory

  methods
    function self = ComponentFactory()
    end
  end

  methods(Abstract)
    build_circle(x, y, dims); 
    build_triangle(x, y, dims); 
    build_rectangle(x, y, dims); 
  end

end
