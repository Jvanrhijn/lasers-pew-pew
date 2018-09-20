clear; clear classes;

addpath('../src/');
addpath('../src/util');

import matlab.unittest.TestRunner;
import matlab.unittest.TestSuite;
runner = TestRunner.withTextOutput;

suites = {TestSuite.fromClass(?TestVec),
          TestSuite.fromClass(?TestCircle),
          TestSuite.fromClass(?TestReflective),
          TestSuite.fromClass(?TestRectangle)};


for i=1:length(suites)
  runner.run(suites{i});
end
