function IGT_VRmaster

%% UserDefined Header Information
% FirstHeaderPos = 'eventDuration';
% LastHeaderPos = 'MsgValue3';

close all
warning('off')

%% GUI to stop analysis
StopLoop = figure;
WinOnTop(StopLoop, true);
set(gcf, 'Position', [100 100 100 100]);
set (gcf, 'Toolbar', 'none');
set (gcf, 'Menubar', 'none');

ButtonHandle = uicontrol('Style', 'PushButton', 'String', 'Stop Loop', 'Callback', 'delete(gcbf)');

%% User defined File Input
[FileName, FilePath] = uigetfile({'*.csv'},...
    'Select File containing State Sequence and Trial Identifiers', ...
    'MultiSelect', 'off');

% [HeaderFile, ~] = uigetfile({'*.txt'},...
%     'Select File containing Headers', ...
%     'MultiSelect', 'off');

%% Running Analysis
cont = 1;
FigureSetLoaded = 1;
while(1)
    % VRpreprocessing(Task, UseHeader, FileName, FilePath, HeaderFile, FirstHeaderPos, LastHeaderPos)
    [BehTrials] = VRpreprocessing('IGT', 'no', FileName, FilePath, [], [], []);
    
    if cont == 1
        if exist('Ftemp1','var') == 0
            Ftemp1=figure(2);
            Ftemp2=figure(3);
            Ftemp3=figure(4);
        end
        cont = cont + 1;
    else
        close(Ftemp1)
        close(Ftemp2)
        close(Ftemp3)
        if FigureSetLoaded == 1
            Ftemp1=figure(5);
            Ftemp2=figure(6);
            Ftemp3=figure(7);
            FigureSetLoaded = 2;
        else
            Ftemp1=figure(2);
            Ftemp2=figure(3);
            Ftemp3=figure(4);
            FigureSetLoaded = 1;
        end
    end
    pause(10)
    
    if ~ishandle(ButtonHandle)
        save([FilePath,FileName(1:end-4),'.mat'],'BehTrials');
        disp('-------------------------------------------------------');
        disp('Loop stopped by user');
        disp('Behaviour Data Saved');
        disp('-------------------------------------------------------');
        break;
    end
    
end

end

function wasOnTop = WinOnTop(figureHandle, isOnTop)
%WINONTOP allows to trigger figure's "Always On Top" state
%
%% INPUT ARGUMENTS:
%
% # figureHandle - Matlab's figure handle, scalar
% # isOnTop      - logical scalar or empty array
%
%
%% USAGE:
%
% * WinOnTop( hfigure, true );      - switch on  "always on top"
% * WinOnTop( hfigure, false );     - switch off "always on top"
% * WinOnTop( hfigure );            - equal to WinOnTop( hfigure,true);
% * WinOnTop();                     - equal to WinOnTop( gcf, true);
% * WasOnTop = WinOnTop(...);       - returns boolean value "if figure WAS on top"
% * isOnTop = WinOnTop(hfigure,[])  - get "if figure is on top" property
%
%
%% LIMITATIONS:
%
% * java enabled
% * figure must be visible
% * figure's "WindowStyle" should be "normal"
% * figureHandle should not be casted to double, if using HG2 (R2014b+)
%
%
% Written by Igor
% i3v@mail.ru
%
% 2013.06.16 - Initial version
% 2013.06.27 - removed custom "ishandle_scalar" function call
% 2015.04.17 - adapted for changes in matlab graphics system (since R2014b)
% 2016.05.21 - another ishg2() checking mechanism 
% 2016.09.24 - fixed IsOnTop vs isOnTop bug

%% Parse Inputs

if ~exist('figureHandle','var'); figureHandle = gcf; end

assert(...
          isscalar(  figureHandle ) &&...
          ishandle(  figureHandle ) &&...
          strcmp(get(figureHandle,'Type'),'figure'),...
          ...
          'WinOnTop:Bad_figureHandle_input',...
          '%s','Provided figureHandle input is not a figure handle'...
       );

assert(...
            strcmp('on',get(figureHandle,'Visible')),...
            'WinOnTop:FigInisible',...
            '%s','Figure Must be Visible'...
       );

assert(...
            strcmp('normal',get(figureHandle,'WindowStyle')),...
            'WinOnTop:FigWrongWindowStyle',...
            '%s','WindowStyle Must be Normal'...
       );
   
if ~exist('isOnTop','var'); isOnTop=true; end

assert(...
          islogical( isOnTop ) && ...
          isscalar(  isOnTop ) || ...
          isempty(   isOnTop ),  ...
          ...
          'WinOnTop:Bad_isOnTop_input',...
          '%s','Provided isOnTop input is neither boolean, nor empty'...
      );
  
  
%% Pre-checks

error(javachk('swing',mfilename)) % Swing components must be available.
  
  
%% Action

% Flush the Event Queue of Graphic Objects and Update the Figure Window.
drawnow expose

warnStruct=warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jFrame = get(handle(figureHandle),'JavaFrame');
warning(warnStruct.state,'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');

drawnow


if ishg2(figureHandle)
    jFrame_fHGxClient = jFrame.fHG2Client;
else
    jFrame_fHGxClient = jFrame.fHG1Client;
end


wasOnTop = jFrame_fHGxClient.getWindow.isAlwaysOnTop;

if ~isempty(isOnTop)
    jFrame_fHGxClient.getWindow.setAlwaysOnTop(isOnTop);
end

end
function tf = ishg2(figureHandle)
% There's a detailed discussion, how to check "if using HG2" here:
% http://www.mathworks.com/matlabcentral/answers/136834-determine-if-using-hg2
% however, it looks like there's no perfect solution.
%
% This approach, suggested by Cris Luengo:
% http://www.mathworks.com/matlabcentral/answers/136834#answer_156739
% should work OK, assuming user is NOT passing a figure handle, casted to
% double, like this:
%
%   hf=figure();
%   WinOnTop(double(hf));
%

tf = isa(figureHandle,'matlab.ui.Figure');

end