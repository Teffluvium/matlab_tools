function alignXAxes( varargin )

% ALIGNXAXES
%
%    Zoom in and out of a 2-D plot with multiple axes while keeping the
%    x-axes aligned.
%
% Syntax
%
%       alignXAxes( 'SelectionType' )
%       alignXAxes( 'SelectionType', figHandle )
%       alignXAxes( 'SelectionType', figHandle, zoomFactor )
%      @alignXAxes
%    { @alignXAxes, 'SelectionType' }
%    { @alignXAxes, 'SelectionType', figHandle }
%    { @alignXAxes, 'SelectionType', figHandle, zoomFactor }
%
% Description
%
%    ALIGNXAXES is a zoom utility that allows a user simply to click,
%    double click, right click, or drag a rubberband box to zoom in and out
%    of a figure with multiple axes.  After the zoom operation has been
%    completed on a sigle set of axes, all of the other axes in the figure
%    will be updated to match the alignment of the x-axes that was just
%    clicked on.
%
%    This function then auto scales each set of y-axes individually to
%    display the data within that window.
%
%    alignXAxes('SelectionType') is a string that allows the user to
%       specify the type of action that would be taken with a particular
%       mouse click. There are three different selection types:
%          'normal' - Single mouse click.  Zooms in to graph by a zoom
%                    factor of 2.
%          'open'   - Double mouse click.  Zooms out to maximum limits of
%                    all of the data in all of the axes.
%          'alt'    - Right mouse click.  Zooms out by zoomFactor.
%          'extend' - Shift mouse click.  This does nothing in this function.
%
%    alignXAxes( ..., figHandle ) applies the selection type to a
%       particular figure.
%
%    alignXAxes( ..., zoomFactor ) is a positive decimal number that
%       adjusts the rate at which you zoom in or out of the plots.  The default
%       value of zoomFactor is 2.
%
%    @alignXAxes
%
%    {@alignXAxes, 'SelectionType'}
%
%    {@alignXAxes, ..., figHandle}
%
%    {@alignXAxes, ..., zoomFactor}
%
% Remarks
%
%    ALIGNXAXES changes the axes limits by a factor of two (in or out) each
%    time you press the mouse button while the cursor is within an axes.
%    You can also click and drag the mouse to define a zoom area, or
%    double-click to return to the initial zoom level.
%
%    When zooming in or out, you cannot select a window that extends past
%    the limits of the absolute minimum and maximum values of all of the x
%    data in the figure.
%
%    ALIGNXAXES can be called as a stand alone function;  but, it is
%    designed primarily for use as a 'ButtonDownFcn' callback for axes and
%    line objects.
%
%    If you want ALIGNXAXES to ignore a certain object, set the objects
%    'handleVisibility' property to 'off' (i.e., set(h, 'HandleVisibility',
%    'off').
%
% Example
%
%    x      = linspace(0,90,1001)';
%    y(:,1) = sin(2*pi/10*x);
%    y(:,2) = sin(2*pi/3.1*x) + 2;
% 
%    subplot(2,1,1), plot(x, y)
%    subplot(2,1,2), plot(x+10, y)
% 
%    hAx   = findobj( gcf, 'type', 'axes' );
%    hLine = findobj( hAx, 'type', 'line' );
%    set(hAx,   'ButtonDownFcn', @alignXAxes);
%    set(hLine, 'ButtonDownFcn', @alignXAxes);
% 
%    % Syncronize the x axes initially
%    alignXAxes('open')
%
% See Also
%
%    ZOOM XON.

% Future Modifications
%
%    Allow ALIGNXAXES to toggle on/off as if it were stand alone zoom function
%    Specify arbitrary value for zoom factor
%
% Dependent Functions
%
%    ALIGNXAXES\PARSEINPUTS
%    ALIGNXAXES\ZOOMX
%    ALIGNXAXES\GLOBALXLIM
%    ALIGNXAXES\SCALEY


% Version History
%     7/ 7/2003        1.0       Created by Tim Herrin

[selectionType, hFig, hAx, hLine, zoomFactor] = parseInputs(varargin);

% Update x-axes and return the current XLims
XLim = zoomX(selectionType, hFig, hAx, hLine, zoomFactor);

% Now scale each y-axis individually
for h=hAx'
   % scaleY(XLim, h)
   autoScaleY(XLim, h)
end


%----------------------------------------------------
function [selectionType, hFig, hAx, hLine, zoomFactor] = parseInputs(inputLst)

% Default values
selectionType = 'open';
hFig          = get(0, 'CurrentFigure');
if isempty(hFig), return, end
zoomFactor    = 2;

switch length(inputLst)
   case 0

   case 1
      % Assume argument is the SelectionType
      selectionType = inputLst{1};

   case 2
      if ischar(inputLst{1})  &&  ishandle(inputLst{2})
         % Assume 1st argurment is selectionType and 2nd arg is figure handle
         selectionType = inputLst{1};
         hFig          = inputLst{2};
      else
         % Assume that the function has been called via a function handle
         obj           = inputLst{1};
         eventdata     = inputLst{2};
         selectionType = get(hFig, 'SelectionType');
      end

   case 3
      if ischar(inputLst{1})  &&  ishandle(inputLst{2})
         % Assume 1st argurment is selectionType and 2nd arg is figure handle
         selectionType = inputLst{1};
         hFig          = inputLst{2};
         zoomFactor    = inputLst{3};
      else isequal(gcbo, inputLst{1})  &&  isempty(inputLst{2})
         % Assume that the function has been called via a function handle
         obj           = inputLst{1};
         eventdata     = inputLst{2};
         selectionType = inputLst{3};
         hFig          = get(0, 'CurrentFigure');
         zoomFactor    = 2;
      end

   case 4
      if ishandle(inputLst{1})  &&  isempty(inputLst{2})
         % Assume that the function has been called via a function handle
         obj           = inputLst{1};
         eventdata     = inputLst{2};
         selectionType = inputLst{3};
         hFig          = inputLst{4};
         if ~ishandle(hFig), return, end
         zoomFactor    = 2;
      else
         error('Too many input arguments')
      end

   case 5
      if ishandle(inputLst{1})  &&  isempty(inputLst{2})
         % Assume that the function has been called via a function handle
         obj           = inputLst{1};
         eventdata     = inputLst{2};
         selectionType = inputLst{3};
         hFig          = inputLst{4};
         if ~ishandle(hFig), return, end
         zoomFactor    = inputLst{5};
      else
         error('Too many input arguments')
      end

   otherwise
      error('Too many input arguments')
end

if ~ismember(selectionType, {'normal', 'open', 'extend', 'alt'})
   error('SelectionType is not recognized')
end

% Get all visible axes objects in the figure
hAx   = findobj(hFig, 'type', 'axes');
% Get all visible line objects in the figure
hLine = findobj(hAx,  'type', 'line');



%----------------------------------------------------
function XLim = zoomX(selectionType, hFig, hAx, hLine, zoomFactor)

% Max and min for the data in all of the x-axes
glbXLim    = globalXLim(hLine);
% Current window limits in current x-axes
XLim       = get(gca, 'XLim');
% Width of current window for the current x-axes
win        = diff(XLim);

% Find appropriate limits for x-axes.
switch selectionType
   case 'normal'        % Single mouse click.  Zoom in.
      % Get current point/box in current axes
      p1   = get(gca, 'CurrentPoint');
      rbbox;
      p2   = get(gca, 'CurrentPoint');
      XLim = [min(p1(1,1), p2(1,1))  max(p1(1,1), p2(1,1))];

      % Is it a point or a box
      if diff(XLim)<=0.001*win
         zoomType = 'point';
      else
         zoomType = 'box';
      end

      switch zoomType
         case 'point'
            % Adjust win by zoomFactor
            win = win/zoomFactor;
            % Zoom in by scale factor centered on that point
            if (XLim(1)-win/2) <= glbXLim(1)
               % Over shot left side of data
               XLim = glbXLim(1) + [0 win];
            elseif (XLim(2)+win/2) >= glbXLim(2)
               % Over shot right side of data
               XLim = glbXLim(2) - [win 0];
            else
               % Window fits within glbXLims
               XLim = XLim + [-win/2 win/2];
            end
         case 'box'
            % Use the box
            XLim(1) = max(XLim(1), glbXLim(1));
            XLim(2) = min(XLim(2), glbXLim(2));
      end

   case 'open'     % Double mouse click.  Zoom all the way out.
      % Zoom out to maximum limits
      XLim = glbXLim;

   case 'alt'      % Right mouse click.  Zoom out.
      % Adjust win by zoomFactor
      win  = min(win*zoomFactor, diff(glbXLim));
      % Zoom out by scale factor centered on that point
      p    = get(gca, 'CurrentPoint');
      XLim = p(1,1) + [-win/2  win/2];

      if (XLim(1)-win/2)<=glbXLim(1)
         % Over shot left side of data
         XLim = glbXLim(1) + [0 win];
      elseif (XLim(2)+win/2)>=glbXLim(2)
         % Over shot right side of data
         XLim = glbXLim(2) - [win 0];
      else
         % Window fits within glbXLims
         XLim = XLim + [-win/2 win/2];
      end

   case 'extend'   % Shift click.  Do nothing.
      return

end

% Apply the appropriate limits to all of the x-axes.
set(hAx, 'XLim', XLim)



%----------------------------------------------------
function glbXLim = globalXLim(hLine)

% globalXLim finds the maximum and minimum values of XData for all of the
% line objects identified by hLine.

numLines = length(hLine);
x        = zeros(numLines, 2);
for i = 1:numLines
   XData  = get(hLine(i), 'XData');
   x(i,:) = [min(XData) max(XData)];
end
glbXLim = [min(x(:,1)) max(x(:,2))];
