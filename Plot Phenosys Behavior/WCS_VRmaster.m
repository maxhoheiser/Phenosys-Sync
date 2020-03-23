function WCS_VRmaster

%% UserDefined Header Information
FirstHeaderPos = 'newpos';
LastHeaderPos = 'nRIGHTlast26T_I';

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

[HeaderFile, ~] = uigetfile({'*.txt'},...
    'Select File containing Headers', ...
    'MultiSelect', 'off');


%% Pregenerating figure
figure('Name','VR Online Analysis','NumberTitle','off');
set(gcf, 'Position', get(0, 'Screensize'));

sp1 = subplot(331);
plot(1:100,rand(100,1),'-k','LineWidth',1);hold on
plot(1:100,rand(100,1),'-k','LineWidth',2);
plot(1:100,rand(100,1),'-r','LineWidth',1);
plot(1:100,rand(100,1),'-b','LineWidth',1);
title('Correct, {\color{red}ColorAcorrect}, {\color{blue}ColorBcorrect}');
set(sp1, 'YLim', [0 1.2]);

sp2 = subplot(338);
plot(1:100,rand(100,1),'-k','LineWidth',1);hold on
plot(1:100,rand(100,1),'-k','LineWidth',1);
title('TrialRate');

sp3 = subplot(334);
plot(1:100,rand(100,1),'-k','LineWidth',1);hold on
plot(1:100,rand(100,1),'-k','LineWidth',1);
plot(1:100,rand(100,1),'-r','LineWidth',1);
plot(1:100,rand(100,1),'-b','LineWidth',1);
title('Rewarded, {\color{red}LeftChoice}, {\color{blue}RightChoice}');
set(sp3, 'YLim', [0 1.2]);

sp4 = subplot(335);
plot(1:100,rand(100,1),'-k','LineWidth',1);hold on
plot(1:100,rand(100,1),'-r','LineWidth',1);
plot(1:100,rand(100,1),'-b','LineWidth',1);
title('{\color{red}LeftRewarded}, {\color{blue}RightRewarded}');
set(sp4, 'YLim', [0 1.2]);

sp5 = subplot(336);
plot(1:100,rand(100,1),'-k','LineWidth',1);hold on
plot(1:100,rand(100,1),'-r','LineWidth',1);
plot(1:100,rand(100,1),'-b','LineWidth',1);
title('{\color{red}LeftCumReward}, {\color{blue}RightCumReward}');
set(sp5, 'YLim', [0 1.2]);

sp6 = subplot(332);
plot(1:100,rand(100,1),'-k','LineWidth',1);hold on
plot(1:100,rand(100,1),'-r','LineWidth',1);
plot(1:100,rand(100,1),'-b','LineWidth',1);
title('{\color{red}WinStay}, {\color{blue}LooseShift}');
set(sp6, 'YLim', [0 1.2]);

sp7 = subplot(337);
plot(1:100,rand(100,1),'-k','LineWidth',1);hold on
plot(1:100,rand(100,1),'-k','LineWidth',1);
title('NoResponse');
set(sp7, 'YLim', [0 1.2]);

sp8 = subplot(333);
plot([0 1],[0 1],'--k','LineWidth',1);hold on
plot([1 2],[1 2],'--r','LineWidth',1);
set(sp8.Title, 'String', 'sp8', 'FontSize', 8, 'Color', 'k', 'FontName', 'arial', 'fontweight', 'bold');

sp9 = subplot(339);
plot([0 1],[0 1],'--k','LineWidth',1);hold on
plot([1 2],[1 2],'--r','LineWidth',1);
set(sp9.Title, 'String', 'sp9', 'FontSize', 8, 'Color', 'k', 'FontName', 'arial', 'fontweight', 'bold');

%% Running Analysis
% VRpreprocessing(Task, UseHeader, FileName, FilePath, HeaderFile, FirstHeaderPos, LastHeaderPos)

while(ishandle(ButtonHandle))
    VRpreprocessing('WCS', 'yes', FileName, FilePath, HeaderFile, FirstHeaderPos, LastHeaderPos)
    pause(0.1)
end
disp('-------------------------------------------------------');
disp('Loop stopped by user');
disp('-------------------------------------------------------');

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