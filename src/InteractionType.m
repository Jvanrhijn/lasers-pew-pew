classdef Interactable

  % abstract methods must be implemented
  % by deriving classes
  methods(Abstract)
    % all interactions are either:
    % absorbtion, reflection, transmission.
    % reflection and transmission both require
    % incoming angle (wrt normal of object)
    % then each InteractionType performs a different
    % computation resulting in (either reflective or
    % transmittive) angle.
    function angle_out = interact_with(self, angle_in)
        angle_out = angle_in;
    end

  end

end
