classdef Foo < handle

  properties
    value_
  end

  methods

    function obj = Foo(self)
      obj.value_ = 1;
    end

    function increment(self)
      self.value_ = self.value_ + 1;
    end

    function val = value(self)
      val = self.value_;
    end

  end

end
