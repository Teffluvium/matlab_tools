function result = runAllMyTests

% Import the Matlab test suite components
import matlab.unittest.TestSuite;
import matlab.unittest.TestRunner;
% import matlab.unittest.plugins.TAPPlugin;
% import matlab.unittest.plugins.ToFile;

try
    % Create the suite and runner for the package of tests to run
    % suite  = TestSuite.fromFolder( '.', 'IncludingSubfolders', true );
    % runner = TestRunner.withTextOutput;

    % Run the suite of tests
    % runner.run(suite);
    result = runtests( pwd, 'Recursively', true );
    
catch e;
    disp(e.getReport);
    if testUtils.isHeadless
        exit(1);
    end
end

if testUtils.isHeadless
    quit;
end
