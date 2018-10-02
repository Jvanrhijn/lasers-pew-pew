classdef GameEngine < handle

  properties(GetAccess=private, SetAccess=private)
    level_node_
    levels_
    original_levels_
    graphics_
    max_reflections_ = 1000
    inp_
    state_
    timer_
    directory_
  end 

  methods
    
    % constructor
    function self = GameEngine(directory)
      self.graphics_ = Graphics();
      self.state_ = GameState.MAIN_MENU;
      self.inp_ = InputHandler(self);
      self.directory_ = directory;

      % setup game loop timer
      self.timer_ = timer();
      self.timer_.ExecutionMode = 'fixedSpacing';
      % refresh rate = 50 Hz (default)
      self.timer_.Period = 1/50;
      % callback: drawing the state
      self.timer_.TimerFcn = @(x, y)(self.draw_state());
    end
    
    function start(self)
      self.load_levels_disc();
      self.draw_state();
    end
    
    function stop(self)
      stop(self.timer_);
      self.inp_.stop();
      clear all;
      close all;
    end
    
    function load_levels_disc(self)
        levels = levels_setup(self.directory_);
        self.load_levels(levels);                
    end
    
    function load_levels(self, lvls)
      self.levels_ = LinkedList();
      for lvl = lvls
        self.levels_.append(lvl);
      end
      self.level_node_ = self.levels_.get_node(1);
    end

    function set_level(self, level_node)
      self.level_node_ = level_node;
    end
    
    function set_start_level(self, level)
        self.set_level(level);
        self.start_game();
    end

    function comp = components(self)
      comp = self.level_node_.value().components();
    end

    function fig = figure(self)
      fig = self.graphics_.get_figure();
    end

  end

  methods(Access=private)

    function start_game(self)
      self.state_ = GameState.LEVEL_PLAY;
      clf;
      self.inp_.start();
      start(self.timer_);
    end
    
    function start_selection(self)
      self.state_ = GameState.LEVEL_SELECT;
      clf;
      self.draw_state();
    end
    
    function set_refresh_rate(self,period)
        self.timer_.Period = period;
    end
    
    function start_level_selection(self,period)
        self.set_refresh_rate(period);
        self.start_selection()
    end

    function active_rays = trace_ray(self)
      % start at the starting point
      active_rays = [self.level_node_.value().starting_ray()];
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
      cla;
      switch self.state_
        case GameState.LEVEL_PLAY
          hold on;
          active_rays = self.trace_ray(); 
          if self.state_ ~= GameState.LEVEL_PLAY
              return
          end
          for c = self.level_node_.value().components_
            self.graphics_.draw(c{1});
          end
          self.graphics_.draw(active_rays);
          ax = gca;
          set(get(ax, 'Children'), 'HitTest', 'off', 'PickableParts', 'none');
        case GameState.MAIN_MENU
          clf;
          self.graphics_.draw_main_menu(@(~,~)(self.start_level_selection(self.graphics_.get_refresh_value())),...
                                        @(~, ~)(self.stop()));
        case GameState.LEVEL_SELECT
          self.timer_.stop();
          self.inp_.stop();
          clf;
          self.graphics_.draw_level_select(self.levels_, @self.set_start_level)
        case GameState.VICTORY
        % stop input handler and timer
        self.inp_.stop();
        stop(self.timer_);
        close all
        figure
        annotation('textbox',[.3 .5 .4 .1],'String','Congratulations, you finished the game!','FontSize',20,...
          'HorizontalAlignment','center','FitBoxToText','on','EdgeColor','none');
        annotation('textbox',[.3 .4 .4 .1],'String','Good for you.','FontSize',15,...
          'HorizontalAlignment','center','FitBoxToText','on','EdgeColor','none');
        annotation('textbox',[.3 .2 .4 .1],'String','Returning to main menu in a bit...','FontSize',15,...
          'HorizontalAlignment','center','FitBoxToText','on','EdgeColor','none');
        % play sound of victory
        % TODO fix this on Linux
%         sound_of_victory = load('gong');
%         sound(sound_of_victory.y,sound_of_victory.Fs)
        pause(5);
        close all;
        %reload levels
        self.load_levels_disc();
        %create new Graphics object
        self.graphics_ = Graphics();
        self.state_ = GameState.MAIN_MENU;
        % reset level to level 1
        self.level_node_ = self.levels_.get_node(1);
        self.draw_state();
        otherwise
          return;
        end
    end

    function comp = find_closest(self, ray)
      % finds the first component ray intersects with
      distance = inf;
      % set current component to 'null'
      cur_component = [];
      for c = self.level_node_.value().components()
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

    function next_level(self)
      self.level_node_ = self.level_node_.next();
      if isempty(self.level_node_)
        % to victory screen
        self.state_ = GameState.VICTORY;
        
        
        % draw screen
        self.draw_state();
      end
    end

    function set_state(self, state)
      self.state_ = state;
    end

  end

end
