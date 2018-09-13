classdef TestRectangle < matlab.unittest.TestCase

  properties
    rectangle
  end

  methods(TestMethodSetup)

    function create_rectangle(self)
      self.rectangle = Rectangle(Vec(0,0),[1,2,0]); % creates 1 by 2 rectangle around origin, parallel to x axis
    end

  end

  methods(TestMethodTeardown)
    % closing figures, files, etc
  end

  methods(Test)

    function test_intersect(self)
        for theta = linspace(0,2*pi,10)
            ray = Ray(Vec(0,0),theta);
            self.verifyTrue(self.rectangle.intersects(self.rectangle,ray)) %should give TRUE              
        end
    end
    
    function test_parallel(self)
        ray = Ray(Vec(0,2),0);
        self.verifyFalse(self.rectangle.intersects(self.rectangle,ray)) %should give FALSE              
    end
    
%     function test_increment(self)
%       self.foo.increment();
%       self.verifyEqual(self.foo.value(), 2);
%     end
% 
%     function test_failing(self)
%       self.verifyEqual(self.foo.value(), 10);
%     end

    % ... etc

  end

end
