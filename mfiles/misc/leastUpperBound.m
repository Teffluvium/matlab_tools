function lub = leastUpperBound( t1, t2 )
%leastUpperBound Summary of this function goes here
%   Detailed explanation goes here

if nargin<1
    t1 = 1:20;
    t2 = 5:50;
end

lub = min( max( t1(:) ), max( t2(:) ) );

end

