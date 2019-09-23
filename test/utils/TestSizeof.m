classdef TestSizeof < matlab.unittest.TestCase
    
    % Properties List
    properties
        dataTypeIn_Int
        dataTypeIn_Uint
        dataTypeIn_Bits
        dataTypeIn_Float
        dataTypeIn_Bad
        dataTypeIn_Unrec
        dataTypeOut_Int
        dataTypeOut_Uint
        dataTypeOut_Bits
        dataTypeOut_Float
        nBits_Int
        nBits_Uint
        nBits_Bits
        nBits_Float
        nBytes_Int
        nBytes_Uint
        nBytes_Bits
        nBytes_Float
    end
    
    % Initializaion Methods
    methods (TestMethodSetup)
        function createTestData( testCase )
            % Define values for Int data types
            dataTypeIn_Int = {
                'int'
                'int8'
                'int16'
                'int32'
                'int64'
                'integer*1'
                'integer*2'
                'integer*4'
                'integer*8'
                'schar'
                'signed char'
                'short'
                'long'
                'char'
                'char*1'
                };
            dataTypeOut_Int = { 
                'int32'
                'int8'
                'int16'
                'int32'
                'int64'
                'int8'
                'int16'
                'int32'
                'int64'
                'int8'
                'int8'
                'int16'
                'int32'
                'int8'
                'int8'
                };
            nBits_Int       = [ 32 8 16 32 64 8 16 32 64 8 8 16 32 8 8 ];
            nBytes_Int      = nBits_Int / 8;

            % Define values for unsigned int data types
            dataTypeIn_Uint = {
                'uint'
                'uint8'
                'uint16'
                'uint32'
                'uint64'
                'uchar'
                'unsigned char'
                'ushort'
                'ulong'
                };
            dataTypeOut_Uint = {
                'uint32'
                'uint8'
                'uint16'
                'uint32'
                'uint64'
                'uint8'
                'uint8'
                'uint16'
                'uint32'
                };
            nBits_Uint      = [ 32 8 16 32 64 8 8 16 32 ];
            nBytes_Uint     = nBits_Uint / 8;

            % Define values for bit-level data types
            dataTypeIn_Bits = {
                'ubit7'
                'ubit15'
                'ubit31'
                'ubit64'
                'bit7'
                'bit15'
                'bit31'
                'bit64'
                };
            dataTypeOut_Bits = {
                'uint8'
                'uint16'
                'uint32'
                'uint64'
                'int8'
                'int16'
                'int32'
                'int64'
                };
            nBits_Bits      = [ 7 15 31 64 7 15 31 64 ];
            nBytes_Bits     = [ 1  2  4  8 1  2  4  8 ];

            % Define values for Floating-point data types
            dataTypeIn_Float = {
                'single'
                'double'
                'float'
                'float32'
                'float64'
                'real*4'
                'real*8'
                };
            dataTypeOut_Float = {
                'single'
                'double'
                'single'
                'single'
                'double'
                'single'
                'double'
                };
            nBits_Float     = [ 32 64 32 32 64 32 64 ];
            nBytes_Float    = nBits_Float / 8;
            
            % Define values for bad bitN data types
            dataTypeIn_Bad = {
                'ubit0'
                'ubit65'
                'bit0'
                'bit65'
                };
            
            % Define values for unrecognized data types
            dataTypeIn_Unrec = { 'thisIsNotADataType' };
            
            testCase.dataTypeIn_Int   = dataTypeIn_Int;
            testCase.dataTypeIn_Uint  = dataTypeIn_Uint;
            testCase.dataTypeIn_Float = dataTypeIn_Float;
            testCase.dataTypeIn_Bits  = dataTypeIn_Bits;
            testCase.dataTypeIn_Bad   = dataTypeIn_Bad;
            testCase.dataTypeIn_Unrec = dataTypeIn_Unrec;

            testCase.dataTypeOut_Int   = dataTypeOut_Int;
            testCase.dataTypeOut_Uint  = dataTypeOut_Uint;
            testCase.dataTypeOut_Float = dataTypeOut_Float;
            testCase.dataTypeOut_Bits  = dataTypeOut_Bits;
            
            testCase.nBits_Int   = nBits_Int;
            testCase.nBits_Uint  = nBits_Uint;
            testCase.nBits_Float = nBits_Float;
            testCase.nBits_Bits  = nBits_Bits;

            testCase.nBytes_Int   = nBytes_Int;
            testCase.nBytes_Uint  = nBytes_Uint;
            testCase.nBytes_Float = nBytes_Float;
            testCase.nBytes_Bits  = nBytes_Bits;
            
        end
    end
    
    
    methods (TestMethodTeardown)
        
    end
    
    methods (Test)
        % Test using a variety of signed integer data types
        function testSizeof_Int( testCase )
          
            for k=1:length( testCase.dataTypeIn_Int )
                dtIn_exp   = testCase.dataTypeIn_Int{k};
                dtOut_exp  = testCase.dataTypeOut_Int{k};
                nBits_exp  = testCase.nBits_Int(k);
                nBytes_exp = testCase.nBytes_Int(k);
            
               [nBytes,nBits,dataTypeOut] = utils.sizeof( dtIn_exp );
               
               testCase.verifyEqual( dataTypeOut, dtOut_exp );
               testCase.verifyEqual( nBits,       nBits_exp );
               testCase.verifyEqual( nBytes,      nBytes_exp );
            end
            
        end
        
        % Test using a variety of unsigned integer data types
        function testSizeof_Uint( testCase )
          
            for k=1:length( testCase.dataTypeIn_Uint )
                dtIn_exp   = testCase.dataTypeIn_Uint{k};
                dtOut_exp  = testCase.dataTypeOut_Uint{k};
                nBits_exp  = testCase.nBits_Uint(k);
                nBytes_exp = testCase.nBytes_Uint(k);

               [nBytes,nBits,dataTypeOut] = utils.sizeof( dtIn_exp );
               
               testCase.verifyEqual( dataTypeOut, dtOut_exp );
               testCase.verifyEqual( nBits,       nBits_exp );
               testCase.verifyEqual( nBytes,      nBytes_exp );
            end
            
        end
        
        % Test using a variety of floating-point data types
        function testSizeof_Float( testCase )
          
            for k=1:length( testCase.dataTypeIn_Float )
                dtIn_Float_exp   = testCase.dataTypeIn_Float{k};
                dtOut_Float_exp  = testCase.dataTypeOut_Float{k};
                nBits_Float_exp  = testCase.nBits_Float(k);
                nBytes_Float_exp = testCase.nBytes_Float(k);

               [nBytes,nBits,dataTypeOut] = utils.sizeof( dtIn_Float_exp );
               
               testCase.verifyEqual( dataTypeOut, dtOut_Float_exp );
               testCase.verifyEqual( nBits,       nBits_Float_exp );
               testCase.verifyEqual( nBytes,      nBytes_Float_exp );
            end
            
        end
        
        % Test using a variety of bitN data types
        function testSizeof_Bit( testCase )
          
            for k=1:length( testCase.dataTypeIn_Bits )
                dtIn_exp   = testCase.dataTypeIn_Bits{k};
                dtOut_exp  = testCase.dataTypeOut_Bits{k};
                nBits_exp  = testCase.nBits_Bits(k);
                nBytes_exp = testCase.nBytes_Bits(k);

               [nBytes,nBits,dataTypeOut] = utils.sizeof( dtIn_exp );
               
               testCase.verifyEqual( dataTypeOut, dtOut_exp );
               testCase.verifyEqual( nBits,       nBits_exp );
               testCase.verifyEqual( nBytes,      nBytes_exp );
            end
            
        end
        
        % Test using a variety of unrecognized and/or bad data types
        function testSizeof_Bad( testCase )
          
            for k=1:length( testCase.dataTypeIn_Bad )
                dtIn_exp   = testCase.dataTypeIn_Bad{k};
                
                % expected exception
                expectedME = MException( ...
                    'sizeof:BadBitCount', ...
                    'The number of bits in ''%s'' must be between 1 and 64 ( 1 <= n <= 64 )', ...
                    dtIn_exp );
                
                noErr = false;
                try
                    [~]   = utils.sizeof( dtIn_exp );
                    noErr = true;
                catch actualME
                    % verify correct exception was thrown
                    testCase.verifyEqual( actualME.identifier, expectedME.identifier, ...
                        'The function threw an exception with the wrong identifier.' );
                    testCase.verifyEqual( actualME.message, expectedME.message, ...
                        'The function threw an exception with the wrong message.' );
                end
                
                % verify an exception was thrown
                testCase.verifyFalse( noErr, 'The function did not throw any exception.' );
            end
            
        end
        
        
        % Test using a variety of unrecognized and/or bad data types
        function testSizeof_Unrec( testCase )
          
            for k=1:length( testCase.dataTypeIn_Unrec )
                dtIn_exp   = testCase.dataTypeIn_Unrec{k};
                
                % expected exception
                expectedME = MException( ...
                    'sizeof:UnsupportedClass', 'Unsupported class for finding size' );
                
                noErr = false;
                try
                    [~]   = utils.sizeof( dtIn_exp );
                    noErr = true;
                catch actualME
                    % verify correct exception was thrown
                    testCase.verifyEqual( actualME.identifier, expectedME.identifier, ...
                        'The function threw an exception with the wrong identifier.' );
                    testCase.verifyEqual( actualME.message, expectedME.message, ...
                        'The function threw an exception with the wrong message.' );
                end
                
                % verify an exception was thrown
                testCase.verifyFalse( noErr, 'The function did not throw any exception.' );
            end
            
        end
        
    end
    
end



