classdef GameEngine < handle

  properties(GetAccess=private, SetAccess=private)
    level_
    levels_
    graphics_;
    max_reflections_ = 1000
  end 

  methods
    
    % constructor
    function self = GameEngine()
      self.graphics_ = Graphics();
    end

    function start(self)
      inp = InputHandler(self);
      inp.start();
    end

    function set_level(self, level)
      self.level_ = level;
    end

    function active_rays = trace_ray(self)
      % start at the starting point
      active_rays = [self.level_.starting_ray()];
      ray = active_rays(end);
      num_reflections = 0;
      while num_reflections < self.max_reflections_
        comp = self.find_closest(ray);
        % if a component was hit, add new ray to list of active rays
        if ~isempty(comp)
          ray = comp.interact_with(ray);
          active_rays = [active_rays, ray];
          num_reflections = num_reflections + 1;
          if isempty(ray.angle())
            if (isa(comp, 'Target'))
              self.next_level()
            end
            break;  % ray has hit blackbody or target
          end
        else
          break;
        end
      end
    end

    function draw_state(self)
      clf;
      active_rays = self.trace_ray(); 
      g = Graphics();
      for c = self.level_.components_
        g.draw(c{1});
      end
      g.draw(active_rays);
    end

    function comp = find_closest(self, ray)
      % finds the first component ray intersects with
      distance = inf;
      % set current component to 'null'
      cur_component = [];
      for c = self.level_.components()
        [point, n] = c{1}.intersection_point(ray);
        % if the current ray intersects this component
        if ~isempty(point.x)
          % compute distance between ray start and intersection
          vec_to_comp = ray.start() - point;
          dist_to_comp = vec_to_comp.norm();
          if dist_to_comp < distance
            % if this distance is smaller than all previous ones,
            % set component to current
            distance = dist_to_comp;
            cur_component = c{1};
          end
        end
      end
      comp = cur_component;
    end

    function fig = figure(self)
      fig = self.graphics_.get_figure();
    end

    function comp = components(self)
      comp = self.level_.components();
    end

    function load_levels(self, lvls)
      self.levels_ = lvls; 
    end

    function next_level(self)
      if self.level_.get_id() == length(self.levels_)
        title('Congratulations, you finished the game!');
        sound_of_victory = load('gong');
        sound(sound_of_victory.y,sound_of_victory.Fs)
        return;
      end
      self.level_ = self.levels_(self.level_.get_id()+1);
      self.draw_state();
      
    end

  end

end
