classdef TestRectangle < matlab.unittest.TestCase

  methods(TestMethodSetup)
    % test setup
  end

  methods(TestMethodTeardown)
    % closing figures, files, etc
  end

  methods(Test)

    function test_not_intersecting(self)
      for i=1:100
        w = rand();
        h = rand();
        xr = rand();
        yr = rand();
        rect = Rectangle(Vec(xr, yr));
        rect.set_dimensions([w, h]);
        % passing over
        x = -0.5*w - rand() + xr;
        y = 0.5*h + rand() + yr;
        ray = Ray(Vec(x, y), eps);
        self.assertFalse(rect.intersects(ray));
        % passing under
        y = -0.5*h - rand() + yr;
        ray = Ray(Vec(x, y), eps);
        self.assertFalse(rect.intersects(ray));
        % construct ray missing rectangle from top left
        p = rect.location();
        s = p + Vec(-w/2 - rand(), h/2 + rand());
        dy = s.y - (p.y + h/2);
        dx = p.x + w/2 - s.x;
        angle = atan(dy/dx); 
        ray = Ray(s, -angle + rand()*pi/2);
        self.assertFalse(rect.intersects(ray));
        % ray pointing away from rectangle
        ray = Ray(Vec(xr, yr - h/2 - rand()), -pi/2+eps);
        self.assertFalse(rect.intersects(ray));
      end
    end

    function test_intersects_from_outside(self)
      for i=1:100
        rect = Rectangle(Vec(0, 0));
        rect.set_dimensions([1, 1]);
        x = -0.5 - rand();
        y = 0.5 * rand();
        ray = Ray(Vec(x, y), eps);
        self.assertTrue(rect.intersects(ray));
        % edge case (or rather, corner case)
        ray = Ray(Vec(2, 2), -3*pi/4);
        self.assertTrue(rect.intersects(ray));
        % straight down
        ray = Ray(Vec(0, 2), -pi/2);
        self.assertTrue(rect.intersects(ray));
      end
    end

    function test_intersection_point(self)
      threshold = 1e-12;
      for i=1:100
        x = rand();
        y = rand();
        w = rand();
        h = rand();
        rect = Rectangle(Vec(x, y));
        rect.set_dimensions([w, h]);
        p = rect.location();
        % ray intersecting from the left
        s = Vec(x - w/2 - rand(), y + h/2 - rand());
        dx = p.x - w/2 - s.x;
        dy_min = p.y - h/2 - s.y;
        dy_max = p.y + h/2 - s.y;
        angle_min = atan(dy_min/dx);
        angle_max = atan(dy_max/dx);
        ray = Ray(s, angle_min + rand()*(angle_max - angle_min));
        self.assertTrue(rect.intersects(ray));
        [point, normal] = rect.intersection_point(ray);
        self.assertEqual(normal, Vec(-1, 0));
        self.assertTrue(abs(point.x - (x-w/2)) < threshold);
      end
    end

    function test_inside(self)
      for i=1:100
        x = rand();
        y = rand();
        w = rand();
        h = rand();
        rect = Rectangle(Vec(x, y));
        rect.set_dimensions([w, h]);
        point = Vec(x, y) + Vec(w*(rand() - 0.5), h*(rand() - 0.5));
        self.assertTrue(rect.inside(point));
        dx = w/2 + rand();
        dy = h/2 + rand();
        point_outside = Vec(x, y) + Vec(dx, dy);
        self.assertFalse(rect.inside(point_outside));
      end
    end

  end

end

