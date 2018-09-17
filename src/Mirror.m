classdef Mirror < Component

  properties
    
  end

  methods

    function self = Mirror(shape)
      self = self@Component(shape, Reflective());
    end

    function new_ray = interact_with(self, ray)
      [point, normal] = self.shape_.intersection_point(ray);
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
      new_ray = Ray(point, ray_vec_refl.angle_to_horizontal());
    end

  end

end
