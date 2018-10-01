classdef Graphics < handle

  properties(SetAccess=private, GetAccess=private)
    fig_;
    xlims_ = [0, 1];
    ylims_ = [0, 1];
    potato_value_;
  end

  methods

    function self = Graphics()
      self.fig_ = figure;
      self.set_range([0, 1, 0, 1]);
    end

    function set_range(self, ranges)
      axis(ranges);
      self.xlims_ = ranges(1:2);
      self.ylims_ = ranges(3:4);
      dx = self.xlims_(2) - self.xlims_(1);
      dy = self.ylims_(2) - self.ylims_(1);
      dz = 1;
      pbaspect([dx, dy, dz]/max([dx, dy, dz]));
      xticks(0:0.1:1);
      yticks(0:0.1:1);
      title('Drag and rotate objects to hit the target!')
    end

    function draw_main_menu(self, start_button_callback, quit_callback, potato_callback)
      cla; clf;
      titlebox = annotation('textbox',[.3 .8 .4 .1],'String','Lasers, pew pew!','FontSize',20,...
          'HorizontalAlignment','center','FitBoxToText','on');
      start_button = uicontrol('Parent', self.fig_,...
            'String', 'Start game (50 Hz)', 'Units', 'normalized',...
            'Position', [0.5 0.5 0.3 0.1]);
      start_button.Callback = start_button_callback;
      quit_button = uicontrol('Parent', self.fig_,...
            'String', 'Quit', 'Units', 'normalized',...
            'Position', [0.5 0.4 0.3 0.1]);
      quit_button.Callback = quit_callback;
      potato_slider = uicontrol('Style', 'Slider', 'Min', 10, 'Max', 50, 'Value', 25,...
          'Units', 'normalized', 'Position', [0.5 0.1 0.3 0.1]);
      potato_button = uicontrol('Parent', self.fig_,...
            'String', ['Potato mode (10 to 50 Hz)'], 'Units', 'normalized',...
            'Position', [0.5 0.2 0.3 0.1]);
      potato_button.Callback = potato_callback;
      self.potato_value_ = potato_slider.Value;
      instructionbox = annotation('textbox', 'Position', [.1 .3 .4 .3],...
            'String', 'Click and drag to move objects, scroll to rotate objects',...
            'FontSize', 12, 'HorizontalAlignment', 'center',...
            'VerticalAlignment', 'top', ...
            'FitBoxToText', 'off', 'Units', 'normalized', 'EdgeColor', 'none');
    end
    
    function draw_level_select(self,level_list,set_start_level)
      titlebox = annotation('textbox', [.2, .8, .6, .1],...
                            'String', 'Level selection',...
                            'FontSize', 20, 'HorizontalAlignment', 'center',...
                            'FitBoxToText','on');
       level_button = {};
       k = 0;
       for i = 1:level_list.length()
        level = level_list.get_node(i);
        level_button{i} = uicontrol('Parent', self.fig_,...
            'String', num2str(i), 'Units', 'normalized',...
            'Position', [0.1*mod(i, 8), 0.5-0.1*k, 0.1, 0.1]);
        level_button{i}.Callback = @(~, ~)(set_start_level(level));
        if mod(i, 8) == 0
          k= k + 1;
        end
      end
    end
    
    function pv = get_potato_value(self)
        period = self.potato_value_;
        pv = 1/period;        
    end
    
    function draw(self, obj)
      if isa(obj, 'Mirror')
        self.draw_mirror(obj);
      elseif isa(obj, 'Lens')
        self.draw_lens(obj);
      elseif isa(obj, 'Target')
        self.draw_target(obj);
      elseif isa(obj, 'BlackBody')
        self.draw_blackbody(obj);
      elseif isa(obj, 'Ray')
        self.draw_ray_set(obj);
      else
        error('Invalid data type for drawing');
      end
    end

    function draw_target(self, target)
      [x, y] = target.shape.coordinates(50);
      self.draw_shape(x, y, 'red', 'red');
    end

    function draw_blackbody(self, blackbody)
      [x, y] = blackbody.shape.coordinates(50);
      self.draw_shape(x, y, 'black', [0, 0, 0]);
    end

    function draw_mirror(self, mirror)
      [x, y] = mirror.shape.coordinates(50);
      self.draw_shape(x, y, 'cyan', [0.5, 0.5, 0.5]);
    end

    function draw_lens(self, lens)
      [x, y] = lens.shape.coordinates(50);
      self.draw_shape(x, y, 'cyan', 'cyan');
    end

    function draw_shape(self, x, y, edge_color, fill_color)
      fill(x, y, fill_color);
      line('Xdata', x, 'Ydata', y, 'Color', edge_color, 'LineWidth', 2);
    end

    function draw_ray_set(self, rays)
      xs = zeros(1, length(rays));
      ys = zeros(1, length(rays));
      for i=1:length(rays)
        vertex = rays(i).start();
        xs(i) = vertex.x;
        ys(i) = vertex.y;
      end
      plot(xs, ys, 'r', 'LineWidth', 2);
      self.draw_ray(rays(end));
      self.set_range([self.xlims_, self.ylims_]);
    end

    function draw_ray(self, ray)
      angle = ray.angle();
      if isempty(angle)
        return;
      end
      start = ray.start();
      [m, b] = ray.line();
      if (-pi/2 <= angle) & (angle < pi/2)
        xmin = start.x;
        xmax = self.xlims_(2);
      else
        xmin = self.xlims_(1);
        xmax = start.x;
      end
      xs = [xmin, xmax];
      ys = m*xs + b;
      plot(xs, ys, 'r', 'LineWidth', 2);
      self.set_range([self.xlims_, self.ylims_]);
    end

    function fig = get_figure(self)
      fig = self.fig_;
    end

    function ax = get_axes(self)
      ax = self.fig_.CurrentAxes;
    end

  end

end
