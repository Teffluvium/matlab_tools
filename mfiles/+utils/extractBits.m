function param = extractBits( val, loBit, hiBit, assumedType )

if nargin<4
    assumedType = 'uint32';
end

% Find number of bits and data type 
[~,nBits,dataType] = utils.sizeof( assumedType );

% Calculate required left and right shifts
lShift = nBits - hiBit;
rShift = 1 - ( lShift + loBit );

% Trim the bits on the left
param  = val;
param  = bitshift( param, lShift, dataType );

% Trim the bits on the right
param  = bitshift( param, rShift, dataType );

end