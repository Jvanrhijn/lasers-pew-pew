classdef Node < handle
  properties(GetAccess=private, SetAccess=private)
    next_
    prev_
    value_
  end

  methods
    
    function self = Node(value, prev)
      self.value_ = value;
      self.next_ = [];
      self.prev_ = prev;
    end

    function link_next(self, next)
      self.next_ = next;
    end

    function val = value(self)
      val = self.value_;
    end

    function n = next(self)
      n = self.next_;
    end

  end

end
