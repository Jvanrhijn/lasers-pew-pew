classdef LensFactory < ComponentFactory
  
  methods(Static)

    function c = build_circle(x, y, dims)
      s = Circle(Vec(x, y));
      s.set_dimensions(dims);
      c = Lens(s);
    end

    function t = build_triangle(x, y, dims)
      s = Triangle(Vec(x, y));
      s.set_dimensions(dims);
      t = Lens(s);
    end

    function r = build_rectangle(x, y, dims)
      s = Rectangle(Vec(x, y));
      s.set_dimensions(dims);
      r = Lens(s);
    end
    
  end

end
