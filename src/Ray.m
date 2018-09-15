classdef Ray

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
      s = start_;
    end

    function a = angle(self)
      a = angle_;
    end

  end

end
