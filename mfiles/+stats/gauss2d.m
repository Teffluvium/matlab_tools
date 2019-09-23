function z = gauss2d( x, y, sigma, center, theta )
%gauss2d generates a 2D Gaussian "bump"
% 
% Syntax:
%     gauss2d
%     gauss2d( x, y, sigma )
%     gauss2d( x, y, sigma, center )
%     gauss2d( x, y, sigma, center, theta)
%     z = gauss2d( ... )
% 
% Inputs:
%     x        - Array of x values
%                Default:  x = 0
%     y        - Array of y values
%                Default:  y = 0
%     sigma    - Standard deviation in the x and y dimensions.  Value
%                should be a scalar or a 2 element vector. If a scalar is
%                used, the same value is used for x and y dimension.
%                Default: sigma = 1
%     center   - Center of the Gaussian bump.  Value should be a 2 element
%                vector.
%                Default: center = [0 0]
%     theta    - Rotation of the Gaussian bump in degrees.
%                Default: theta = 0
% 
% Output:
%     z - vector of values from corresponding 2D Gaussian distribution
% 
% Remarks:
% 
% Examples:
%         x      = -5:5;
%         y      = zeros( size(x) );
%         sigmaX = 1;
%         sigmaY = 0.5;
%         offset = 1;
%         theta  = 45;
%         A      = stats.gauss2d( x, y, [sigmaX, sigmaY], offset, theta );


%% Default values
if nargin<1  ||  isempty( x )
    x = -10:10;
end
if nargin<2  ||  isempty( y )
    y = -10:10;
end
if nargin<3  ||  isempty( sigma )
    sigma    = 1;
end
if nargin<4  ||  isempty( center)
    center   = 0;
end
if nargin<5  ||  isempty( theta )
    theta    = 0;
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

%% Set up parameters for calculating values from the Gaussian
% Calculate multipliers and angle rotation factors
a        =  cosd(   theta )^2 / (2*sigmaX^2) + sind(   theta)^2 / (2*sigmaY^2);
b        = -sind( 2*theta )   / (4*sigmaX^2) + sind( 2*theta)   / (4*sigmaY^2);
c        =  sind(   theta )^2 / (2*sigmaX^2) + cosd(   theta)^2 / (2*sigmaY^2);
A        = 1;

%% Generate the 2D Gaussian bump
z = A*exp( - (a*(x-x0).^2 - 2*b*(x-x0).*(y-y0) + c*(y-y0).^2));

%% Return the results
return;
