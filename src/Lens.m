classdef Lens < Component

  methods

    function self = Lens(shape)
      self = self@Component(shape, Refractive()); 
    end

    function new_ray = interact_with(self, ray)
      [point, normal] = self.intersection_point(ray);
      % rotate everything to x-axis
      slant = normal.angle_to_horizontal();
      normal_rot = Vec(normal.x, normal.y).rotate(-slant);
      ray_dir_rot = ray.direction().rotate(-slant);
      f = eps;
      % refraction is internal (inside to outside) if
      % normal.dot(ray.direction()) > 0
      if normal.dot(ray.direction()) < 0
        angle_in = pi - ray.direction().angle(normal);
        angle_refr = self.interaction_type_.interact(angle_in);
        % to avoid the new ray intersecting the shape again,
        % move the new ray starting point inwards
        point = point - Vec(normal.x*f, normal.y*f);
      else
        angle_in = ray.direction().angle(normal);
        angle_refr = self.interaction_type_.interact(-angle_in);
        point = point + Vec(normal.x*f, normal.y*f);
      end
      if angle_refr < 0
        new_direction = Vec(-ray_dir_rot.x, ray_dir_rot.y).rotate(slant);
        point = point - Vec(2*normal.x*f, 2*normal.y*f);
      else
        new_direction = Vec(cos(angle_refr)*sign(ray_dir_rot.x),...
                            sin(angle_refr)*sign(ray_dir_rot.y)).rotate(slant);
      end
      new_ray = Ray(point, new_direction.angle_to_horizontal());
    end

  end

end
