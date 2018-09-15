classdef TestCircle < matlab.unittest.TestCase

  methods(TestMethodSetup)
    % test setup
  end

  methods(TestMethodTeardown)
    % closing figures, files, etc
  end

  methods(Test)

    function test_intersect_from_center(self)
      for i=1:100
        x = rand();
        y = rand();
        circle = Circle(Vec(x, y));
        circle.set_dimensions(1); % circle radius
        ray = Ray(Vec(x, y), rand()); % ray starting in circle centroid
        self.assertTrue(circle.intersects(ray)); 
      end
    end

    function test_not_intersecting(self)
      for i=1:100
        % place circle on x-axis
        radius = 0.1;
        x = radius+abs(rand());
        y = 0;
        % construct ray passing through circle coming from origin
        delta = asin(radius/x);
        rangle = delta+rand()*(pi - delta);
        % rotate ray and circle and move to random point
        angle = pi*rand()*0;
        dx = 10*rand()*0;
        dy = 10*rand()*0;
        center = Vec(x+dx, y+dy);
        center.rotate(angle);
        circle = Circle(center);
        circle.set_dimensions(radius);
        ray_start = Vec(dx, dy);
        ray_start.rotate(angle);
        ray = Ray(ray_start, rangle + angle);
        self.assertFalse(circle.intersects(ray));
      end
    end

    function test_intersects_from_outside(self)
      for i=1:100
        % place circle on x-axis
        x = rand();
        y = 0;
        radius = 0.1;
        % construct ray passing through circle coming from origin
        delta = asin(radius/x);
        rangle = delta*rand();
        % rotate ray and circle and move to random point
        angle = pi*rand();
        dx = 10*rand();
        dy = 10*rand();
        center = Vec(x+dx, y+dy);
        center.rotate(angle);
        circle = Circle(center);
        circle.set_dimensions(radius);
        ray_start = Vec(dx, dy);
        ray_start.rotate(angle);
        ray = Ray(ray_start, rangle + angle);
        self.assertTrue(circle.intersects(ray));
      end
    end

  end

end
