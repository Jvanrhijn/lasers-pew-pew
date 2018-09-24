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

    function vec = direction(self)
      vec = Vec(cos(self.angle_), sin(self.angle_));
    end

    
    function [slope, offset] = line(self)
      % return line representation of ray, y = slope*x + offset
      slope = tan(self.angle_);
      offset = self.start_.y - self.start_.x*slope;
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
