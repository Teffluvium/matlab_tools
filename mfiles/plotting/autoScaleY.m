function autoScaleY( XLim, hAx, bufferSize )
% Scale the y-axes to the data within the bounds of XLim and add a buffer of
% white space above and below
% 
% Inputs:
%   XLim        - 2x1 vector of min and max limits of the x-axis
% 
%   hAx         - vector of handles to autoscale
% 
%   bufferSize  - (Optional) [ scalar | {2x1 vector} ] Percentage of y-axis to
%                 use as an empty buffer space.  If bufferSize is a scalar, then
%                 an equal amount of empty space is used.  If bufferSize is a
%                 vector, then bufferSize(1) is used for the bottom and
%                 bufferSize(2) is used for the top of the axes object in hAx.
%                 Default value is 0.1

if nargin<3
    bufferSize = 0.1;
end

switch length( bufferSize )
    case 1
        bufferLow  = bufferSize;
        bufferHigh = bufferSize;
    case 2
        bufferLow  = bufferSize(1);
        bufferHigh = bufferSize(2);
    otherwise
        error( 'bufferSize must either be a scalar or a vector of length 2' );
end

% Get handles for all line objects within current axes
hLine = findobj( hAx, 'Type', 'line' );
NL    = length( hLine );

% Cycle through each of the line objects in this set of axes.
YLim = nan( NL, 2 );
for hInd=1:NL
    h     = hLine( hInd );
    % Find XData in current window
    x     = get( h, 'XData' );
    % Find YData in current window
    y     = get( h, 'YData' );
    % Truncate y to range of interest
    y     = y(x>=XLim(1)  &  x<=XLim(2));
    % Get limits of YData in current window
    if ~isempty(y)
        % Get limits of YData in current window
        YLim(hInd,:) = [ min(y) max(y) ];
    end
end

if isnan(YLim)
    % No data in window, center vertically on 0
    YLim = .05*[-1 1];
else
    % Center data vertically in window
    YLim = [ min(YLim(:,1))  max(YLim(:,2)) ];
    if diff(YLim)<=eps
        % All Y data is of equal value, center on that value
        YLim = YLim + .05*[-1 1];
    else
        % Add some white space below and above data
        buffer = diff(YLim) * [bufferLow bufferHigh] .* [ -1 1 ];
        YLim   = YLim + buffer;
    end
end

% Apply appropriate y limits for this set of axes
set( hAx, ...
    'XLim', XLim, ...
    'YLim', YLim );
