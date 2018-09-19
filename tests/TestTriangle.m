classdef TestTriangle < matlab.unittest.TestCase

  methods(TestMethodSetup)

    function create_foo(self)
      self.foo = Foo(); 
    end

  end

  methods(TestMethodTeardown)
    % closing figures, files, etc
  end

  methods(Test)

    function test_retrieve(self)
      self.verifyEqual(self.foo.value(), 1);
    end

    function test_increment(self)
      self.foo.increment();
      self.verifyEqual(self.foo.value(), 2);
    end

    function test_failing(self)
      self.verifyEqual(self.foo.value(), 10);
    end

    % ... etc

  end

end
