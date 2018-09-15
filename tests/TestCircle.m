classdef TestCircle < matlab.unittest.TestCase

  methods(TestMethodSetup)
    % test setup
  end

  methods(TestMethodTeardown)
    % closing figures, files, etc
  end

  methods(Test)

    function test_intersect_from_center(self)
      for i=1:10
        x = rand();
        y = rand();
        circle = Circle(Vec(x, y));
        circle.set_dimensions(1); % circle radius
        ray = Ray(Vec(x, y), rand()); % ray starting in circle centroid
        self.assertTrue(circle.intersects(ray)); 
      end
    end

    function test_not_intersecting(self)
      for i=1:10
        x = rand();
        y = rand();
        radius = 0.1;
        circle = Circle(Vec(x, y));
        circle.set_dimensions(radius);
        ray = Ray(Vec(x+rand(), y+radius+abs(rand())), 0);
        self.assertFalse(circle.intersects(ray));
      end
    end

    function test_intersects_from_outside(self)
      for i=1:10
        x = rand();
        y = rand();
        radius = 0.1;
        center = Vec(x, y);
        circle = Circle(center);
        circle.set_dimensions(radius);
        % ray going through centerpoint
        ray_center = Ray(Vec(0, 0), center.angle(Vec(1, 0)));
        self.assertTrue(circle.intersects(ray_center));
        % more generally:
        % TBI
      end
    end

  end

end
