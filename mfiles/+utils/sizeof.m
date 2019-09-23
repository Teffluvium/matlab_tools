function [nBytes,nBits,dataType] = sizeof( dataType )
% SIZEOF returns the number of bytes, bits, and corresponding Matlab data type
%
% Syntax
%     [nBytes,nBits,dataType] = sizeof( dataType )
%
% Inputs:
%     dataType - A string designating a binary data type.
%
%     The following data type classes are native to Matlab:
%         double, single
%         int8,  int16,  int32,  int64
%         uint8, uint16, uint32, uint64
%
%     The following data type classes are reconized by fread and other
%     lower-level file I/O:
%
%         Integers, unsigned
%             uint
%             uint8
%             uint16
%             uint32
%             uint64
%             uchar
%             unsigned char
%             ushort
%             ulong
%             ubitn
%         Integers, signed
%             int
%             int8
%             int16
%             int32
%             int64
%             integer*1
%             integer*2
%             integer*4
%             integer*8
%             schar
%             signed char
%             short
%             long
%             bitn
%         Floating-point numbers
%             single
%             double
%             float
%             float32
%             float64
%             real*4
%             real*8
%         Characters
%             char
%             char*1
%
% Outputs:
%     nBytes   - Minimum number of bytes that contain the data type class
%     nBits    - Number of bits in a data type class.  This number is typically
%                an integer muliple of 4; but in the case of the data types
%                'bitn' or 'ubitn', the number of bits returned will be match
%                the trailing 'n'.
%     dataType - The closest matching data type class that is native to Matlab.
%
% Examples:
%     Example 1:
%             dataTypeIn = 'double';
%             [ nBytes, nBits, dataTypeOut ] = utils.sizeof( dataTypeIn )
%         Should return nBytes = 8, nBits = 32, and dataTypeOut = 'double'
% 
%     Example 2:
%             dataTypeIn = 'uint';
%             [ nBytes, nBits, dataTypeOut ] = utils.sizeof( dataTypeIn )
%         Should return nBytes = 8, nBits = 32, and dataTypeOut = 'uint32'
% 
%     Example 3:
%             dataTypeIn = 'bit5';
%             [ nBytes, nBits, dataTypeOut ] = utils.sizeof( dataTypeIn )
%         Should return nBytes = 1, nBits = 5, and dataTypeOut = 'uint8'
%
%     Example 4:
%             dataTypeIn = 'bit28';
%             [ nBytes, nBits, dataTypeOut ] = utils.sizeof( dataTypeIn )
%         Should return nBytes = 4, nBits = 28, and dataTypeOut = 'uint32'
%
% Note: 
%     You can either call the 'sizeof' function explicitly using the notation
%     'utils.sizeof' or you can use one of the following import command and use
%     the shorter 'sizeof' notation.
%         import utils.sizeof;  % only imports the sizeof function
%         import utils.*;       % imports all functions in the utils package

% See Also:
%     fread, sizeofExample


narginchk( 1, 1 ) ;

% Reassign an file I/O data type classew to a class of the same size as
% defined by Matlab (see documentation for fread precision)
switch lower( dataType )
    case { 'int64', 'integer*8' }
        % Signed 64-bit integer data types
        dataType = 'int64';
        
    case { 'uint64' }
        % Unsigned 64-bit integer data types
        dataType = 'uint64';
        
    case { 'int32', 'int', 'integer*4',  'long' }
        % Signed 32-bit integer data types
        dataType = 'int32';
        
    case { 'uint32', 'uint', 'ulong' }
        % Unsigned 32-bit integer data types
        dataType = 'uint32';
        
    case { 'int16', 'integer*2', 'short' }
        % Signed 16-bit integer data types
        dataType = 'int16';
        
    case { 'uint16', 'ushort' }
        % Unsigned 16-bit data types
        dataType = 'uint16';
        
    case { ...
            'int8, ', 'char', 'integer*1', ...
            'schar', 'signed char', 'char*1' }
        % Singed 8-bit integer data types
        dataType = 'int8';
        
    case { 'uint8', 'uchar', 'unsigned char' }
        % Unsigned 8-bit integer data types
        dataType = 'uint8';
        
    case { 'single', 'float', 'float32', 'real*4' }
        % 32-bit floating-point data types
        dataType = 'single';
        
    case { 'double', 'float64', 'real*8' }
        % 64-bit floating-point data types
        dataType = 'double';
        
    otherwise
        % Check if the data type is a "bitn" or "ubitn" format
        % Try to read the number of bits from the (u)bitn
        nBitsStr = regexp( dataType, '(u?)bit(\d+)', 'tokens' );
        if ~isempty( nBitsStr )
            
            signStr = nBitsStr{1}{1};
            nBits   = str2double( nBitsStr{1}{2} );
            
            % Make sure nBits is bounded from 1 to 64
            if ( nBits < 1 )  ||  ( nBits > 64 )
                error( ...
                    'sizeof:BadBitCount', ...
                    'The number of bits in ''%s'' must be between 1 and 64 ( 1 <= n <= 64 )', ...
                    dataType );
            end
            
            % nBytes will be minimum number of bytes to store nBits
            nBytes   = ceil( nBits/8 );
            
            % dataTypeOut is closest uintX that holds nBytes
            dataType = sprintf( '%sint%d', signStr, 2^nextpow2( nBits ) );
            
            return
        end
end

try
    % Allocate a variable of the correct data type
    z = zeros( 1, dataType ); %#ok; z is referenced below in whos( 'z' )
catch
    error( 'sizeof:UnsupportedClass', 'Unsupported class for finding size' );
end

% How big is it?
w      = whos( 'z' );
nBytes = w.bytes;
nBits  = 8*nBytes;

end
