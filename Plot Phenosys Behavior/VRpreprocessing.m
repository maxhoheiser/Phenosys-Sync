function [BehTrials] = VRpreprocessing(Task, UseHeader, FileName, FilePath, HeaderFile, FirstHeaderPos, LastHeaderPos)

%% Input definition:
% Header needs to be txt file, columns seperated by ';'

%% User defined parameters
ExternalFileSelect = 'ON';
FileSelect = 'OFF';
HeaderDeliminator = ';';
ZeroAngle = 270;
LeftAngle = 246;
RightAngle = 294;
WindowSize = 20;
Overlap = 100;
SanityPrompt = 'OFF';
SaveOutputStructure = 'OFF';
States2RemoveUpStream = {'wheel is not stopping'};

%% Defining State Sequence Paramters (most likely task dependent)
if strcmp(Task,'WCS') == 1
    StateNames = {'TIstarts'; ...
        'IND-CUE_pres_start'; ...
        'SOUND_start'; ...
        'resp-time-window_start'; ...
        'rewPERIODstart'; ...
        'PRPstarts'; ...
        'ITIstarts'; ...
        'wheelISnotSTOPPING'; ...
        'NOresponse'; ...
        'TimeOUTstarts'; ...
        'End'};
    OutcomeStateIdentifiers = [4,5,8,9,11];
    StateNamesFriendly = StateNames;
    StateNamesFriendly{strcmp(StateNamesFriendly,'IND-CUE_pres_start')} = 'IndCue';
    StateNamesFriendly{strcmp(StateNamesFriendly,'resp-time-window_start')} = 'RespTimeWin';
    
elseif strcmp(Task,'IGT') == 1
    StateNames = {'TIstarts'; ...
        'IND-CUE_pres_start'; ...
        'SOUND_start'; ...
        'resp-time-window_start'; ...
        'left_rewarded'; ...
        'left_NOreward'; ...
        'right_rewarded'; ...
        'right_NOreward'; ...
        'no response in time'; ...
        'ITIstarts'; ...
        'ITIends'; ...
        'wheel is not stopping'; ...
        'End'};
    OutcomeStateIdentifiers = [4,5,6,7,8,9,12,13];
    StateNamesFriendly = StateNames;
    StateNamesFriendly{strcmp(StateNamesFriendly,'IND-CUE_pres_start')} = 'IndCue';
    StateNamesFriendly{strcmp(StateNamesFriendly,'resp-time-window_start')} = 'RespTimeWin';
    StateNamesFriendly{strcmp(StateNamesFriendly,'no response in time')} = 'NoResponse';
    StateNamesFriendly{strcmp(StateNamesFriendly,'wheel is not stopping')} = 'WheelNotStopping';
end

%% ProcessingTime
tic
disp('VR preprocessing');
disp('-------------------------------------------------------');

%% Loading Data
if strcmp(FileSelect, 'ON') == 1
    %% Loading State Data
    [StateFile, FilePath] = uigetfile({'*.csv;*.txt;*.xlsx'},...
        'Select Behaviour File containing State Sequence', ...
        'MultiSelect', 'on');
    
    %% Loading Header Data
    [HeaderFile, ~] = uigetfile('*.txt;*.xlsx',...
        'Select the Text Header', ...
        'MultiSelect', 'on');
    
    %% Loading Behavioural Data
    [BFile, ~] = uigetfile('*.csv; *.xlsx',...
        'Select the Behaviour File containing Trial Identifiers', ...
        'MultiSelect', 'on');

elseif strcmp(ExternalFileSelect, 'ON') == 1
    StateFile = FileName;
    BFile = FileName;

else
    csvDIR = dir('*.csv');
    txtDIR = dir('*.txt');
    StateFile = csvDIR.name;
    FilePath = csvDIR.folder;
    HeaderFile = txtDIR.name;
    BFile = csvDIR.name;
end

%% Checking File Format
if iscell(StateFile)
    [~,FileName,format] = fileparts(StateFile{1});
else
    [~,FileName,format] = fileparts(StateFile);
end

%% First organising step: matching timestamps and states
if strcmp(format,'.csv') == 1
    Conversion2sec = 24*60*60;
    Data = readtable(StateFile);
    Cell1 = table2cell(Data);
    
    %% This is to check whether trials need to be excluded (i.e. after Ending of Session or incomplete trials)
    Cont1 = cell2mat(cellfun(@(x) contains(strrep(x,x(1),''),'end'), Cell1, 'uniformoutput', false));
    Cont2 = cell2mat(cellfun(@(x) contains(strrep(x,x(1),''),'Control'), Cell1, 'uniformoutput', false));
    Cont3 = Cont1 == 1 & Cont2 == 1;
    LastTrial2Take = find(Cont3 == 1,1,'last');
    if isempty(LastTrial2Take) == 1
        Cont4 = cell2mat(cellfun(@(x) contains(strrep(x,x(1),''),'ITIends'), Cell1, 'uniformoutput', false));
        LastTrial2Take = find(Cont4 == 1,1,'last');
        Cell1 = {Cell1{1:LastTrial2Take}}';
        Cell1 = [Cell1;{Cell1{end-3:end}}'];
        WhSp = Cell1{1};
        Cell1{end-2}(end-23:end) = [];
        Cell1{end-2} = [Cell1{end-2},['T',WhSp,'I',WhSp,'s',WhSp,'t',WhSp,'a',WhSp,'r',WhSp,'t',WhSp,'s',WhSp,';',WhSp,';',WhSp,';',WhSp]];
        Cell1{end}(end-45:end) = [];
        Cell1{end} = [Cell1{end},['C',WhSp,'o',WhSp,'n',WhSp,'t',WhSp,'r',WhSp,'o',WhSp,'l',WhSp,';',WhSp,';',WhSp,';',WhSp,';',WhSp,';',WhSp,';',WhSp,';',WhSp,';',WhSp,';',WhSp,';',WhSp,'e',WhSp,'n',WhSp,'d',WhSp,';',WhSp,';',WhSp,';',WhSp]];  
    else
        Cell1 = {Cell1{1:LastTrial2Take}}';
    end
        
    [TimeStampsTemp, StatesTemp] = cellfun(@(x) ExtractTimeStamps(x), Cell1, 'uniformoutput', false);
    TimeStamps = TimeStampsTemp(any(cellfun(@(x)any(~isnan(x)),TimeStampsTemp),2),:);
    States = StatesTemp(any(cellfun(@(x)any(~isnan(x)),StatesTemp),2),:);

elseif strcmp(format,'.txt') == 1
    Conversion2sec = 24*60*60;
    TimeStamps2 = importdata(StateFile{1,3});
    TimeStamps = num2cell(TimeStamps2);
    States2 = importdata(StateFile{1,1});
    StatesMeta = importdata(StateFile{1,2});
    States = cellfun(@(x1,x2) IntegratingStatesMeta(x1,x2), States2, StatesMeta, 'uniformoutput', false);
    
elseif strcmp(format,'.xlsx') == 1
    Conversion2sec = 24*60*60;
    [ExcelData, ExcelText] = xlsread(StateFile);
    StatesTemp = {ExcelText{3:end,4}}';
    States = {ExcelText{3:end,14}}';
    States(contains(StatesTemp,'Control') & contains(States,'start')) = {'ProtocolStart'};
    States(contains(States,'end')) = {'End'};
    TimeStamps = num2cell(ExcelData(:,1));
    
end

%% This step removes Protocols that dont contain any trials
StatesTemp2 = States;
TimeStampsTemp2 = TimeStamps;
OnePastStart = find(contains(States,'ProtocolStart'))+1;
OnePastStart2ExcludeIndex = find(contains(States(OnePastStart),'End'));
OnePastStart2Exclude = OnePastStart(OnePastStart2ExcludeIndex);
StatesTemp2(OnePastStart2Exclude-1:OnePastStart2Exclude) = [];
TimeStampsTemp2(OnePastStart2Exclude-1:OnePastStart2Exclude) = [];
States = StatesTemp2;
TimeStamps = TimeStampsTemp2;

%% This step removes StartState after ProtocolStart
StatesTemp2 = States;
TimeStampsTemp2 = TimeStamps;
OnePastStart = find(contains(States,'ProtocolStart'))+1;
OnePastStart2ExcludeIndex = strcmp(States(OnePastStart),'start');
OnePastStart2Exclude = OnePastStart(OnePastStart2ExcludeIndex);
StatesTemp2(OnePastStart2Exclude) = [];
TimeStampsTemp2(OnePastStart2Exclude) = [];
States = StatesTemp2;
TimeStamps = TimeStampsTemp2;

%% This step removes States that should be excluded from further analysis
StatesTemp2 = States;
StatesTemp2([find(contains(States,States2RemoveUpStream));find(contains(States,States2RemoveUpStream))-1]) = [];
TimeStampsTemp2 = TimeStamps;
TimeStampsTemp2([find(contains(States,States2RemoveUpStream));find(contains(States,States2RemoveUpStream))-1]) = [];
States = StatesTemp2;
TimeStamps = TimeStampsTemp2;

%% Converting from fraction of a day to seconds
StateDurations = num2cell([diff(cell2mat(TimeStamps)*Conversion2sec);0]);

%% This is to check whether there are invalid State Durations (due to incomplete DataSet), if invalid I fix them to the previous trial
Last2ITIends = find(ismember(States,'ITIends'),2,'last');
if ~isempty(Last2ITIends)
    StateDurations(Last2ITIends(2)) = StateDurations(Last2ITIends(1));
end
Last2ITIstarts = find(ismember(States,'TIstarts'),2,'last');
StateDurations(Last2ITIstarts(2)) = StateDurations(Last2ITIstarts(1));
StateDurations(ismember(States,'End')) = {1};
TotalDurationSec = (cell2mat(TimeStamps(end))-cell2mat(TimeStamps(1)))*Conversion2sec;

%% Second organising step: Breaking StateSequence into individual trials
TrialStartIndices = find(strcmp(States,StateNames{1}) == 1);
TrialEndIndices = [TrialStartIndices(2:end)-1;length(States)];
EndStates = find(strcmp(States,StateNames{end}) == 1);
OutcomeStateIndicesCell = arrayfun(@(x) find(strcmp(States,StateNames{x}) == 1), ...
    OutcomeStateIdentifiers, 'uniformoutput', false);
OutcomeStateIdentifiersCell = num2cell(OutcomeStateIdentifiers);
OutcomeStateIndicesCellNames = cellfun(@(x1,x2) ones(length(x1),1)*x2, ...
    OutcomeStateIndicesCell, OutcomeStateIdentifiersCell, 'uniformoutput', false);
OutcomeStateIndicesMerged = {cat(1, OutcomeStateIndicesCell{:})};
OutcomeStateIndicesCellNamesMerged = {cat(1, OutcomeStateIndicesCellNames{:})};
OutcomeStateIndicesMergedMatrix = cell2mat(OutcomeStateIndicesMerged);
OutcomeStateIndicesCellNamesMergedMatrix = cell2mat(OutcomeStateIndicesCellNamesMerged);
OutcomeStateIndicesTogether = [OutcomeStateIndicesMergedMatrix, OutcomeStateIndicesCellNamesMergedMatrix];
OutcomeStateIndicesTogetherSorted = sortrows(OutcomeStateIndicesTogether);
OutcomeStateIndicesTogetherSorted(:,3)=[diff(OutcomeStateIndicesTogetherSorted(:,1));0];
OutcomeStateIndicesTogetherSorted(OutcomeStateIndicesTogetherSorted(:,3)==1,:) = [];
OutcomeStateIndices = OutcomeStateIndicesTogetherSorted(:,1);
OutcomeStateIndicesNames = OutcomeStateIndicesTogetherSorted(:,2);
TrialOutcome = arrayfun(@(x) StateNames{x}, OutcomeStateIndicesNames, 'uniformoutput', false);
TrialOutcomeStates = unique(TrialOutcome);
nTrials = length(TrialOutcome);

%% Deal with trials when the Protocol was finsihed within a trial
%% (aka End State that doesnt have its own Start State)
TrialOutcomeForProtocol = TrialOutcome;
EndStatePositions2DealWith = EndStates(strcmp(States(EndStates-1),StateNames{1}) == 0);
for i = 1:length(EndStatePositions2DealWith)
    TrialIndex2DealWith = abs(TrialStartIndices - EndStatePositions2DealWith(i)) ...
        == min(abs(TrialStartIndices - EndStatePositions2DealWith(i)));
    TrialOutcomeForProtocol{TrialIndex2DealWith} = 'End';
end

%% Getting Durations of States and Trials
StateTimes = cell2mat(StateDurations);
TrialTimeReset = arrayfun(@(x1,x2) ResettingTrialTime(x1, x2, StateTimes), ...
    TrialStartIndices, TrialEndIndices, 'uniformoutput', false);
TrialDuration = cell2mat(cellfun(@(x) x(end), TrialTimeReset, 'uniformoutput', false));
IndividualStateTimes = cellfun(@(x) [StateTimes(strcmp(States,x) == 1),find(strcmp(States,x) == 1)], ...
    StateNames, 'uniformoutput', false);
IndStateTimesStruct1 = cell2struct(IndividualStateTimes, StateNamesFriendly);

StateTimesCell = num2cell(StateTimes);
TrialStartIndicesCell = num2cell(TrialStartIndices);
TrialEndIndicesCell = num2cell(TrialEndIndices);

[IndStateDur, ~] = cellfun(@(x1,x2) ExtractingIndStateDur(x1, x2, StateTimesCell, States, StateNames), ...
    TrialStartIndicesCell, TrialEndIndicesCell, 'uniformoutput', false);
IndStateDurMat = cell2mat(IndStateDur)';
IndStateDurReshape = reshape(IndStateDurMat,length(StateNames),[])';
IndStateDurReshapedCell = mat2cell(IndStateDurReshape',ones(length(StateNames),1),nTrials);
IndStateTimesStruct2 = cell2struct(IndStateDurReshapedCell, StateNamesFriendly);
IndStateTimesStruct2 = structfun(@transpose,IndStateTimesStruct2,'uniformoutput', false);

OutcomeStateTimes = arrayfun(@(x) StateTimes(x), OutcomeStateIndices-1, 'uniformoutput', false);
IndOutcomeStateDur = cellfun(@(x) ExtractingIndOutcomeDurations(x,TrialOutcome,IndStateTimesStruct2.RespTimeWin,nTrials), ...
    TrialOutcomeStates, 'uniformoutput', false);

OutputStateDurations.OutcomeStateTimes = cell2mat(OutcomeStateTimes);
OutputStateDurations.IndStateTimesStruct1 = IndStateTimesStruct1;
OutputStateDurations.IndStateTimesStruct2 = IndStateTimesStruct2;

%% Calculating Trial Rate per Minute
CumTrialDuration = cumsum(TrialDuration);
TrialRateHist = histcounts(CumTrialDuration,0:60:max(CumTrialDuration));

%% Adding Outcome States to Output Structure
CellOutput = cellfun(@(x) GeneratrTrialOutcomeVar(x, nTrials, TrialOutcome), TrialOutcomeStates, 'uniformoutput', false);
TrialOutcomeStatesFriendly = TrialOutcomeStates;
if strcmp(Task,'WCS') == 1
    
elseif strcmp(Task,'IGT') == 1
    if ismember('resp-time-window_start',TrialOutcomeStatesFriendly) == 1 
        TrialOutcomeStatesFriendly{strcmp(TrialOutcomeStatesFriendly,'resp-time-window_start')} = 'RespTimeWin';
    else
        BehTrialsTemp2.RespTimeWin(1:nTrials,1) = 0;
    end
    if ismember('no response in time',TrialOutcomeStatesFriendly) == 1 
        TrialOutcomeStatesFriendly{strcmp(TrialOutcomeStatesFriendly,'no response in time')} = 'NoResponse';
    else
        BehTrialsTemp2.NoResponse(1:nTrials,1) = 0;
    end
    if ismember('wheel is not stopping',TrialOutcomeStatesFriendly) == 1 
        TrialOutcomeStatesFriendly{strcmp(TrialOutcomeStatesFriendly,'wheel is not stopping')} = 'WheelNotStopping';
    else
        BehTrialsTemp2.WheelNotStopping(1:nTrials,1) = 0;
    end
end
BehTrials = cell2struct(CellOutput,TrialOutcomeStatesFriendly);
if exist('BehTrialsTemp2', 'var') == 1
    BehTrialsTemp1 = cell2struct(CellOutput,TrialOutcomeStatesFriendly);
    [BehTrials] = MergeStructs(BehTrialsTemp1, BehTrialsTemp2);
end

%% Adding Individual Outcome State Durations to Output Structure
IndOutcomeStateDurations = cell2struct(IndOutcomeStateDur, TrialOutcomeStatesFriendly);
IndOutcomeStateDurations = structfun(@(x) cell2mat(x), IndOutcomeStateDurations, 'uniformoutput', false);
OutputStateDurations.IndOutcomeStateDurations = IndOutcomeStateDurations;

%% Adding to Output Structure
BehTrials.TrialOutcome = TrialOutcome;
BehTrials.TrialOutcomeStates = TrialOutcomeStates;
BehTrials.TotalDurationSec = TotalDurationSec;
BehTrials.StateNames = StateNames;
BehTrials.OutcomeStateIdentifiers = OutcomeStateIdentifiers;
BehTrials.StateTimes = StateTimes;
BehTrials.TrialTimeReset = TrialTimeReset;
BehTrials.TrialDuration = TrialDuration;
BehTrials.Trials = 1:nTrials;
BehTrials.nTrials = nTrials;
BehTrials.Trials = BehTrials.Trials';
BehTrials.TrialRateHist = TrialRateHist;
BehTrials.OutputStateDurations = OutputStateDurations;
BehTrials.StateDurations = StateDurations;

%% Getting raw OutcomeStates
if strcmp(UseHeader,'yes') == 1
    RawTrialOutcomeStates = arrayfun(@(x) States{x+1}, TrialStartIndices, 'uniformoutput', false);
    RawTrialOutcomeStates = cellfun(@(x) strrep(x,'End','end'), RawTrialOutcomeStates, 'uniformoutput', false);
    RawTrialOutcomeStates = unique(RawTrialOutcomeStates);
end

% %% Checking if there are State Names that I cannot deal with
% States = cellfun(@(x) strrep(x,'no response in time','NoResponse'), States, 'uniformoutput', false);

%% Loading BIdentifiers
if strcmp(UseHeader,'yes') == 1
    [BIdentifiersCell, HeaderCell] = ...
        ReadingVRheaderAndBmatrix(HeaderFile, BFile, RawTrialOutcomeStates, States, HeaderDeliminator, EndStatePositions2DealWith, FirstHeaderPos, LastHeaderPos);
end

%% Breaking BIdentifiers into individual trials
if strcmp(UseHeader,'yes') == 1
    if ~isnumeric(BIdentifiersCell{1}(1))
        % Speed optimization
        % BIdenTrialsNumbersCell = cellfun(@(x) str2double(x), BIdentifiersCell, 'uniformoutput', false);
        BIdenTrialsNumbersCell = cellfun(@(x) sscanf(sprintf('%s*', x{:}), '%d*'), ...
            BIdentifiersCell, 'uniformoutput', false);
    else
        BIdenTrialsNumbersCell = BIdentifiersCell;
    end
    PreAlloCell(1:length(BIdenTrialsNumbersCell{1}),1) = NaN;
    BIdenTrialsNumbersCell(contains(TrialOutcome,'End')) = {PreAlloCell};
    BIdenTrialsNumbersArray = cell2mat(BIdenTrialsNumbersCell);
    BIdenTrialsNumbersResh = reshape(BIdenTrialsNumbersArray,length(BIdenTrialsNumbersCell{1}),nTrials);
    BIdenTrialsNumbersTransp = transpose(BIdenTrialsNumbersResh);
    BIdenTrialsNumbersTCell = mat2cell(BIdenTrialsNumbersTransp, nTrials, ones(length(BIdenTrialsNumbersCell{1}),1));
    BIdenTrialsNumbersTCellTransp = transpose(BIdenTrialsNumbersTCell);
    BehTrials2 = cell2struct({BIdenTrialsNumbersTCellTransp{1:length(BIdenTrialsNumbersTCellTransp)}}', ...
        {HeaderCell{1:length(BIdenTrialsNumbersTCellTransp)}});
    BehTrials = MergeStructs(BehTrials, BehTrials2);
end

%% Number of Protocols registered
nProtocols = length(find(strcmp(States,'ProtocolStart')==1));
ProtocolEndIndices = find(ismember(TrialOutcomeForProtocol,'End'));
% ProtocolEndIndicesAloneWithinTrial = find(ismember(TrialOutcome,'End'));
ProtocolStartIndices = [1;ProtocolEndIndices(1:end-1)+1];
ProtocolCounter = (1:nProtocols)';
Protocol = arrayfun(@(x1,x2,x3) AssignProtocol(x1,x2,x3,nTrials), ...
    ProtocolStartIndices, ProtocolEndIndices, ProtocolCounter, 'uniformoutput', false);
Protocol=cell2mat(Protocol);
Protocol=Protocol(Protocol~=0);

%% Making sure all Outcome varibales are complete
BehTrials = cellfun(@(x) ExistField(x,BehTrials),TrialOutcomeStatesFriendly, 'uniformoutput', false);
BehTrials = BehTrials{end};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% General Analysis
%% Adding conditions to the Output Structure that have zero incidences
LeftTrialOutcomeStatesIndices = find(contains(TrialOutcomeStates,'left')==1);
RightTrialOutcomeStatesIndices = find(contains(TrialOutcomeStates,'right')==1);

if exist('LeftTrialOutcomeStatesIndices', 'var')
    if length(LeftTrialOutcomeStatesIndices) > length(RightTrialOutcomeStatesIndices)
        St1 = [TrialOutcomeStates{RightTrialOutcomeStatesIndices}];
        St2 = [TrialOutcomeStates{LeftTrialOutcomeStatesIndices}];
        St3 = strrep(St1,'right','');
        St4 = strrep(St2,'left','');
        St5 = strrep(St4,St3,'');
        St6 = ['right',St5];
        eval(['BehTrials.',St6,'(1:nTrials,1)=0;']);
        eval(['BehTrials.OutputStateDurations.IndOutcomeStateDurations.',St6,'(1:nTrials,1)=0;']);
        
    elseif length(LeftTrialOutcomeStatesIndices) < length(RightTrialOutcomeStatesIndices)
        St1 = [TrialOutcomeStates{LeftTrialOutcomeStatesIndices}];
        St2 = [TrialOutcomeStates{RightTrialOutcomeStatesIndices}];
        St3 = strrep(St1,'left','');
        St4 = strrep(St2,'right','');
        St5 = strrep(St4,St3,'');
        St6 = ['left',St5];
        eval(['BehTrials.',St6,'(1:nTrials,1)=0;']);
        eval(['BehTrials.OutputStateDurations.IndOutcomeStateDurations.',St6,'(1:nTrials,1)=0;']);
    end
end

%% Adding ChosenDirection and CorrectChoice
if sum(contains(TrialOutcomeStates,'left')) > 0 || sum(contains(TrialOutcomeStates,'right')) > 0
    BehTrials.LeftChoice(1:nTrials,1) = NaN;
    BehTrials.LeftChoice(BehTrials.left_NOreward == 1 | BehTrials.left_rewarded == 1) = 1;
    BehTrials.LeftChoice(BehTrials.right_NOreward == 1 | BehTrials.right_rewarded == 1) = 0;
    
    BehTrials.RightChoice(1:nTrials,1) = NaN;
    BehTrials.RightChoice(BehTrials.right_NOreward == 1 | BehTrials.right_rewarded == 1) = 1;
    BehTrials.RightChoice(BehTrials.left_NOreward == 1 | BehTrials.left_rewarded == 1) = 0;
    
elseif isfield(BehTrials, 'corrAngle')
    BehTrials.LeftChoice(1:nTrials,1) = NaN;
    BehTrials.LeftChoice(BehTrials.chosenSIDE == LeftAngle) = 1;
    BehTrials.LeftChoice(BehTrials.chosenSIDE == RightAngle) = 0;
    
    BehTrials.RightChoice(1:nTrials,1) = NaN;
    BehTrials.RightChoice(BehTrials.chosenSIDE == RightAngle) = 1;
    BehTrials.RightChoice(BehTrials.chosenSIDE == LeftAngle) = 0;
end

%% Adding to Output Structure
BehTrials.nProtocols = nProtocols;
BehTrials.Protocol = Protocol;
BehTrials.ZeroAngle = ZeroAngle;
BehTrials.LeftAngle = LeftAngle;
BehTrials.RightAngle = RightAngle;

%% Extracting Task specific MetaInformation
if strcmp(Task,'IGT') == 1
    [DropsReceived, GambleProb, GambleArm] = cellfun(@(x) ExtractIGTmeta(x, TrialOutcomeStates), Cell1, 'uniformoutput', false);
    Cells2Delete = cell2mat(cellfun(@(x) isnan(x), DropsReceived, 'uniformoutput', false));
    
    TrialOutcomeOnlyRewStatesIndices = find(contains(TrialOutcome,{'left_rewarded'; ...
        'left_NOreward'; ...
        'right_rewarded'; ...
        'right_NOreward'; ...
        'no response in time';
        'wheel is not stopping'}));
    
    DropsReceived(Cells2Delete) = [];
    DropsReceived = cell2mat(DropsReceived);
    DropsReceivedAllTrials(1:BehTrials.nTrials,1) = NaN;
    DropsReceivedAllTrials(TrialOutcomeOnlyRewStatesIndices,1) = DropsReceived;
    BehTrials.DropsReceivedAllTrials = DropsReceivedAllTrials;
    
    GambleProb(Cells2Delete) = [];
    GambleProb = cell2mat(GambleProb);
    GambleProb(GambleProb == 12) = 12.5;
    GambleProbAllTrials(1:BehTrials.nTrials,1) = NaN;
    GambleProbAllTrials(TrialOutcomeOnlyRewStatesIndices,1) = GambleProb;
    BehTrials.GambleProbAllTrials = GambleProbAllTrials;
    
    GambleArm(Cells2Delete) = [];
    GambleArm = cell2mat(GambleArm);
    GambleArmAllTrials(1:BehTrials.nTrials,1) = NaN;
    GambleArmAllTrials(TrialOutcomeOnlyRewStatesIndices,1) = GambleArm;
    GambleArmAllTrialsCell = cell(length(GambleArmAllTrials),1);
    GambleArmAllTrialsCell(GambleArmAllTrials == 1) = {'LEFT'};
    GambleArmAllTrialsCell(GambleArmAllTrials == 2) = {'RIGHT'};
    BehTrials.GambleArmAllTrialsCell(isnan(GambleArmAllTrials) == 1) = {NaN};
    BehTrials.GambleArmAllTrialsCell = GambleArmAllTrialsCell;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Saving Output
if strcmp(SaveOutputStructure, 'ON') == 1
    
    %% Generating Output Structure, AllStates
    BehAllStates.OriginalTimeStamps = cell2mat(TimeStamps);
    BehAllStates.StateDurations = cell2mat(StateDurations);
    BehAllStates.TrialTimeReset = cell2mat(TrialTimeReset);
    BehAllStates.States = States;
    
    %% Generating Output Cell, AllStates
    BehAllStatesCell = [TimeStamps,StateDurations,TrialTimeReset,States];

    save([FilePath,FileName,'.mat'],'BehTrials', 'BehAllStates', 'BehAllStatesCell')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Online Analysis
if strcmp(Task,'WCS') == 1
    [BehTrials] = TrialConditionsWCS(BehTrials);

elseif strcmp(Task,'IGT') == 1
    [BehTrials] = TrialConditionsIGT(BehTrials);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Online Plotting
if strcmp(Task,'WCS') == 1
    disp('WCS Online Analysis');
    disp('-------------------------------------------------------');
    WCSonline(BehTrials, WindowSize, Overlap)
elseif strcmp(Task,'IGT') == 1
    disp('IGT Online Analysis');
    disp('-------------------------------------------------------');
    IGTonline(BehTrials)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Offline Analysis
% disp('IGT Analysis');
% disp('-------------------------------------------------------');
% IGTanalysis(BehTrials, States, StateDurations,ProtocolStartIndices)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sanity check
if strcmp(SanityPrompt, 'ON') == 1
    disp(['TrainingSession took: ', num2str(round(BehTrials.SessionDurationSec/60)),' min']);
    disp('-------------------------------------------------------');
    disp(['TrainingSession had: ', num2str(BehTrials.nTrials),' trials']);
    disp('-------------------------------------------------------');
    disp(['TrainingSession had: ', num2str(BehTrials.nProtocols),' protocol(s)']);
    disp('-------------------------------------------------------');
    disp(['Headers used: ',UseHeader]);
    disp('-------------------------------------------------------');
    disp('Outcome conditions detected: ...');
    disp(BehTrials.TrialOutcomeStates)
    disp('-------------------------------------------------------');
end
disp(['That took: ',num2str(toc),' sec']);
disp('-------------------------------------------------------');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cell Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [TimeStamp, State] = ExtractTimeStamps(CellInput)
    if length(CellInput) > 1
        if isnan(str2double(CellInput(2))) == 0
            Wsp = CellInput(1);
            
            TimeStamp = CellInput(1:find(CellInput==';',1,'first')-1);
            TimeStamp = str2double(strrep(TimeStamp,Wsp,''));
            
            StartIndex = strfind(CellInput,['e',Wsp,'x',Wsp,'p'])+26;
            CheckIfEnd = strfind(CellInput,['e',Wsp,'n',Wsp,'d']);
            if isempty(StartIndex) == 0
                SubString = extractAfter(CellInput,StartIndex-1);
                EndIndex = StartIndex+find(SubString == ';',1,'first')-2;
                State = CellInput(StartIndex:EndIndex);
                State = strrep(State,Wsp,'');
            elseif isempty(CheckIfEnd) == 0
                State = 'End';
            else
                State = 'ProtocolStart';
            end
        
        else
            TimeStamp = NaN;
            State = NaN;
        end
    else
        TimeStamp = NaN;
        State = NaN;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [DropsReceived, GambleProb, GambleArm] = ExtractIGTmeta(CellInput, TrialOutcomeStates)
    if length(CellInput) > 1
        if isnan(str2double(CellInput(2))) == 0
            Wsp = CellInput(1);
            
            TimeStamp = CellInput(1:find(CellInput==';',1,'first')-1);
            TimeStamp = str2double(strrep(TimeStamp,Wsp,''));
            
            StartIndex = strfind(CellInput,['e',Wsp,'x',Wsp,'p'])+26;
            CheckIfEnd = strfind(CellInput,['e',Wsp,'n',Wsp,'d']);
            if isempty(StartIndex) == 0
                SubString = extractAfter(CellInput,StartIndex-1);
                EndIndex = StartIndex+find(SubString == ';',1,'first')-2;
                State = CellInput(StartIndex:EndIndex);
                State = strrep(State,Wsp,'');
                if contains(State,TrialOutcomeStates) == 1
                   SubString2 = extractAfter(CellInput,EndIndex);
                   SubString3 = strrep(SubString2,Wsp,'');
                   if contains(State,'NO') == 1
                       DropsReceived = 0;
                   else
                       if contains(SubString3,'drops') == 1
                           DropsString = SubString3(strfind(SubString3,'drops')+5);
                           DropsReceived = str2double(DropsString);
                       else
                           DropsReceived = NaN;
                       end
                   end
                   if contains(SubString3,'gambREWprob') == 1
                      GambleProbString = SubString3(strfind(SubString3,'gambREWprob')+11:strfind(SubString3,'gambREWprob')+12);
                      GambleProb = str2double(GambleProbString);
                   else
                      GambleProb = NaN;
                   end
                   if contains(SubString3,'GAMBarm') == 1
                      SubString4 = SubString3(strfind(SubString3,'GAMBarm')+7:strfind(SubString3,'GAMBarm')+11);
                      if strcmp(SubString4,'LEFT') == 1
                         GambleArm = 1;
                      else
                         GambleArm = 2;
                      end
                   else
                      GambleArm = NaN;
                   end
                else
                    DropsReceived = NaN;
                    GambleArm = NaN;
                    GambleProb = NaN;
                end
            elseif isempty(CheckIfEnd) == 0
                State = 'End';
                DropsReceived = NaN;
                GambleArm = NaN;
                GambleProb = NaN;
            else
                State = 'ProtocolStart';
                DropsReceived = NaN;
                GambleArm = NaN;
                GambleProb = NaN;
            end
        
        else
            DropsReceived = NaN;
            GambleArm = NaN;
            GambleProb = NaN;
        end
    else
        DropsReceived = NaN;
        GambleArm = NaN;
        GambleProb = NaN;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function BehTrials = ExistField(Input, BehTrials)

if isfield(BehTrials,Input) == 0
    eval(['BehTrials.',Input,'(1:BehTrials.nTrials,1) = 0;']);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Output = ChosenDirection(LeftTrialOutcomeStatesIndices, TrialOutcomeStates, BehTrials, Side)

eval(['Output = Side + BehTrials.',TrialOutcomeStates{LeftTrialOutcomeStatesIndices},';']);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function TrialTimeReset = ResettingTrialTime(TrialStartIndices, TrialEndIndices, TrialTime)

TrialTimeReset = cumsum(TrialTime(TrialStartIndices:TrialEndIndices));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CellOutput = GeneratrTrialOutcomeVar(TrialOutcomeStates, nTrials, TrialOutcome)

ConditionIndices = strcmp(TrialOutcome,TrialOutcomeStates)==1;
CellOutput(1:nTrials,1) = 0;
CellOutput(ConditionIndices,1) = 1;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Protocol = AssignProtocol(ProtocolStartIndices, ProtocolEndIndices, ProtocolCounter, nTrials)
Protocol = zeros(nTrials,1);
Protocol(ProtocolStartIndices:ProtocolEndIndices) = ProtocolCounter;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function StatesOutput = IntegratingStatesMeta(States, StatesMeta)

if strcmp(States,'start') == 1 && strcmp(StatesMeta,'Control') == 1
    StatesOutput = 'ProtocolStart';
elseif strcmp(States,'end') == 1 && strcmp(StatesMeta,'Control') == 1
    StatesOutput = 'End';
else
    StatesOutput = States;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [merged_struct] = MergeStructs(struct_a, struct_b)

if isempty(struct_a)
    merged_struct = struct_b;
    return
end
if isempty(struct_b)
    merged_struct = struct_a;
    return
end

merged_struct=struct_a;

size_a = length(merged_struct);
for j = 1:length(struct_b)
    f = fieldnames(struct_b);
    for i = 1:length(f)
        merged_struct.(f{i}) = struct_b(j).(f{i});
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [IndStateDur, IndStateDurStateID] = ExtractingIndStateDur(TrialStartIndices, TrialEndIndices, StateTimes, States, StateNames)

IndStateDurTemp = cell2mat(StateTimes((TrialStartIndices-1)+find(contains(States(TrialStartIndices:TrialEndIndices,1),StateNames))));
IndStateDurStateID = States(TrialStartIndices:TrialEndIndices,1);
IndStateDur = zeros(length(StateNames),1);
IndStateDur(ismember(IndStateDurStateID,StateNames)) = IndStateDurTemp;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [IndOutcomeStateDur] = ExtractingIndOutcomeDurations(TrialOutcomeStates, TrialOutcome, OutcomeStateTimes, nTrials)

IndOutcomeStateDur(1:nTrials,1) = {NaN};
IndOutcomeStateDur(ismember(TrialOutcome, TrialOutcomeStates),1) = ...
    num2cell(OutcomeStateTimes(ismember(TrialOutcome, TrialOutcomeStates)));

end