classdef TargetFactory < ComponentFactory

  methods(Static)

    function r = build_rectangle(x, y, dims)
      s = Rectangle(Vec(x, y));
      s.set_dimensions(dims);
      r = Target(s);
    end

  end

end
