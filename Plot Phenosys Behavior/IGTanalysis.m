function IGTanalysis(BehTrials,States,StateDurations,ProtocolStartIndices)

%% Asking which side was gamble arm
GambleArm = input('Which side was gamble arm? (left/right)','s');
if strcmp(GambleArm,'left') == 1
    SafeArm = 'right';
else
    SafeArm = 'left';
end

%% Adding useful info to Output Structure
BehTrials.GambleArm = GambleArm;
BehTrials.SafeArm = SafeArm;

%% Calculating Total and Cummulative Reward received
if strcmp(GambleArm,'left') == 1
    BehTrials.RewPerTrialLeft = 4;
    BehTrials.RewPerTrialRight = 1;
else
    BehTrials.RewPerTrialLeft = 1;
    BehTrials.RewPerTrialRight = 4;
end
RewardLeft = BehTrials.left_rewarded*BehTrials.RewPerTrialLeft;
BehTrials.CumRewardLeft = cumsum(RewardLeft);
RewardRight = BehTrials.right_rewarded*BehTrials.RewPerTrialRight;
BehTrials.CumRewardRight = cumsum(RewardRight);
BehTrials.TotalDropsReceivedLeft = sum(BehTrials.left_rewarded)*BehTrials.RewPerTrialLeft;
BehTrials.TotalDropsReceivedRight = sum(BehTrials.right_rewarded)*BehTrials.RewPerTrialRight;

%% Calculating Response Time
StartTimes = cellfun(@(x1,x2) x2(strcmp(x1,'Start') == 1), States, StateDurations, 'uniformoutput', false);
BehTrials.StartTimes = cell2mat(StartTimes);

ActionTimesLeft = cellfun(@(x1,x2) x2(strcmp(x1,'left_rewarded') == 1 | strcmp(x1,'left_NOrewarded') == 1), ...
    States, StateDurations, 'uniformoutput', false);
CellsToNaN = cellfun(@(x1) find(strcmp(x1,'no response in time') == 1 | strcmp(x1,'End') == 1 | ...
    strcmp(x1,'right_rewarded') == 1 | strcmp(x1,'right_NO_rewarded') == 1), States, 'uniformoutput', false);
empties = cellfun('isempty',CellsToNaN);
CellsToNaN(empties) = {0};
CellsToNaNMat = cell2mat(CellsToNaN);
ActionTimesLeft(logical(CellsToNaNMat)) = {NaN};
BehTrials.ActionTimesLeft = cell2mat(ActionTimesLeft);

ActionTimesRight = cellfun(@(x1,x2) x2(strcmp(x1,'right_rewarded') == 1 | strcmp(x1,'right_NO_rewarded') == 1), ...
    States, StateDurations, 'uniformoutput', false);
CellsToNaN = cellfun(@(x1) find(strcmp(x1,'no response in time') == 1 | strcmp(x1,'End') == 1 | ...
    strcmp(x1,'left_rewarded') == 1 | strcmp(x1,'left_NOrewarded') == 1), States, 'uniformoutput', false);
empties = cellfun('isempty',CellsToNaN);
CellsToNaN(empties) = {0};
CellsToNaNMat = cell2mat(CellsToNaN);
ActionTimesRight(logical(CellsToNaNMat)) = {NaN};
BehTrials.ActionTimesRight = cell2mat(ActionTimesRight);

%% Adding Previous Outcome Condition
BehTrials.PreviousLeftRewarded=[0;BehTrials.left_rewarded(1:end-1)];
BehTrials.PreviousLeftNotRewarded=[0;BehTrials.left_NOrewarded(1:end-1)];
BehTrials.PreviousRightRewarded=[0;BehTrials.right_rewarded(1:end-1)];
BehTrials.PreviousRightNotRewarded=[0;BehTrials.right_NOrewarded(1:end-1)];

%% Calculate Updating and SideBias
BehTrials.Stats.WinStayToRight = UpdatingBehaviour(BehTrials.PreviousRightRewarded, BehTrials.RightChoice);
BehTrials.Stats.LooseShiftFromLeft2Right = UpdatingBehaviour(BehTrials.PreviousRightNotRewarded, BehTrials.LeftChoice);
BehTrials.Stats.WinStayToLeft = UpdatingBehaviour(BehTrials.PreviousLeftRewarded, BehTrials.LeftChoice);
BehTrials.Stats.LooseShiftFromRight2Left = UpdatingBehaviour(BehTrials.PreviousLeftNotRewarded, BehTrials.RightChoice);
[BehTrials.Stats.LeftBias] = SideBias(BehTrials.LeftChoice, BehTrials.RightChoice);
[BehTrials.Stats.RatioLeftChoice, BehTrials.Stats.RatioRightChoice, BehTrials.Stats.LeftBias] =  ...
    SideBias(BehTrials.LeftChoice, BehTrials.RightChoice);
BehTrials.WinStayToRight = double(BehTrials.RightChoice == 1 & BehTrials.PreviousRightRewarded == 1);
BehTrials.LooseShiftFromRight2Left = double(BehTrials.LeftChoice == 1 & BehTrials.PreviousRightNotRewarded == 1);
BehTrials.WinStayToLeft = double(BehTrials.LeftChoice == 1 & BehTrials.PreviousLeftRewarded == 1);
BehTrials.LooseShiftFromLeft2Right = double(BehTrials.RightChoice == 1 & BehTrials.PreviousLeftNotRewarded == 1);

%% Calculate Updating and SideBias for Protocols seperately
BehTrials.Stats.WinStayToRightProts = arrayfun(@(x) UpdatingBehaviour ...
    (BehTrials.PreviousRightRewarded, BehTrials.RightChoice, BehTrials.Protocol, x), ...
    1:BehTrials.nProtocols, 'uniformoutput', false);
BehTrials.Stats.LooseShiftFromLeft2RightProts = arrayfun(@(x) UpdatingBehaviour ...
    (BehTrials.PreviousRightNotRewarded, BehTrials.LeftChoice, BehTrials.Protocol, x), ...
    1:BehTrials.nProtocols, 'uniformoutput', false);
BehTrials.Stats.WinStayToLeftProts = arrayfun(@(x) UpdatingBehaviour ...
    (BehTrials.PreviousLeftRewarded, BehTrials.LeftChoice, BehTrials.Protocol, x), ...
    1:BehTrials.nProtocols, 'uniformoutput', false);
BehTrials.Stats.LooseShiftFromRight2Left = arrayfun(@(x) UpdatingBehaviour ...
    (BehTrials.PreviousLeftNotRewarded, BehTrials.RightChoice, BehTrials.Protocol, x), ...
    1:BehTrials.nProtocols, 'uniformoutput', false);

%% Calculating Left and Right Value
[BehTrials.LeftValue, BehTrials.RightValue] = Value ...
    (BehTrials.left_rewarded, BehTrials.left_NOrewarded, BehTrials.right_rewarded, BehTrials.right_NOrewarded, BehTrials.NoResponse, BehTrials.RewPerTrialLeft, BehTrials.RewPerTrialRight, BehTrials.nTrials);

%% Variables where NoResponse put to NaN
BehTrials.right_rewarded_NoR2NaN = BehTrials.right_rewarded;
BehTrials.right_rewarded_NoR2NaN(BehTrials.NoResponse == 1) = NaN;
BehTrials.right_NOrewarded_NoR2NaN = BehTrials.right_NOrewarded;
BehTrials.right_NOrewarded_NoR2NaN(BehTrials.NoResponse == 1) = NaN;
BehTrials.left_rewarded_NoR2NaN = BehTrials.left_rewarded;
BehTrials.left_rewarded_NoR2NaN(BehTrials.NoResponse == 1) = NaN;
BehTrials.left_NOrewarded_NoR2NaN = BehTrials.left_NOrewarded;
BehTrials.left_NOrewarded_NoR2NaN(BehTrials.NoResponse == 1) = NaN;

BehTrials.WinStayToRight_NoR2NaN = BehTrials.WinStayToRight;
BehTrials.WinStayToRight_NoR2NaN(BehTrials.NoResponse == 1) = NaN;
BehTrials.LooseShiftFromLeft2Right_NoR2NaN = BehTrials.LooseShiftFromLeft2Right;
BehTrials.LooseShiftFromLeft2Right_NoR2NaN(BehTrials.NoResponse == 1) = NaN;
BehTrials.WinStayToLeft_NoR2NaN = BehTrials.WinStayToLeft;
BehTrials.WinStayToLeft_NoR2NaN(BehTrials.NoResponse == 1) = NaN;
BehTrials.LooseShiftFromRight2Left_NoR2NaN = BehTrials.LooseShiftFromRight2Left;
BehTrials.LooseShiftFromRight2Left_NoR2NaN(BehTrials.NoResponse == 1) = NaN;

BehTrials.LeftChoice_NoR2NaN = BehTrials.LeftChoice;
BehTrials.LeftChoice_NoR2NaN(BehTrials.NoResponse == 1) = NaN;
BehTrials.RightChoice_NoR2NaN = BehTrials.RightChoice;
BehTrials.RightChoice_NoR2NaN(BehTrials.NoResponse == 1) = NaN;

%% Smoothing Data
Filtered_right_rewarded=Gaussian1D(BehTrials.right_rewarded_NoR2NaN,7);
Filtered_right_NOrewarded=Gaussian1D(BehTrials.right_NOrewarded_NoR2NaN,7);
Filtered_left_rewarded=Gaussian1D(BehTrials.left_rewarded_NoR2NaN,7);
Filtered_left_NOrewarded=Gaussian1D(BehTrials.left_NOrewarded_NoR2NaN,7);
Filtered_NoResponse=Gaussian1D(BehTrials.NoResponse,7);
Filtered_WinStayToRight=Gaussian1D(BehTrials.WinStayToRight_NoR2NaN,7);
Filtered_LooseShiftFromLeft2Right=Gaussian1D(BehTrials.LooseShiftFromLeft2Right_NoR2NaN,7);
Filtered_WinStayToLeft=Gaussian1D(BehTrials.WinStayToLeft_NoR2NaN,7);
Filtered_LooseShiftFromRight2Left=Gaussian1D(BehTrials.LooseShiftFromRight2Left_NoR2NaN,7);
Filtered_LeftChoice=Gaussian1D(BehTrials.LeftChoice_NoR2NaN,7);
Filtered_RightChoice=Gaussian1D(BehTrials.RightChoice_NoR2NaN,7);

%% Interpolating NaNs using shape-preserving piecewise cubic spline interpolation
Filtered_right_rewarded = fillmissing(Filtered_right_rewarded,'pchip');
Filtered_right_NOrewarded = fillmissing(Filtered_right_NOrewarded,'pchip');
Filtered_left_rewarded = fillmissing(Filtered_left_rewarded,'pchip');
Filtered_left_NOrewarded = fillmissing(Filtered_left_NOrewarded,'pchip');
Filtered_WinStayToRight = fillmissing(Filtered_WinStayToRight,'pchip');
Filtered_LooseShiftFromLeft2Right = fillmissing(Filtered_LooseShiftFromLeft2Right,'pchip');
Filtered_WinStayToLeft = fillmissing(Filtered_WinStayToLeft,'pchip');
Filtered_LooseShiftFromRight2Left = fillmissing(Filtered_LooseShiftFromRight2Left,'pchip');
Filtered_LeftChoice = fillmissing(Filtered_LeftChoice,'pchip');
Filtered_RightChoice = fillmissing(Filtered_RightChoice,'pchip');
BehTrials.ActionTimesLeft_InterPol = fillmissing(BehTrials.ActionTimesLeft,'pchip');
BehTrials.ActionTimesRight_InterPol = fillmissing(BehTrials.ActionTimesRight,'pchip');

%% Plotting Data - Choice Behaviour
figure
subplot(4,1,1)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.left_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.left_rewarded == 1),ones(nTrialsForCondition,1),100,'.g');
hold on
plot(BehTrials.Trials,Filtered_left_rewarded,'g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.left_NOrewarded == 1));
scatter(BehTrials.Trials(BehTrials.left_NOrewarded == 1),zeros(nTrialsForCondition,1),100,'.r');
plot(BehTrials.Trials,Filtered_left_NOrewarded,'r');
plot([ProtocolStartIndices(2:end)'; ProtocolStartIndices(2:end)'], ...
    [(zeros(length(ProtocolStartIndices(2:end)),1)-0.1)'; (ones(length(ProtocolStartIndices(2:end)),1)+0.1)'], '--k');
ylim([-0.1 1.1])
title(['Left Rewarded (green), Left Not Rewarded (red), GambleArm = ',BehTrials.GambleArm]);

subplot(4,1,2)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.right_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.right_rewarded == 1),ones(nTrialsForCondition,1),100,'.g');
hold on
plot(BehTrials.Trials,Filtered_right_rewarded,'g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.right_NOrewarded == 1));
scatter(BehTrials.Trials(BehTrials.right_NOrewarded == 1),zeros(nTrialsForCondition,1),100,'.r');
plot(BehTrials.Trials,Filtered_right_NOrewarded,'r');
plot([ProtocolStartIndices(2:end)'; ProtocolStartIndices(2:end)'], ...
    [(zeros(length(ProtocolStartIndices(2:end)),1)-0.1)'; (ones(length(ProtocolStartIndices(2:end)),1)+0.1)'], '--k');
ylim([-0.1 1.1])
title(['Right Rewarded (green), Right Not Rewarded (red), GambleArm = ',BehTrials.GambleArm]);

subplot(4,1,3)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.left_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.left_rewarded == 1),ones(nTrialsForCondition,1),100,'.g');
hold on
plot(BehTrials.Trials,Filtered_left_rewarded,'g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.right_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.right_rewarded == 1),zeros(nTrialsForCondition,1),100,'.b');
plot(BehTrials.Trials,Filtered_right_rewarded,'b');
plot([ProtocolStartIndices(2:end)'; ProtocolStartIndices(2:end)'], ...
    [(zeros(length(ProtocolStartIndices(2:end)),1)-0.1)'; (ones(length(ProtocolStartIndices(2:end)),1)+0.1)'], '--k');
ylim([-0.1 1.1])
title(['Left Rewarded (green), Right Rewarded (blue), GambleArm = ',BehTrials.GambleArm]);

subplot(4,1,4)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.LeftChoice == 1));
scatter(BehTrials.Trials(BehTrials.LeftChoice == 1),ones(nTrialsForCondition,1),100,'.g');
hold on
plot(BehTrials.Trials,Filtered_LeftChoice,'g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.RightChoice == 1));
scatter(BehTrials.Trials(BehTrials.RightChoice == 1),zeros(nTrialsForCondition,1),100,'.b');
plot(BehTrials.Trials,Filtered_RightChoice,'b');
plot([ProtocolStartIndices(2:end)'; ProtocolStartIndices(2:end)'], ...
    [(zeros(length(ProtocolStartIndices(2:end)),1)-0.1)'; (ones(length(ProtocolStartIndices(2:end)),1)+0.1)'], '--k');
ylim([-0.1 1.1])
title(['LeftChoice (green), RightChoice (blue), GambleArm = ',BehTrials.GambleArm]);
xlabel('Trials');

%% Plotting Data - Updating Behaviour
figure
subplot(3,1,1)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.WinStayToLeft == 1));
scatter(BehTrials.Trials(BehTrials.WinStayToLeft == 1),ones(nTrialsForCondition,1),100,'.g');
hold on
plot(BehTrials.Trials,Filtered_WinStayToLeft,'g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.WinStayToRight == 1));
scatter(BehTrials.Trials(BehTrials.WinStayToRight == 1),zeros(nTrialsForCondition,1),100,'.b');
plot(BehTrials.Trials,Filtered_WinStayToRight,'b');
plot([ProtocolStartIndices(2:end)'; ProtocolStartIndices(2:end)'], ...
    [(zeros(length(ProtocolStartIndices(2:end)),1)-0.1)'; (ones(length(ProtocolStartIndices(2:end)),1)+0.1)'], '--k');
ylim([-0.1 1.1])
title(['WinStayToLeft (green), WinStayToRight (blue), GambleArm = ',BehTrials.GambleArm]);

subplot(3,1,2)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.LooseShiftFromLeft2Right == 1));
scatter(BehTrials.Trials(BehTrials.LooseShiftFromLeft2Right == 1),ones(nTrialsForCondition,1),100,'.g');
hold on
plot(BehTrials.Trials,Filtered_LooseShiftFromLeft2Right,'g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.LooseShiftFromRight2Left == 1));
scatter(BehTrials.Trials(BehTrials.LooseShiftFromRight2Left == 1),zeros(nTrialsForCondition,1),100,'.b');
plot(BehTrials.Trials,Filtered_LooseShiftFromRight2Left,'b');
plot([ProtocolStartIndices(2:end)'; ProtocolStartIndices(2:end)'], ...
    [(zeros(length(ProtocolStartIndices(2:end)),1)-0.1)'; (ones(length(ProtocolStartIndices(2:end)),1)+0.1)'], '--k');
ylim([-0.1 1.1])
title(['LooseShiftFromLeft2Right (green), LooseShiftFromRight2Left (blue), GambleArm = ',BehTrials.GambleArm]);

subplot(3,1,3)
plot(BehTrials.Trials,BehTrials.LeftValue,'g');
hold on
plot(BehTrials.Trials,BehTrials.RightValue*(-1),'b');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.left_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.left_rewarded == 1),ones(nTrialsForCondition,1)*37,100,'.g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.left_NOrewarded == 1));
scatter(BehTrials.Trials(BehTrials.left_NOrewarded == 1),ones(nTrialsForCondition,1)*33,100,'.r');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.right_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.right_rewarded == 1),ones(nTrialsForCondition,1)*(-37),100,'.b');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.right_NOrewarded == 1));
scatter(BehTrials.Trials(BehTrials.right_NOrewarded == 1),ones(nTrialsForCondition,1)*(-33),100,'.r');
plot([ProtocolStartIndices(2:end)'; ProtocolStartIndices(2:end)'], ...
    [(ones(length(ProtocolStartIndices(2:end)),1)*(-40))'; (ones(length(ProtocolStartIndices(2:end)),1)*40)'], '--k');
line([0 BehTrials.nTrials],[0 0],'Color','k','LineStyle','--');
title(['LeftValue (green), RightValue (blue), GambleArm = ',BehTrials.GambleArm]);
xlabel('Trials');
ylim([-40 40]);

%% Plotting Data - Motivation
figure
subplot(3,1,1)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.NoResponse == 1));
scatter(BehTrials.Trials(BehTrials.NoResponse == 1),ones(nTrialsForCondition,1),100,'.k');
hold on
plot(BehTrials.Trials,Filtered_NoResponse,'k');
plot([ProtocolStartIndices(2:end)'; ProtocolStartIndices(2:end)'], ...
    [(zeros(length(ProtocolStartIndices(2:end)),1)-0.1)'; (ones(length(ProtocolStartIndices(2:end)),1)+0.1)'], '--k');
ylim([-0.1 1.1])
title(['No Response (black), GambleArm = ',BehTrials.GambleArm]);

subplot(3,1,2)
plot(BehTrials.Trials,BehTrials.CumRewardLeft,'g');
hold on
plot(BehTrials.Trials,BehTrials.CumRewardRight,'b');
plot([ProtocolStartIndices(2:end)'; ProtocolStartIndices(2:end)'], ...
    [(zeros(length(ProtocolStartIndices(2:end)),1)-0.1)'; (ones(length(ProtocolStartIndices(2:end)),1)+0.1)'], '--k');
title(['Reward Received Left (green), Reward Received Right (blue), GambleArm = ',BehTrials.GambleArm]);
ylabel('Drops');
ylim([0 300]);

subplot(3,1,3)
plot(BehTrials.Trials,BehTrials.ActionTimesLeft_InterPol,'g');
hold on
plot(BehTrials.Trials,BehTrials.ActionTimesRight_InterPol,'b');
plot(BehTrials.Trials,BehTrials.StartTimes,'k');
plot([ProtocolStartIndices(2:end)'; ProtocolStartIndices(2:end)'], ...
    [(zeros(length(ProtocolStartIndices(2:end)),1)-0.1)'; (ones(length(ProtocolStartIndices(2:end)),1)+0.1)'], '--k');
title(['Response Time Left (green), Response Time Right (blue), Start Time (black), GambleArm = ',BehTrials.GambleArm]);
ylim([0 10])
ylabel('Time (sec)');
xlabel('Trials');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cell Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function UpdatingOutput = UpdatingBehaviour(UpdatingInput1, UpdatingInput12, Protocol, ProtIndex)

if nargin == 2
    UP1 = UpdatingInput1(~isnan(UpdatingInput1));
    UP2 = UpdatingInput12(~isnan(UpdatingInput1));
    UpdatingOutput = sum(UP2 & UP1)/sum(UP1);
else
    UP1 = UpdatingInput1(~isnan(UpdatingInput1) & Protocol == ProtIndex);
    UP2 = UpdatingInput12(~isnan(UpdatingInput1) & Protocol == ProtIndex);
    UpdatingOutput = sum(UP2 & UP1)/sum(UP1);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [RatioLeftChoice, RatioRightChoice, SideBiasOutput] = SideBias(SideBiasInput1, SideBiasInput2)

SB1 = SideBiasInput1(~isnan(SideBiasInput1));
SB2 = SideBiasInput2(~isnan(SideBiasInput2));
RatioLeftChoice = sum(SB1)/(sum(SB1)+sum(SB2));
RatioRightChoice = sum(SB2)/(sum(SB1)+sum(SB2));
SideBiasOutput = (sum(SB1)-sum(SB2)) / (sum(SB1)+sum(SB2));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Filtered_Data = Gaussian1D(Vector,WinSize)

w=gausswin(WinSize);
w=w./sum(w);
Filtered_Data = conv (Vector, w, 'same');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [LeftValue, RightValue] = Value ...
    (left_rewarded, left_NOrewarded, right_rewarded, right_NOrewarded, NoResponse, RewPerTrialLeft, RewPerTrialRight, nTrials)

LeakRate = 0.2;
AdaptRate = 0.2;

LeftValue(1:nTrials,1) = 0;
RightValue(1:nTrials,1) = 0;

for i = 1:length(left_rewarded)
    if i == 1
        if left_rewarded(i) == 1
            LeftValue(i) =  RewPerTrialLeft*AdaptRate;
            RightValue(i) = 0;
        elseif left_NOrewarded(i) == 1
            LeftValue(i) =  -1*AdaptRate;
            RightValue(i) = 0;
        elseif right_rewarded(i) == 1
            LeftValue(i) =  0;
            RightValue(i) = RewPerTrialRight*AdaptRate;
        elseif right_NOrewarded(i) == 1
            LeftValue(i) =  0;
            RightValue(i) = -1*AdaptRate;
        elseif NoResponse(i) == 1
            LeftValue(i) =  0;
            RightValue(i) = 0;
        else
            LeftValue(i) =  0;
            RightValue(i) = 0;
        end
    else
        if left_rewarded(i) == 1
            LeftValue(i) = LeftValue(i-1) + RewPerTrialLeft*AdaptRate;
            if RightValue(i-1) > 0
                RightValue(i) = RightValue(i-1) - LeakRate;
            else
                RightValue(i) = RightValue(i-1) + LeakRate;
            end
        elseif left_NOrewarded(i) == 1
            LeftValue(i) = LeftValue(i-1) - 1*AdaptRate;
            if RightValue(i-1) > 0
                RightValue(i) = RightValue(i-1) - LeakRate;
            else
                RightValue(i) = RightValue(i-1) + LeakRate;
            end
        elseif right_rewarded(i) == 1
            RightValue(i) = RightValue(i-1) + RewPerTrialRight*AdaptRate;
            if LeftValue(i-1) > 0
                LeftValue(i) = LeftValue(i-1) - LeakRate;
            else
                LeftValue(i) = LeftValue(i-1) + LeakRate;
            end
        elseif right_NOrewarded(i) == 1
            RightValue(i) = RightValue(i-1) - 1*AdaptRate;
            if LeftValue(i-1) > 0
                LeftValue(i) = LeftValue(i-1) - LeakRate;
            else
                LeftValue(i) = LeftValue(i-1) + LeakRate;
            end
        elseif NoResponse(i) == 1
            if LeftValue(i-1) > 0
                LeftValue(i) = LeftValue(i-1) - LeakRate;
            else
                LeftValue(i) = LeftValue(i-1) + LeakRate;
            end
            if RightValue(i-1) > 0
                RightValue(i) = RightValue(i-1) - LeakRate;
            else
                RightValue(i) = RightValue(i-1) + LeakRate;
            end
        else
            LeftValue(i) = LeftValue(i-1);
            RightValue(i) = RightValue(i-1);
        end
    end
end

end
