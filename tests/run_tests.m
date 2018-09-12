clear; clear classes;

import matlab.unittest.TestRunner;
import matlab.unittest.TestSuite;

suite = TestSuite.fromClass(?TestExample);

runner = TestRunner.withTextOutput;

runner.run(suite);

