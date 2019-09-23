
%% Typical usage of the utils.sizeof function

%% Example 1:
% Should return nBytes = 8, nBits = 32, and dataTypeOut = 'double'
dataTypeIn = 'double';
[ nBytes, nBits, dataTypeOut ] = utils.sizeof( dataTypeIn );
fprintf( '\n---\n' )
fprintf( 'The data type ''%s'' maps to ''%s'' in Matlab\n', dataTypeIn, dataTypeOut );
fprintf( '  ''%s'' has %d bits and %d bytes\n', dataTypeIn, nBits, nBytes );

%% Example 2:
% Should return nBytes = 8, nBits = 32, and dataTypeOut = 'uint32'
dataTypeIn = 'uint';
[ nBytes, nBits, dataTypeOut ] = utils.sizeof( dataTypeIn );
fprintf( '\n---\n' )
fprintf( 'The data type ''%s'' maps to ''%s'' in Matlab\n', dataTypeIn, dataTypeOut );
fprintf( '  ''%s'' has %d bits and %d bytes\n', dataTypeIn, nBits, nBytes );

%% Example 3:
% Should return nBytes = 1, nBits = 5, and dataTypeOut = 'uint8'
dataTypeIn = 'bit5';
[ nBytes, nBits, dataTypeOut ] = utils.sizeof( dataTypeIn );

fprintf( '\n---\n' )
fprintf( 'The data type ''%s'' maps to ''%s'' in Matlab\n', dataTypeIn, dataTypeOut );
fprintf( '  ''%s'' has %d bits and %d bytes\n', dataTypeIn, nBits, nBytes );

%% Example 4:
% Should return nBytes = 4, nBits = 28, and dataTypeOut = 'uint32'
dataTypeIn = 'ubit28';
[ nBytes, nBits, dataTypeOut ] = utils.sizeof( dataTypeIn );

fprintf( '\n---\n' )
fprintf( 'The data type ''%s'' maps to ''%s'' in Matlab\n', dataTypeIn, dataTypeOut );
fprintf( '  ''%s'' has %d bits and %d bytes\n', dataTypeIn, nBits, nBytes );

%% Example 5:
% Should return nBytes = 4, nBits = 28, and dataTypeOut = 'uint32'
import utils.sizeof;

dataTypeIn = 'ubit28';
[ nBytes, nBits, dataTypeOut ] = sizeof( dataTypeIn );

fprintf( '\n---\n' );
fprintf( 'This uses the ''import utils.sizeof'' command \n' )
fprintf( '---\n' );
fprintf( 'The data type ''%s'' maps to ''%s'' in Matlab\n', dataTypeIn, dataTypeOut );
fprintf( '  ''%s'' has %d bits and %d bytes\n', dataTypeIn, nBits, nBytes );

% Cleanup the imports
clear import