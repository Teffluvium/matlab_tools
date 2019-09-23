function h = progressBar(varargin)
% PROGRESSBAR generates and/or updates a GUI with a single or multiple
%   simultaneous progress bars.  Also has the ablility to pause and/or
%   cancel a process.
%
%
% SYNTAX
%
%  H = PROGRESSBAR(message, Name)
%  PROGRESSBAR(H)
%  PROGRESSBAR(H, 'PropertyName', PropertyValue, ...)
%  PROGRESSBAR('Demo')
%
%
% REMARKS
%
%  H = PROGRESSBAR(Message, Name) generates a figure with the title Name,
%     and a progress bar labeled Message.  If Message is a cell array of
%     strings multiple progress bars will be created each labeled by the
%     elements of Message. The handle of the figure window is returned in
%     H.
%
%  PROGRESSBAR(H) makes the current figure window the progress bar window.
%
%  PROGRESSBAR(H, 'PropertyName', PropertyValue, ...) updates the progress
%     bar with handle H.  See the "PROPERTIES" section for details on
%     appropriate properties.
%
%  PROGRESSBAR('Demo') runs the example described in the EXAMPLE section.
%
%
%
% PROPERTIES
%
%  Message - The labels on each of the progress bars in the figure H.
%     This value must either be of type string or a cell array of
%     strings.
%
%  Name - A string indicating the title of the progress bar window.
%
%  Percent - [1xN double] This array is the current percentage of
%     each of the progress bars contained in the figure H.  These values
%     must be less than or equal to 1.
%
%  Update_Rate - A scalar value indicating the minimum refresh rate of the
%     progress bar window in seconds.  The default value is 1/10 second.
%
%
% EXAMPLE
%
%  % Title of Progress Bar Window
%  name    = 'Progress Bar Demo';
%  % List of processes to keep track of
%  message = {'Process 1', 'Process 2'};
%  Loop1   = 10;
%  Loop2   = 5000;
%
%  % Initialize the progress bar
%  hProg = progressBar(message, name);
%
%  for i=1:Loop1
%     for j=1:Loop2
%        message = {...
%              sprintf('Process 1:  Iteration %1.0f of %1.0f', i, Loop1); ...
%              sprintf('Process 2:  Iteration %1.0f of %1.0f', j, Loop2)};
%        progressBar(hProg, ...
%           'prcnt',  [i/Loop1, j/Loop2], ...
%           'msg',    message, ...
%           'update', .2);
%     end
%  end
%  close(hProg)
%
%
%  See also, WAITBAR
%
% Written by Tim Herrin
% Version: 1.3

% Version History:   12/11/2002  1.0
%              12/12/2002  1.1 Added Cancel button
%              12/12/2002  1.2   Added Pause button
%              12/12/2002  1.3   Added over 100% progress warning
%               6/ 6/2003  1.4 Turned off HandleVisibility propterty
%                          in figure to protect from being over written

% Set Default values
update_rate = .1;

if nargin==1
   if strcmpi(varargin{1}, 'demo')
      progbardemo
      return
   end
end

% Parse the inputs
if nargin==0
   error('Not Enough Input Arguments')

elseif ishandle(varargin{1})
   h = varargin{1};
   % Check that h is the handle to a progress bar
   if ~strcmp(get(h, 'Tag'), 'timebar')
      error('Invalid handle:  This is not a timebar window')
   end
   if nargin==1
      % Bring the progress bar to the front and return
      figure(h);
      if nargout==0,  clear h, end
      return
   else
      for i=2:2:nargin
         PropertyName = lower(varargin{i});
         switch PropertyName
            case {'message', 'msg', 'process'}
               message = varargin{i+1};
               if ~iscell(message)
                  message = cellstr(message);
               end
            case {'name', 'title'}
               name = varargin{i+1};
            case {'percent', 'prcnt', 'progress'}
               progress = varargin{i+1};
            case {'update', 'updaterate', 'update_rate', 'rate'}
               update_rate = varargin{i+1};
            otherwise
               error(...
                  'Unknown Property ''%s''.  See help for valid Properties.', ...
                  varargin{i})
         end
      end
   end
   command_str = 'Update Progress';

else  % First argument is not a handle
   if nargin~=2
      error('Invalid Handle')
   else
      message = varargin{1};
      if ~iscell(message)
         message = cellstr(message);
      end
      name        = varargin{2};
      command_str = 'Initialize';
   end
end

switch command_str
   case 'Initialize'
      % How many Progress bars are to be plotted?
      blocks = length(message);

      % Progrees bar window dimensions
      winwidth  = 400;
      winheight = 75 + 40*blocks;
      % User screen dimensions
      screensize   = get(0,'screensize');
      screenwidth  = screensize(3);
      screenheight = screensize(4);
      % Center the window within the user screen dimensions
      winpos = [0.5*(screenwidth-winwidth), ...
         0.5*(screenheight-winheight), ...
         winwidth, ...
         winheight];

      h = figure('Units',  'pixels', ...
         'DoubleBuffer',  'on', ...
         'IntegerHandle', 'off', ...
         'Menubar',       'none', ...
         'Name',          name, ...
         'NumberTitle',   'off', ...
         'Position',      winpos, ...
         'Resize',        'off', ...
         'Tag',           'timebar');
      bgc = get(h,         'Color');

      for i = 1:blocks;
         msg = message{i};

         % Vertical placement of progress bars
         v_shift = (i-1) * [0 35 0 0];

         ud.msg(i) = uicontrol(h, ...
            'BackgroundColor',      bgc, ...
            'ForegroundColor',      'k', ...
            'HorizontalAlignment',  'left', ...
            'Position',             [10 winheight-25 winwidth-20 15] - v_shift, ...
            'String',               msg, ...
            'Style',                'text');
         ud.axes(i) = axes('Parent', h, ...
            'Units',                'pixels', ...
            'Box',                  'on',...
            'Color',                [1 1 1],...
            'Position',             [10 winheight-40 winwidth-21 15] - v_shift, ...
            'XLim',                 [0 1],...
            'XTick',                [], ...
            'YTick',                []);
         ud.bar(i) = patch([0 0 0 0 0] ,[0 1 1 0 0],'g');
         ud.msg_prcnt(i) = text(.5, .5, '0%');
         set(ud.msg_prcnt(i), ...
            'FontWeight',           'demi', ...
            'HorizontalAlignment',  'center')
      end

      ud.elapsed_time_label = uicontrol(h, ...
         'BackgroundColor',     bgc, ...
         'ForegroundColor',     0*[1 1 1],...
         'HorizontalAlignment', 'left', ...
         'Position',            [10 55 winwidth-200 15], ...
         'String',              'Elapsed Time: ', ...
         'Style',               'text');
      ud.elapsed_time = uicontrol(h, ...
         'BackgroundColor',     bgc, ...
         'ForegroundColor',     'k', ...
         'Position',            [110 55 winwidth-120 15], ...
         'HorizontalAlignment', 'left',...
         'String',              '', ...
         'Style',               'text');

      ud.remain_time_label = uicontrol(h, ...
         'BackgroundColor',     bgc, ...
         'ForegroundColor',     0*[1 1 1],...
         'HorizontalAlignment', 'left', ...
         'Position',            [10 40 winwidth-200 15], ...
         'String',              'Remaining Time: ', ...
         'Style',               'text');
      ud.remain_time = uicontrol(h, ...
         'BackgroundColor',     bgc, ...
         'ForegroundColor',     'k', ...
         'Position',            [110 40 winwidth-120 15], ...
         'HorizontalAlignment', 'left',...
         'String',              '', ...
         'Style',               'text');

      ud.pause_btn = uicontrol(h, ...
         'Callback', @wbtoggle_pause, ...
         'Enable',   'on', ...
         'Position', [10 10 100 25], ...
         'Style',    'togglebutton', ...
         'String',   'Pause');
      ud.cancel_btn = uicontrol(h, ...
         'Callback', @wbpress_cancel, ...
         'Enable',   'on', ...
         'Position', [120 10 110 25], ...
         'Style',    'pushbutton', ...
         'String',   'Cancel');

      ud.time   = clock;
      ud.inc    = clock;
      ud.status = 'OK';
      set(h, 'UserData',      ud, ...
         'HandleVisibility', 'off')

   case 'Update Progress'
      ud = get(h, 'UserData');

      status = ud.status;
      if ~strcmp(status, 'OK')
         close(h)
         evalin('caller', 'error(''Action Canceled'')')
      end

      % Calculate time increment since last update in seconds
      inc = clock - ud.inc;
      inc = inc(3)*3600*24 + inc(4)*3600 + inc(5)*60 + inc(6);

      % Only update at update_rate or 100% completion
      if inc>=update_rate  ||  all(progress>=1)

         % Calculate total elapsed time in seconds
         t_past = clock - ud.time;
         t_past = t_past(3)*3600*24 + t_past(4)*3600 + t_past(5)*60 + t_past(6);

         % Estimate remaining time in seconds of bottom progress bar
         if progress(end)>0
            t_remain = t_past*(1/progress(end)-1);
         else
            t_remain = 0;
         end

         % Display elapsed and remaining time
         set(ud.elapsed_time, 'String', getTimeStr(t_past));
         set(ud.remain_time,  'String', getTimeStr(t_remain))

         for i=1:length(progress)
            if progress(i)<=1
               set(ud.bar(i), ...
                  'FaceColor', 'g', ...
                  'XData', [0 0 1 1 0]*progress(i))
               str = sprintf('%1.0f%%', floor(100*progress(i)));
            else
               set(ud.bar(i), ...
                  'FaceColor', 'r', ...
                  'XData',     [0 0 1 1 0])
               str = sprintf('Over %1.0f%%', 100);

            end
            set(ud.msg_prcnt(i), 'String', str)

         end

         if exist('message', 'var')==1
            for i=1:length(message)
               set(ud.msg(i), 'String', message{i});
            end
         end
         if exist('name', 'var')==1
            set(h, 'Name', name)
         end

         ud.inc = clock;
         set(h, 'UserData', ud)
      end

      drawnow

end

% If handle is not requested, do not output it
if nargout==0,  clear h, end

%-----------------------------------------
function str = getTimeStr(seconds)
if seconds<=60
   str = sprintf('%1.1f secs', seconds);
elseif seconds>60 && seconds<3600
   str = sprintf('%i mins, %i secs',  fix(seconds/60),   round(60*rem(seconds/60,1)));
else
   str = sprintf('%i hours, %i mins', fix(seconds/3600), round(60*rem(seconds/3600,1)));
end

%-----------------------------------------
function wbpress_cancel(h, eventStruct)
h_fig = gcbf;
ud = get(h_fig, 'UserData');
ud.status = 'Action Canceled';
set(h_fig, 'UserData', ud)

%-----------------------------------------
function wbtoggle_pause(h, eventStruct)
button_state = get(h, 'Value');
if button_state == get(h, 'Max')
   % toggle button is pressed
   set(h, ...
      'String', 'Resume')
   waitfor(h, 'Value')
elseif button_state == get(h,'Min')
   % toggle button is not pressed
   set(h, ...
      'String', 'Pause')
end

%-----------------------------------------
function progbardemo

% Title of Progress Bar Window
name    = 'Processing';
% List of processes to keep track of
message = {'Scans', 'Clusers'};
Loop1  = 10;
Loop2  = 5000;

% Initialize the progress bar
hProg = progressBar(message, name);

for i=1:Loop1
   for j = 1:Loop2
      message = {...
         sprintf('Process 1:  Iteration %1.0f of %1.0f', i, Loop1); ...
         sprintf('Process 2:  Iteration %1.0f of %1.0f', j, Loop2)};
      progressBar(hProg, ...
         'prcnt',  [i/Loop1, j/Loop2], ...
         'msg',    message, ...
         'update', .2);
   end
end
close(hProg)
