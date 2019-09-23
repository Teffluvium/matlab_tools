function [Z,x,y] = gauss2dPatch( kernSize, sigma, center, theta, doPlot )
%gauss2d generates a 2D Gaussian "bump"
% 
% Syntax:
%     gauss2dPatch
%     gauss2dPatch( kernSize )
%     gauss2dPatch( kernSize, sigma )
%     gauss2dPatch( kernSize, sigma, center )
%     gauss2dPatch( kernSize, sigma, center, theta)
%     gauss2dPatch( kernSize, sigma, center, theta, doPlot )
%     Z = gauss2dPatch( ... )
%     [Z,x,y] = gauss2dPatch( ... )
% 
% Inputs:
%     kernSize - Size of the output grid in x and y.  Value should be a
%                scalar or a 2 element vector. If a scalar is used, the
%                same value is used for x and y dimension.
%                Default:  kernSize = 5
%     sigma    - Standard deviation in the x and y dimensions.  Value
%                should be a scalar or a 2 element vector. If a scalar is
%                used, the same value is used for x and y dimension.
%                Default: sigma = 1
%     center   - Center of the Gaussian bump.  Value should be a 2 element
%                vector.
%                Default: center = [0 0]
%     theta    - Rotation of the Gaussian bump in degrees.
%                Default: theta = 0
%     doPlot   - Boolean flag to plot the results
%                Default: doPlot = false
% 
% Output:
%     Z - 2-dimensional bump
%     x - vector of x values
%     y - vector of y values
% 
% Remarks:
%     The extents of x and y are +/-3 * sigmaMax, where sigmaMax is the
%     max( sigmaX, sigmaY ).
% 
% Examples:
%     Generate an 11x11 Gaussian patch that has been rotated by 45 degrees
%         kern   = 11;
%         sigmaX = 1;
%         sigmaY = 0.5;
%         offset = 1;
%         theta  = 45;
%         A      = stats.gauss2dPatch( kern, [sigmaX, sigmaY], offset, theta, 1 );

%% Default values
if nargin<1  ||  isempty( kernSize )
    kernSize = 5;
end
if nargin<2  ||  isempty( sigma )
    sigma    = 1;
end
if nargin<3  ||  isempty( center)
    center   = 0;
end
if nargin<4  ||  isempty( theta )
    theta    = 0;
end
if nargin<5  ||  isempty( doPlot )
    doPlot   = false;
end

%% Assign scalar values to each index
if isscalar( kernSize )
    nX = kernSize;
    nY = kernSize;
else
    nX = kernSize(1);
    nY = kernSize(2);
end

%% Split scalar inputs into x and y components
if isscalar( sigma )
    sigmaX = sigma;
    sigmaY = sigma;
else
    sigmaX = sigma(1);
    sigmaY = sigma(2);
end

if isscalar( center )
    x0 = center;
    y0 = center;
else
    x0 = center(1);
    y0 = center(2);
end

%% Set up parameters for calculating the Gaussian bump
% Set max extent for x and y
sigmaMax = max( sigmaX, sigmaY );
x        = 3*sigmaMax * linspace( -1, 1, nX );
y        = 3*sigmaMax * linspace( -1, 1, nY );

% Create a grid using x and y
[X, Y]   = meshgrid(x, y);

%% Generate the 2D Gaussian bump
Z = stats.gauss2d( X, Y, [ sigmaX, sigmaY], center, theta );

%% Plot the result
if doPlot
    plotGaussian2dPatch( x, y, x0, y0, Z, sigmaX, sigmaY, theta )
end

%% Return the results
return;


function plotGaussian2dPatch( x, y, x0, y0, Z, sigmaX, sigmaY, theta )
imagesc( x, y, Z );
colorbar;
axis xy image
titleStr = sprintf( ...
    '2D Gaussian Bump\n\\sigma=[%g,%g], center=[%g,%g], \\theta=%g', ...
    sigmaX, sigmaY, x0, y0, theta );
title( titleStr )
xlabel( 'x' );
ylabel( 'y' );

