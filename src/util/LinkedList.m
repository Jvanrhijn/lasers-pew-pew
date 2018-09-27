classdef LinkedList < handle

  properties(GetAccess=private, SetAccess=private)
    start_ 
  end

  methods
    
    function self = LinkedList()
      self.start_ = [];
    end

    function self = append(self, value)
      if isempty(self.start_)
        self.start_ = Node(value, []);
      else
        current = self.start_;
        prev = current;
        while ~isempty(current.next())
          prev = current;
          current = current.next();
        end
        current.link_next(Node(value, prev));
      end
    end

    function val = get(self, idx)
      val = self.get_node(idx).value();
    end

    function node = get_node(self, idx)
      node = self.start_;
      for n=1:(idx-1)
        node = node.next(); 
        if isempty(node)
          error("Index out of bounds");
        end
      end
    end

  end

end
