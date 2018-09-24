classdef InputHandler < handle

  properties
    state_
    button_
    point_
    selected_obj_
    game_state_
  end

  methods

    function self = InputHandler(game_state)
      self.state_ = InputState.IDLE;
      self.game_state_ = game_state;
    end

    function start(self)
      self.game_state_.draw_state();
      fig = gcf;
      fig.WindowButtonDownFcn = @(x, y)(self.wbdcb(x, y));
      fig.WindowScrollWheelFcn = @(x, y)(self.wbswcb(x, y));
    end

    function get_input(self)
      [x, y, button] = ginput(1);
      self.point_ = Vec(x, y);
      self.button_ = button;
    end

    function rotate_current(self, amount)
      self.selected_obj_.shape.rotate(-sign(amount)*pi/50);
      self.game_state_.draw_state();
    end

    function wbdcb(self, src, callbackdata)
      ax = gca;
      cp = ax.CurrentPoint;
      xinit = cp(1, 1);
      yinit = cp(1, 2);
      point = Vec(cp(1, 1), cp(1, 2));
      c = self.get_selected_component(point);
      if isempty(c)
        return;
      end
      src.WindowButtonMotionFcn = @(x, y)(self.wbmcb(x, y));
      src.WindowButtonUpFcn = @(x, y)(self.wbucb(x, y));
    end

    function wbmcb(self, src, callbackdata)
      ax = gca;
      cp = ax.CurrentPoint;
      p = Vec(cp(1, 1), cp(1, 2));
      self.selected_obj_.shape.move_to(p);
      self.game_state_.draw_state();
    end

    function wbucb(self, src, callbackdata)
      src.WindowButtonMotionFcn = '';
      src.WindowButtonUpFcn = '';
    end

    function wbswcb(self, src, callbackdata)
      ax = gca;
      cp = ax.CurrentPoint;
      p = Vec(cp(1, 1), cp(1, 2));
      c = self.get_selected_component(p);
      c.shape.rotate(sign(callbackdata.VerticalScrollCount)*pi/20);
      self.game_state_.draw_state();
    end

  end

  methods(Access=private)
    
    function comp = get_selected_component(self, point)
      comp = [];
      for c = self.game_state_.components()
        if c{1}.shape.inside(point)
          self.selected_obj_ = c{1};
          comp = c{1};
          break;
        end
      end
    end

  end

end
