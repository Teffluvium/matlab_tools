classdef TestGauss2dPatch < matlab.unittest.TestCase
    
    % Properties List
    properties
        resourcesDir
        kern
        sigmaX
        gX              % Gaussian in X
        sigmaY
        gY              % Gaussian in Y
        theta
        doPlot
    end
    
    % Initializaion Methods
    methods (TestMethodSetup)
        function createTestData( testCase )

            kern   = 7;
            x      = linspace( -3,3,kern );
            sigmaX = 1;
            gX     = exp( -x.^2/(2*sigmaX^2) );

            y      = linspace( -3,3,kern );
            sigmaY = 0.5;
            gY     = exp( -y.^2/(2*sigmaY^2) );
            
            theta  = 90;
            
            testCase.kern   = kern;
            testCase.sigmaX = sigmaX;
            testCase.gX     = gX(:);
            testCase.sigmaY = sigmaY;
            testCase.gY     = gY(:);
            testCase.theta  = theta;
            testCase.doPlot = false;
            
        end
    end
    
    
    methods (TestMethodTeardown)
        
    end
    
    methods (Test)
        % Test the vertical and horizontal cuts from gauss2dPatch
        function testGauss2dPatchVertHoriz( testCase )
            A    = stats.gauss2dPatch( ...
                testCase.kern, ...
                [testCase.sigmaX, testCase.sigmaY], ...
                0, 0, testCase.doPlot );
            
            actX = A(4,:);
            actY = A(:,4);
            
            testCase.verifyEqual( actX(:), testCase.gX, ...
                'AbsTol', sqrt( eps ));
            
            testCase.verifyEqual( actY(:), testCase.gY, ...
                'AbsTol', sqrt( eps ));
        end
        
        % Test the rotation from gauss2dPatch
        function testGauss2dPatchRot( testCase )
            A    = stats.gauss2dPatch( ...
                testCase.kern, ...
                [testCase.sigmaX, testCase.sigmaY], ...
                0, ...
                0, ...
                testCase.doPlot );
            ARot = stats.gauss2dPatch( ...
                testCase.kern, ...
                [testCase.sigmaX, testCase.sigmaY], ...
                0, ...
                testCase.theta, ...
                testCase.doPlot );

            testCase.verifyEqual( A, ARot', ...
                'AbsTol', sqrt( eps ));
        end
        
        % Test the shift from gauss2dPatch
        function testGauss2dPatchShift( testCase )
            AShift    = stats.gauss2dPatch( ...
                testCase.kern, ...
                [testCase.sigmaX, testCase.sigmaY], ...
                [1, 0], ...
                testCase.theta, ...
                testCase.doPlot );
            actXShift = AShift(:,5);
            
            testCase.verifyEqual( testCase.gX, actXShift(:), ...
                'AbsTol', sqrt( eps ));
        end
    end
    
end



