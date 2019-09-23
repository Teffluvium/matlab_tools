function resourcesDir = getResourceDir
%GETRESOURCEDIR Summary of this function goes here
%   Detailed explanation goes here

p            = mfilename( 'fullpath' );
p            = fileparts( p );
p            = fileparts( p );
resourcesDir = fullfile( p, 'resources' );

end

