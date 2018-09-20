classdef Interactable < handle

  properties(Constant)
    r_index = 1.52;  % refractive index of crown glass
  end

  methods(Abstract)
    % all interactions are either:
    % absorbtion, reflection, transmission.
    %
    % @param angle_in Incident angle of incoming ray, positive for external
    % reflection
    % @return angle_out Either reflective or transmittive angle of outgoing ray
    interact(self, angle_in)
  end

end
