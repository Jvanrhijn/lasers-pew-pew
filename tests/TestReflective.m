classdef TestReflective < matlab.unittest.TestCase

  methods(Test)

    function test_interaction(self)
      threshold = 1e-15;
      for i=1:100
        angle = rand()*pi/2;
        reflective_interaction = Reflective();
        self.assertTrue(abs(reflective_interaction.interact(angle) - angle) < threshold);
      end
    end
  
  end

end
