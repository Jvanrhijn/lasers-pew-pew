classdef BlackBody < Component

  methods

    function self = BlackBody(shape)
      self = self@Component(shape, Absorbent());
    end

    function new_ray = interact_with(self, ray)
      [point, normal] = self.shape.intersection_point(ray);
      new_ray = Ray(point, []); 
    end

  end

end
