classdef Mirror < Component

  methods

    function self = Mirror(shape)
      self = self@Component(shape, Reflective());
    end

    function new_ray = interact_with(self, ray)
      [point, normal] = self.intersection_point(ray);
      % since this is a mirror, normal.dot(ray.direction) < 0
      % the incident angle is then
      angle_incident = pi - normal.angle(ray.direction());
      angle_reflect = self.interaction_type_.interact(angle_incident);
      % to find reflected ray, first calculate reflected
      % ray direction:
      ray_vec = ray.direction();
      slant = normal.angle_to_horizontal();
      normal.rotate(-slant);
      ray_vec.rotate(-slant);
      ray_vec_refl = Vec(-ray_vec.x, ray_vec.y);
      ray_vec_refl.rotate(slant);
      % to avoid intersecting the same surface again, move point
      % outward slightly
      normal.rotate(slant);
      f = eps*1;
      new_ray = Ray(point + Vec(normal.x*f, normal.y*f),...
                    ray_vec_refl.angle_to_horizontal());
    end

  end

end
