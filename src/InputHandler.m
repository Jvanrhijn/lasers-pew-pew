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
      while true
        self.advance();
      end
    end

    function advance(self)
      switch self.state_
        case InputState.IDLE
          title('Select an object');
          self.get_input(); 
          if self.button_ == Input.M_LEFT
            for c = self.game_state_.components()
              if c{1}.shape.inside(self.point_)
                self.selected_obj_ = c{1};
                self.state_ = InputState.OBJ_CLICKED; 
                break;
              end
            end
          end
        case InputState.OBJ_CLICKED
          title('Take an action');
          set(gcf, 'WindowscrollWheelFcn',...
            {@(x, y)(self.rotate_current(y.VerticalScrollCount))});
          self.get_input();
          if self.button_ == Input.M_RIGHT
            self.state_ = InputState.IDLE;
          %elseif self.button_ == Input.M_MIDDLE
            %self.selected_obj_.shape.rotate(pi/100);
          elseif self.button_ == Input.M_LEFT
            % TODO Collision checking
            self.selected_obj_.shape.move_to(self.point_);
          end
        case InputState.VALIDATE
      end
      self.game_state_.draw_state();
    end

    function get_input(self)
      [x, y, button] = ginput(1);
      self.point_ = Vec(x, y);
      self.button_ = button;
    end

    function validate_input(self, inp)

    end

    function rotate_current(self, amount)
      self.selected_obj_.shape.rotate(-sign(amount)*pi/50);
      self.game_state_.draw_state();
    end

  end

end
