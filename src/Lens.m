classdef Lens < Component

  methods

    function self = Lens(shape)
      self = self@Component(shape, Refractive()); 
    end

    function new_ray = interact_with(self, ray)
      [point, normal] = self.shape_.intersection_point(ray);
      % rotate everything to x-axis
      slant = normal.angle_to_horizontal();
      normal_rot = Vec(normal.x, normal.y).rotate(-slant);
      ray_dir_rot = ray.direction().rotate(-slant);
      % refraction is internal (inside to outside) if
      % normal.dot(ray.direction()) > 0
      if normal.dot(ray.direction()) < 0
        angle_in = pi - ray.direction().angle(normal);
        angle_refr = self.interaction_type_.interact(angle_in);

      else
        angle_in = ray.direction().angle(normal);
        angle_refr = self.interaction_type_.interact(-angle_in);
      end
      new_direction = Vec(cos(angle_refr)*sign(ray_dir_rot.x),...
                          sin(angle_refr)*sign(ray_dir_rot.y)).rotate(slant);
      new_ray = Ray(point, new_direction.angle_to_horizontal());
    end

  end

end
