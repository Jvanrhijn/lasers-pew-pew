classdef InputHandler < handle

  properties
    button_
    point_
    selected_obj_
    game_state_
  end

  methods

    function self = InputHandler(game_state)
      self.game_state_ = game_state;
    end

    function start(self)
      fig = gcf;
      ax = gca;
      ax.ButtonDownFcn = @(x, y)(self.wbdcb(x, y));
      fig.WindowScrollWheelFcn = @(x, y)(self.wbswcb(x, y));
    end

    function stop(self)
      fig = gcf;
      ax = gca;
      fig.WindowButtonMotionFcn = '';
      ax.ButtonDownFcn = '';
      fig.WindowScrollWheelFcn = '';
    end

  end

  methods(Access=protected)

    function wbdcb(self, src, callbackdata)
      % callback for mouse button down
      ax = self.game_state_.figure().CurrentAxes;
      cp = ax.CurrentPoint;
      point = Vec(cp(1, 1), cp(1, 2));
      c = self.get_selected_component(point);
      if isempty(c)
        return;
      end
      offset = point - c.location();
      fig = gcf;
      fig.WindowButtonMotionFcn = @(x, y)(self.wbmcb(offset, x, y));
      fig.WindowButtonUpFcn = @(x, y)(self.wbucb(x, y));
    end

    function wbmcb(self, offset, src, callbackdata)
      % callback for mouse movement
      ax = self.game_state_.figure().CurrentAxes;
      cp = ax.CurrentPoint;
      p = Vec(cp(1, 1), cp(1, 2));
      obj_copy = self.selected_obj_.shape.copy();
      obj_copy.move_to(p - offset);
      for c = self.game_state_.components()
        % if there is a collision after moving, 
        % move it back to the old location. Ugly as all hell.
        if c{1}.shape.collides(obj_copy) && c{1} ~= self.selected_obj_
          return;
        end
      end
      self.selected_obj_.move_to(p - offset);
    end

    function wbucb(self, src, callbackdata)
      % callback for mouse button up
      self.selected_obj_ = [];
      fig = gcf;
      ax = gca;
      fig.WindowButtonMotionFcn = '';
      fig.WindowButtonUpFcn = '';
    end

    function wbswcb(self, src, callbackdata)
      % callback for mouse scroll
      ax = self.game_state_.figure().CurrentAxes;
      cp = ax.CurrentPoint;
      p = Vec(cp(1, 1), cp(1, 2));
      c = self.get_selected_component(p);
      if isempty(c)
        return;
      end
      c.rotate(sign(callbackdata.VerticalScrollCount)*pi/50);
    end

    function comp = get_selected_component(self, point)
      comp = [];
      for c = self.game_state_.components()
        if c{1}.inside(point)
          self.selected_obj_ = c{1};
          comp = c{1};
          break;
        end
      end
    end

  end

end
