function p = addpathExcept( pathList, exceptList )
% addpathExcept recursively adds all folders below a directory except for
% paths that match items in the exception list.
%
% INPUTS:
%     pathList   - 'string' or 'cell array of strings' that you wish to add
%                 to the path
%     exceptList - 'string' or 'cell array of strings' that you wish to
%                  exclude from the automatically generate

defaultExceptList = {'.git', '.svn' };

if nargin<1
    pathList   = '.';
end
if nargin<2
    exceptList = defaultExceptList;
end

pathList    = checkInputStr( pathList );
exceptList  = checkInputStr( exceptList );

% Always exclude '.svn'
exceptList  = union( exceptList, defaultExceptList );

placeholder = '--dotPath--';

for pInd = 1:length( pathList )
    p = pathList{ pInd };
    if ~exist( p, 'dir' )
        warning( ...
            'Ignoring the directory ''%s''.  It does not appear to exist.', p );
        continue
    end
    % Expand p to be a fully qualified path
    p    = regexprep( p, '(^\.)(.*)', [placeholder '$2'] );
    p    = strrep( p, placeholder, pwd );

    % Recursively generate a path string
    pStr = genpath( p );

    for eInd = 1:length( exceptList )
        except = exceptList{ eInd };
        % Escape characters that are "special" in regular expressions
        except = regexprep( except, '([.*+?\\])', '\\$1' );

        % Derive a search string for findind path to exclude
        repStr = sprintf( ...
            '[^%s]*%s[^%s]*%s', ...
            pathsep, except, pathsep, pathsep );

        % Remove path that match the exception string
        pStr = regexprep( pStr, repStr, '' );
    end

    % Add the downselected paths to the path
    addpath( pStr );
end

if nargout > 0
    p = path;
end


% ------------------
function strVar = checkInputStr( strVar )
if ischar( strVar )
    strVar = cellstr( strVar );
elseif ~iscellstr( strVar )
    error( 'Input must be a ''string'' or a ''cell array of strings''.' );
end
strVar = strtrim( strVar );
