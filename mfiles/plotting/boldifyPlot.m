function [hax, hline, hlgd, htxt] = boldifyPlot( hFig )
if nargin<1
    hFig = gcf;
end

%% Update graphic object properties in bulk
% Collect handle objects
hax   = findall( hFig, 'Type', 'axes' );
hline = findall( hFig, 'Type', 'line' );
hlgd  = findall( hFig, 'Type', 'legend' );
htxt  = findall( hFig, 'Type', 'text' );

% Update all axes properties
set( hax, ...
    'XGrid', 'on', ...
    'YGrid', 'on', ...
    'FontSize', 15 )

% Update all line plot properties
set( hline, ...
    'LineWidth', 2, ...
    'MarkerSize', 10 );

% Update all legend properties
set( hlgd, ...
    'Location', 'best' );

% Update all legend and text properties
set( [hlgd; htxt], ...
    'FontSize', 15)

drawnow

end