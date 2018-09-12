classdef Ray

  properties
    start_
    angle_
  end

  methods
  
    % getters
    s = function start(self)
      s = start_;
    end

    a = function angle(self)
      a = angle_;
    end

  end

end
