classdef LensFactory < ComponentFactory
  
  methods(Static)

    function c = build_circle(x, y, dims)
      s = Circle(Vec(x, y));
      s.set_dimensions(dims);
      c = Lens(s);
    end

    function t = build_triangle(x, y, dims)
      t = [];
    end

    function r = build_rectangle(x, y, dims)
      r = [];
    end
    
  end

end
