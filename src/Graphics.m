classdef Graphics < handle

  properties(SetAccess = private, GetAccess = private)
    fig_;
    xlims_ = [0, 1];
    ylims_ = [0, 1];
  end

  methods

    function self = Graphics()
      self.fig_ = gcf;
      hold on;
      self.set_range([0, 1, 0, 1]);
    end

    function set_range(self, ranges)
      axis(ranges);
      self.xlims_ = ranges(1:2);
      self.ylims_ = ranges(3:4);
      dx = self.xlims_(2) - self.xlims_(1);
      dy = self.ylims_(2) - self.ylims_(1);
      dz = 1;
      pbaspect([dx, dy, dz]/max([dx, dy, dz]));
    end

    function draw_circle(self, circle)
      r = circle.radius;
      p = circle.location();
      theta = linspace(0, 2*pi, 1000);
      x = r*cos(theta) + p.x;
      y = r*sin(theta) + p.y;
      plot(x, y, 'b');
      self.set_range([self.xlims_, self.ylims_]);
    end

    function draw_ray(self, ray)
      angle = ray.angle();
      start = ray.start();
      [m, b] = ray.line();
      if (-pi/2 < angle) & (angle < pi/2)
        xmin = start.x;
        xmax = self.xlims_(2);
      else
        xmin = self.xlims_(1);
        xmax = start.x;
      end
      xs = [xmin, xmax];
      ys = m*xs + b;
      plot(xs, ys, 'r');
      self.set_range([self.xlims_, self.ylims_]);
    end

  end

end
