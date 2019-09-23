function glb = greatestLowerBound( t1, t2 )
%greatestLowerBound Summary of this function goes here
%   Detailed explanation goes here

if nargin<1
    t1 = 1:20;
    t2 = 5:50;
end

glb = max( min( t1(:) ), min( t2(:) ) );

end

