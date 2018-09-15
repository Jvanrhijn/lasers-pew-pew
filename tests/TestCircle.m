classdef TestCircle < matlab.unittest.TestCase

  methods(TestMethodSetup)
    % test setup
  end

  methods(TestMethodTeardown)
    % closing figures, files, etc
  end

  methods(Test)

    function test_intersect(self)
      circle = Circle(Vec(0, 0));
      circle.set_dimensions(1); % circle radius
      ray = Ray(Vec(0, 0), 0); % ray starting in origin
      self.assertTrue(circle.intersects(ray)); 
    end

  end

end
