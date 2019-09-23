function headless = isHeadless
%ISHEADLESS 
% detects if MATLAB is running from a command line with no display

headless = isequal( usejava('desktop'), 0 );