classdef Interactable < handle

  methods(Abstract)
    % all interactions are either:
    % absorbtion, reflection, transmission.
    %
    % @param angle_in Incident angle of incoming ray
    % @return angle_out Either reflective or transmittive angle of outgoing ray
    interact_with(self, angle_in)
  end

end
