classdef Ray < handle

  properties
    start_
    angle_
  end

  methods

    % constructor 
    function self = Ray(start, angle)
      self.start_ = start;
      self.angle_ = angle;
    end
  
    % getters
    function s = start(self)
      s = self.start_;
    end

    function a = angle(self)
      a = self.angle_;
    end

  end

end
