classdef BlackBodyFactory < ComponentFactory

  methods(Static)
    
    function c = build_circle(x, y, dims)
      s = Circle(Vec(x, y));
      s.set_dimensions(dims);
      c = BlackBody(s);
    end

    function t = build_triangle(x, y, dims)
      s = Triangle(Vec(x, y));
      s.set_dimensions(dims);
      t = BlackBody(s);
    end

    function r = build_rectangle(x, y, dims)
      s = Rectangle(Vec(x, y));
      s.set_dimensions(dims);
      r = BlackBody(s);
    end

  end

end
