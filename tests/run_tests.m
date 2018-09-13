clear; clear classes;

addpath('../src/');

import matlab.unittest.TestRunner;
import matlab.unittest.TestSuite;
runner = TestRunner.withTextOutput;

suites = [TestSuite.fromClass(?TestVec)];


for i=1:length(suites)
  runner.run(suites(i));
end
