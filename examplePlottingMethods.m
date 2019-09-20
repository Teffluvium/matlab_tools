

x = linspace( 0, 1, 100001 );
y = sin( 2 * pi * 5 * x );

% %% Add one line object per point
% figure(1)
% for k=1:length(x)
%     if k==1
%         plot( x(k), y(k), 'b.' )
%     else
%         hold on
%         plot( x(k), y(k), 'b.' );
%     end
%     drawnow
% end
% hold off
% 
% 
% %% Create a single line object and sequentially add points
% figure(2)
% 
% % initialize temporary x- and y-data
% xTemp = x(1);
% yTemp = y(1);
% for k=1:length(x)
%     if k==1
%         % Create the plot on the first pass
%         hLine = plot( xTemp, yTemp, 'ro' );
%     else
%         % Update the line object with additional points
%         xTemp = [ xTemp, x(k) ];
%         yTemp = [ yTemp, y(k) ];
%         set( hLine, ...
%             'XData', xTemp, ...
%             'YData', yTemp );
%     end
%     drawnow
% end
% 

%% Create two line objects: one for the full plot, and one as a sliding window
figure(3)

% Initialize the sliding window
N     = 200;     % Size of the sliding window
xTemp = nan( 1, N );
yTemp = nan( 1, N );

% Initialize the line objects for the full plot and sliding windows
hLine = plot( ...
    xTemp, yTemp, 'ro', ...
    x,     y,     'k.' );

grid on
for k=1:length(x)
    % Update data in the sliding window
    xTemp = [ x(k), xTemp(1:(N-1)) ];
    yTemp = [ y(k), yTemp(1:(N-1)) ];
    set( hLine(1), ...
        'XData', xTemp, ...
        'YData', yTemp );
    drawnow
end

