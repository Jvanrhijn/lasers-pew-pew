classdef TestVec < matlab.unittest.TestCase

  methods(Test)

    function test_norm(self)
      for i=1:100
        dims = rand(1, 2);
        vector = Vec(dims(1), dims(2));
        norm = vector.norm();
        self.assertEqual(norm, sqrt(vector.x^2 + vector.y^2));
      end
    end

    function test_add(self)
      for i=1:100
        dims = rand(1, 4);
        vector_1 = Vec(dims(1), dims(2));
        vector_2 = Vec(dims(3), dims(4));         
        vec_sum = vector_1 + vector_2;
        manual_sum = Vec(vector_1.x+vector_2.x, vector_1.y+vector_2.y);
        self.assertEqual(vec_sum, manual_sum); 
      end
    end

    function test_sub(self)
      for i=1:100
        dims = rand(1, 4);
        vector_1 = Vec(dims(1), dims(2));
        vector_2 = Vec(dims(3), dims(4));         
        vec_sub = vector_1 - vector_2;
        manual_sub = Vec(vector_1.x-vector_2.x, vector_1.y-vector_2.y);
        self.assertEqual(vec_sub, manual_sub); 
      end
    end

    function test_normalize(self)
      for i=1:100
        dims = rand(1, 2);
        vector = Vec(dims(1), dims(2));
        vector.normalize();
        self.assertEqual(vector.norm(), 1.0, 'AbsTol', 1e-15);
      end
    end

    function test_angle(self)
      for i=1:100
        dims = rand(1, 4);
        vector_1 = Vec(dims(1), dims(2));
        vector_2 = Vec(dims(3), dims(4));         
        angle = vector_1.angle(vector_2);
        self.assertTrue(angle >= 0.0);
        self.assertTrue(angle <= pi);
      end
    end

    function test_dot(self)
      for i=1:100
        dims = rand(1, 4);
        vector_1 = Vec(dims(1), dims(2));
        vector_2 = Vec(dims(3), dims(4));         
        dot = vector_1.dot(vector_2);
        dot_rev = vector_2.dot(vector_1);
        self.assertEqual(dot, dot_rev, 'AbsTol', 1e-15);
        self.assertEqual(dot, vector_1.x*vector_2.x + vector_2.y*vector_1.y);
      end
    end

  end

end
