classdef Level < handle

  properties
    components_
    level_id_
    starting_ray_
  end

  methods

    function self = Level()
      self.level_id_ = [];
      self.starting_ray_ = [];
      self.components_ = {};
    end

    function set_id(self, id)
      self.level_id_ = id;
    end

    function id = get_id(self)
      id = self.level_id_;
    end

    function comp = components(self)
      comp = self.components_;
    end

    function add_component(self, comp)
      self.components_{end+1} = comp;
    end

    function set_starting_ray(self, x, y, angle)
      self.starting_ray_ = Ray(Vec(x, y), angle);
    end

    function ray = starting_ray(self)
      ray = self.starting_ray_;
    end

  end

end
