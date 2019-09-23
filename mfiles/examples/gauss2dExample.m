%% Linear Offset Test
% Create a pair of linear Gaussian curves with a shifted mean
x = linspace( -5, 5, 1000 );
y = zeros( size( x ) );

sigma  = [1 1];
offset = [1,0];
theta  = 0;

xs = x + offset(1);
ys = y + offset(2);

z  = stats.gauss2d( x, y, sigma, 0, theta );
zs = stats.gauss2d( x, y, sigma, offset, theta );

figure( 1 );
plot( x, z, x, zs )

%% 2D Test
% Create a 2D Gaussian bump that have been shifted in X and Y and rotated
% around its centroid by 30 degrees
x = linspace( -5, 5, 1000 );
y = x;

sigma  = [1 0.25];
offset = [1,2];
theta  = 30;

[X,Y] = meshgrid( x, y );

Z  = stats.gauss2d( X, Y, sigma, 0, 0 );
ZS = stats.gauss2d( X, Y, sigma, offset, theta );

figure( 2 );
subplot( 1,2,1 )
imagesc( x, y, Z )
grid on
axis image xy

subplot( 1,2,2 )
imagesc( x, y, ZS )
grid on
axis image xy

