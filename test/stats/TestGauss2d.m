classdef TestGauss2d < matlab.unittest.TestCase
    
    % Properties List
    properties
        resourcesDir
        x
        y
        X
        Y
        gX              % Gaussian in X
        gY              % Gaussian in Y
        sigmaX
        sigmaY
        offset
        theta
    end
    
    % Initializaion Methods
    methods (TestMethodSetup)
        function createTestData( testCase )

            x      = linspace( -10, 10, 101 );
            y      = x;
            
            [X,Y]  = meshgrid( x, y );

            sigmaX = 1;
            sigmaY = 0.5;
            
            gX     = exp( -x.^2/(2*sigmaX^2) );
            gY     = exp( -y.^2/(2*sigmaY^2) );
            
            offset = [ 1 1 ];
            theta  = 90;
            
            testCase.x      = x(:);
            testCase.y      = y(:);
            testCase.X      = X;
            testCase.Y      = Y;
            testCase.sigmaX = sigmaX;
            testCase.sigmaY = sigmaY;
            testCase.gX     = gX(:);
            testCase.gY     = gY(:);
            testCase.offset = offset;
            testCase.theta  = theta;
            
        end
    end
    
    
    methods (TestMethodTeardown)
        
    end
    
    methods (Test)
        % Test a single linear cut in the x and y directions
        function testGauss2dVertHoriz( testCase )
            zx = stats.gauss2d( ...
                testCase.x, ...
                zeros( size( testCase.x ) ), ...
                [testCase.sigmaX, testCase.sigmaY], ...
                0, ...
                0 );
            
            zy = stats.gauss2d( ...
                zeros( size( testCase.y ) ), ...
                testCase.y, ...
                [testCase.sigmaX, testCase.sigmaY], ...
                0, ...
                0 );
            
            testCase.verifyEqual( zx, testCase.gX, ...
                'AbsTol', sqrt( eps ));
            
            testCase.verifyEqual( zy, testCase.gY, ...
                'AbsTol', sqrt( eps ));
        end
        
        % Compare a single diagonal cut across a 2D array to the individual
        % curve generated on the diagonal line
        function testGauss2dDiagonal( testCase )
            zxy = stats.gauss2d( ...
                testCase.x, ...
                testCase.y, ...
                [testCase.sigmaX, testCase.sigmaY], ...
                0, ...
                0 );
            
            Z = stats.gauss2d( ...
                testCase.X, ...
                testCase.Y, ...
                [testCase.sigmaX, testCase.sigmaY], ...
                0, ...
                0 );
            
            Zdiag = diag( Z );
            Zdiag = Zdiag(:);
            
            testCase.verifyEqual( zxy, Zdiag, ...
                'AbsTol', sqrt( eps ));
        end
        
        % Test an offset in x and y
        function testGauss2dShift( testCase )
            
            % Create the Gaussian bump with the offset
            Z = stats.gauss2d( ...
                testCase.X, ...
                testCase.Y, ...
                [ testCase.sigmaX, testCase.sigmaY ], ...
                testCase.offset, ...
                0);

            % Get index into Z for offset location
            xOffsetInd = ( testCase.x == testCase.offset(1) );
            yOffsetInd = ( testCase.y == testCase.offset(2) );
            
            % The value at the offset should be the max value of Z = 1
            ZPeak = Z( xOffsetInd, yOffsetInd );
            
            testCase.verifyEqual( ZPeak, 1, ...
                'AbsTol', sqrt( eps ));
        end
        
    end
    
end



