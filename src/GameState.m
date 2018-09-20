classdef GameState < handle

  properties(GetAccess=private, SetAccess=private)
    level_nr_
    starting_ray_
    components_
    max_reflections_ = 1000
  end 

  methods
    
    % constructor
    function self = GameState()
      self.level_nr_ = 1;  
    end

    function set_starting_ray(self, x, y, angle)
      self.starting_ray_ = Ray(Vec(x, y), angle);
    end

    function active_rays = trace_ray(self)
      % start at the starting point
      active_rays = [self.starting_ray_];
      ray = self.starting_ray_; 
      num_reflections = 0;
      while num_reflections < self.max_reflections_
        comp = self.find_closest(ray);
        % if a component was hit, add new ray to list of active rays
        if ~isempty(comp)
          ray = comp.interact_with(ray);
          active_rays = [active_rays, ray];
          num_reflections = num_reflections + 1;
        else
          break;
        end
      end
    end

    function draw_state(self)
      clf;
      active_rays = self.trace_ray(); 
      g = Graphics();
      for c = self.components_
        c = c{1};
        g.draw(c);
      end
      g.draw(active_rays);
    end

    function cs = components(self)
      cs = self.components_; 
    end

    function comp = find_closest(self, ray)
      % finds the first component ray intersects with
      distance = inf;
      % set current component to 'null'
      cur_component = [];
      for c = self.components_
        c = c{1}; % honestly I hate matlab so much
        [point, n] = c.shape.intersection_point(ray);
        % if the current ray intersects this component
        if ~isempty(point.x)
          % compute distance between ray start and intersection
          vec_to_comp = ray.start() - point;
          dist_to_comp = vec_to_comp.norm();
          if dist_to_comp < distance
            % if this distance is smaller than all previous ones,
            % set component to current
            distance = dist_to_comp;
            cur_component = c;
          end
        end
      end
      comp = cur_component;
    end

    function add_component(self, component)
    self.components_{end+1} = component;
  end

  end

end
