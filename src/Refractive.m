classdef Refractive < Interactable

  methods
    function angle_out = interact(self, angle_in)
      if angle_in > 0
        n = self.r_index;
      else
        n = 1/self.r_index;
      end
      angle_out = asin(sin(abs(angle_in))/n);
    end
  end

end
