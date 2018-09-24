classdef Refractive < Interactable

  methods
    function angle_out = interact(self, angle_in)
      if angle_in > 0
        n = self.r_index;
        angle_out = asin(sin(angle_in)/self.r_index);
      else
        if abs(angle_in) < asin(1/self.r_index);
          angle_out = -asin(sin(angle_in)*self.r_index);
        else
          % if there is internal reflection,
          % return a negative angle_out
          % this will then be translated by the
          % lens class to mean internal reflection
          angle_out = angle_in;
        end
      end
    end
  end

end
