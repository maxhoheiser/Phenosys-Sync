function [BehTrials] = TrialConditionsIGT(BehTrials)

%% Specifying wheter ResponseTimeWindowAbortion NoResponse, WheelNotStoppingAbbortion and Opposite ChoiceSides included or put to NaN
BehTrials.left_rewarded_Wheel2NaN = BehTrials.left_rewarded;
BehTrials.left_rewarded_Wheel2NaN(BehTrials.End == 1 | BehTrials.RespTimeWin == 1 | BehTrials.WheelNotStopping == 1) = NaN;
BehTrials.left_rewarded_Wheel2NaN_NoR2NaN = BehTrials.left_rewarded_Wheel2NaN;
BehTrials.left_rewarded_Wheel2NaN_NoR2NaN(BehTrials.NoResponse == 1) = NaN;
BehTrials.left_NOreward_Wheel2NaN = BehTrials.left_NOreward;
BehTrials.left_NOreward_Wheel2NaN(BehTrials.End == 1 | BehTrials.RespTimeWin == 1 | BehTrials.WheelNotStopping == 1) = NaN;
BehTrials.left_NOreward_Wheel2NaN_NoR2NaN = BehTrials.left_NOreward_Wheel2NaN;
BehTrials.left_NOreward_Wheel2NaN_NoR2NaN(BehTrials.NoResponse == 1) = NaN;
BehTrials.left_rewarded_Wheel2NaN_NoR2NaN_RightChoice2NaN = BehTrials.left_rewarded_Wheel2NaN_NoR2NaN;
BehTrials.left_rewarded_Wheel2NaN_NoR2NaN_RightChoice2NaN(BehTrials.RightChoice == 1) = NaN;
BehTrials.left_NOreward_Wheel2NaN_NoR2NaN_RightChoice2NaN = BehTrials.left_NOreward_Wheel2NaN_NoR2NaN;
BehTrials.left_NOreward_Wheel2NaN_NoR2NaN_RightChoice2NaN(BehTrials.RightChoice == 1) = NaN;

BehTrials.right_rewarded_Wheel2NaN = BehTrials.right_rewarded;
BehTrials.right_rewarded_Wheel2NaN(BehTrials.End == 1 | BehTrials.RespTimeWin == 1 | BehTrials.WheelNotStopping == 1) = NaN;
BehTrials.right_rewarded_Wheel2NaN_NoR2NaN = BehTrials.right_rewarded_Wheel2NaN;
BehTrials.right_rewarded_Wheel2NaN_NoR2NaN(BehTrials.NoResponse == 1) = NaN;
BehTrials.right_NOreward_Wheel2NaN = BehTrials.right_NOreward;
BehTrials.right_NOreward_Wheel2NaN(BehTrials.End == 1 | BehTrials.RespTimeWin == 1 | BehTrials.WheelNotStopping == 1) = NaN;
BehTrials.right_NOreward_Wheel2NaN_NoR2NaN = BehTrials.right_NOreward_Wheel2NaN;
BehTrials.right_NOreward_Wheel2NaN_NoR2NaN(BehTrials.NoResponse == 1) = NaN;
BehTrials.right_rewarded_Wheel2NaN_NoR2NaN_LeftChoice2NaN = BehTrials.right_rewarded_Wheel2NaN_NoR2NaN;
BehTrials.right_rewarded_Wheel2NaN_NoR2NaN_LeftChoice2NaN(BehTrials.LeftChoice == 1) = NaN;
BehTrials.right_NOreward_Wheel2NaN_NoR2NaN_LeftChoice2NaN = BehTrials.right_NOreward_Wheel2NaN_NoR2NaN;
BehTrials.right_NOreward_Wheel2NaN_NoR2NaN_LeftChoice2NaN(BehTrials.LeftChoice == 1) = NaN;

BehTrials.NoResponse_Wheel2NaN = BehTrials.NoResponse;
BehTrials.NoResponse_Wheel2NaN(BehTrials.End == 1 | BehTrials.RespTimeWin == 1 | BehTrials.WheelNotStopping == 1) = NaN;

BehTrials.LeftChoice_Wheel2NaN = BehTrials.LeftChoice;
BehTrials.LeftChoice_Wheel2NaN(BehTrials.End == 1 | BehTrials.RespTimeWin == 1 | BehTrials.WheelNotStopping == 1) = NaN;
BehTrials.LeftChoice_Wheel2NaN_NoR2NaN = BehTrials.LeftChoice_Wheel2NaN;
BehTrials.LeftChoice_Wheel2NaN_NoR2NaN(BehTrials.NoResponse == 1) = NaN;

BehTrials.RightChoice_Wheel2NaN = BehTrials.RightChoice;
BehTrials.RightChoice_Wheel2NaN(BehTrials.End == 1 | BehTrials.RespTimeWin == 1 | BehTrials.WheelNotStopping == 1) = NaN;
BehTrials.RightChoice_Wheel2NaN_NoR2NaN = BehTrials.RightChoice_Wheel2NaN;
BehTrials.RightChoice_Wheel2NaN_NoR2NaN(BehTrials.NoResponse == 1) = NaN;

%% Adding Previous Outcome Condition (WheelNotStopping, NoResponse and Opposite Choice Sode put to NaN)
BehTrials.PreviousLeftRewarded=[NaN;BehTrials.left_rewarded_Wheel2NaN_NoR2NaN(1:end-1)];
BehTrials.PreviousLeftNotRewarded=[NaN;BehTrials.left_NOreward_Wheel2NaN_NoR2NaN(1:end-1)];
BehTrials.PreviousRightRewarded=[NaN;BehTrials.right_rewarded_Wheel2NaN_NoR2NaN(1:end-1)];
BehTrials.PreviousRightNotRewarded=[NaN;BehTrials.right_NOreward_Wheel2NaN_NoR2NaN(1:end-1)];

%% Extracting Trial Conditions for Updating and SideBias Behaviour (WheelNotStopping and NoResponse put to NaN)
RRnanShift = BehTrials.right_rewarded_Wheel2NaN_NoR2NaN;
RRnanShift(isnan(RRnanShift)) = [];
RCnanShift = BehTrials.RightChoice_Wheel2NaN_NoR2NaN;
RCnanShift(isnan(RCnanShift)) = [];
PRRnanShift = [NaN;RRnanShift(1:end-1)];
WSRshift(1:length(PRRnanShift),1) = NaN;
WSRshift(PRRnanShift == 1 & RCnanShift == 1) = 1;
WSRshift(PRRnanShift == 1 & RCnanShift == 0) = 0;
BehTrials.WinStayToRight(1:BehTrials.nTrials,1) = NaN;
BehTrials.WinStayToRight(~isnan(BehTrials.right_rewarded_Wheel2NaN_NoR2NaN)) = WSRshift;

Input = BehTrials.WinStayToRight;
BehTrials.WinStayToRightMoveMean(1:BehTrials.nTrials,1) = NaN;
BehTrials.WinStayToRightMoveMean(~isnan(Input),1) = movmean(Input(~isnan(Input)),[9 0]);
if isnan(BehTrials.WinStayToRightMoveMean(1))
    BehTrials.WinStayToRightMoveMean(1) = 0;
    % BehTrials.WinStayToRightMoveMean(1) = BehTrials.WinStayToRightMoveMean(find(~isnan(BehTrials.WinStayToRightMoveMean),1,'first'));
end
if isnan(BehTrials.WinStayToRightMoveMean(end))
    BehTrials.WinStayToRightMoveMean(end) = 0;
    % BehTrials.WinStayToRightMoveMean(end) = BehTrials.WinStayToRightMoveMean(find(~isnan(BehTrials.WinStayToRightMoveMean),1,'last'));
end

LRnanShift = BehTrials.left_rewarded_Wheel2NaN_NoR2NaN;
LRnanShift(isnan(LRnanShift)) = [];
LCnanShift = BehTrials.LeftChoice_Wheel2NaN_NoR2NaN;
LCnanShift(isnan(LCnanShift)) = [];
PLRnanShift = [NaN;LRnanShift(1:end-1)];
WSLshift(1:length(PLRnanShift),1) = NaN;
WSLshift(PLRnanShift == 1 & LCnanShift == 1) = 1;
WSLshift(PLRnanShift == 1 & LCnanShift == 0) = 0;
BehTrials.WinStayToLeft(1:BehTrials.nTrials,1) = NaN;
BehTrials.WinStayToLeft(~isnan(BehTrials.left_rewarded_Wheel2NaN_NoR2NaN)) = WSLshift;

Input = BehTrials.WinStayToLeft;
BehTrials.WinStayToLeftMoveMean(1:BehTrials.nTrials,1) = NaN;
BehTrials.WinStayToLeftMoveMean(~isnan(Input),1) = movmean(Input(~isnan(Input)),[9 0]);
if isnan(BehTrials.WinStayToLeftMoveMean(1))
    BehTrials.WinStayToLeftMoveMean(1) = 0;
    % BehTrials.WinStayToLeftMoveMean(1) = BehTrials.WinStayToLeftMoveMean(find(~isnan(BehTrials.WinStayToLeftMoveMean),1,'first'));
end
if isnan(BehTrials.WinStayToLeftMoveMean(end))
    BehTrials.WinStayToLeftMoveMean(end) = 0;
    % BehTrials.WinStayToLeftMoveMean(end) = BehTrials.WinStayToLeftMoveMean(find(~isnan(BehTrials.WinStayToLeftMoveMean),1,'last'));
end

RnRnanShift = BehTrials.right_NOreward_Wheel2NaN_NoR2NaN;
RnRnanShift(isnan(RnRnanShift)) = [];
PRnRnanShift = [NaN;RnRnanShift(1:end-1)];
LSR2Lshift(1:length(PRnRnanShift),1) = NaN;
LSR2Lshift(PRnRnanShift == 1 & LCnanShift == 1) = 1;
LSR2Lshift(PRnRnanShift == 1 & RCnanShift == 1) = 0;
BehTrials.LooseShiftFromRight2Left(1:BehTrials.nTrials,1) = NaN;
BehTrials.LooseShiftFromRight2Left(~isnan(BehTrials.RightChoice_Wheel2NaN_NoR2NaN)) = LSR2Lshift;

Input = BehTrials.LooseShiftFromRight2Left;
BehTrials.LooseShiftFromRight2LeftMoveMean(1:BehTrials.nTrials,1) = NaN;
BehTrials.LooseShiftFromRight2LeftMoveMean(~isnan(Input),1) = movmean(Input(~isnan(Input)),[9 0]);
if isnan(BehTrials.LooseShiftFromRight2LeftMoveMean(1))
    BehTrials.LooseShiftFromRight2LeftMoveMean(1) = 0;
    % BehTrials.LooseShiftFromRight2LeftMoveMean(1) = BehTrials.LooseShiftFromRight2LeftMoveMean(find(~isnan(BehTrials.LooseShiftFromRight2LeftMoveMean),1,'first'));
end
if isnan(BehTrials.LooseShiftFromRight2LeftMoveMean(end))
    BehTrials.LooseShiftFromRight2LeftMoveMean(end) = 0;
    % BehTrials.LooseShiftFromRight2LeftMoveMean(end) = BehTrials.LooseShiftFromRight2LeftMoveMean(find(~isnan(BehTrials.LooseShiftFromRight2LeftMoveMean),1,'last'));
end

LnRnanShift = BehTrials.left_NOreward_Wheel2NaN_NoR2NaN;
LnRnanShift(isnan(LnRnanShift)) = [];
PLnRnanShift = [NaN;LnRnanShift(1:end-1)];
LSL2Rshift(1:length(PLnRnanShift),1) = NaN;
LSL2Rshift(PLnRnanShift == 1 & RCnanShift == 1) = 1;
LSL2Rshift(PLnRnanShift == 1 & LCnanShift == 1) = 0;
BehTrials.LooseShiftFromLeft2Right(1:BehTrials.nTrials,1) = NaN;
BehTrials.LooseShiftFromLeft2Right(~isnan(BehTrials.left_NOreward_Wheel2NaN_NoR2NaN)) = LSL2Rshift;

Input = BehTrials.LooseShiftFromLeft2Right;
BehTrials.LooseShiftFromLeft2RightMoveMean(1:BehTrials.nTrials,1) = NaN;
BehTrials.LooseShiftFromLeft2RightMoveMean(~isnan(Input),1) = movmean(Input(~isnan(Input)),[9 0]);
if isnan(BehTrials.LooseShiftFromLeft2RightMoveMean(1))
    BehTrials.LooseShiftFromLeft2RightMoveMean(1) = 0;
    % BehTrials.LooseShiftFromLeft2RightMoveMean(1) = BehTrials.LooseShiftFromLeft2RightMoveMean(find(~isnan(BehTrials.LooseShiftFromLeft2RightMoveMean),1,'first'));
end
if isnan(BehTrials.LooseShiftFromLeft2RightMoveMean(end))
    BehTrials.LooseShiftFromLeft2RightMoveMean(end) = 0;
    % BehTrials.LooseShiftFromLeft2RightMoveMean(end) = BehTrials.LooseShiftFromLeft2RightMoveMean(find(~isnan(BehTrials.LooseShiftFromLeft2RightMoveMean),1,'last'));
end

%% Extracting GambleArm RewardProbability
BehTrials.GambleProbAllTrials(1:find(~isnan(BehTrials.GambleProbAllTrials),1,'first')) = ...
    BehTrials.GambleProbAllTrials(find(~isnan(BehTrials.GambleProbAllTrials),1,'first'));
BehTrials.GambleProbAllTrials(find(~isnan(BehTrials.GambleProbAllTrials),1,'last'):end) = ...
    BehTrials.GambleProbAllTrials(find(~isnan(BehTrials.GambleProbAllTrials),1,'last'));
BehTrials.GambleProbAllTrials = fillmissing(BehTrials.GambleProbAllTrials,'nearest');

%% Finding Transitions of RewardProbability
BehTrials.GambleProbChanges = find(diff(BehTrials.GambleProbAllTrials) ~= 0) + 1;
BehTrials.GambleProbChanges1 =[1;BehTrials.GambleProbChanges];
BehTrials.GambleProbChanges2 =[BehTrials.GambleProbChanges;BehTrials.nTrials];

%% Calculate Stats for Updating
BehTrials.Stats.WinStayToRight = round((nansum(WSRshift)/nansum(PRRnanShift))*100);
BehTrials.Stats.WinStayToLeft = round((nansum(WSLshift)/nansum(PLRnanShift))*100);
BehTrials.Stats.LooseShiftFromRight2Left = round((nansum(LSR2Lshift)/nansum(PRnRnanShift))*100);
BehTrials.Stats.LooseShiftFromLeft2Right = round((nansum(LSL2Rshift)/nansum(PLnRnanShift))*100);

%% Calculate Stats for Updating, individual Trials
BehTrials.Stats.WinStayToRightProts = arrayfun(@(x1,x2) ...
    round(nanmean(BehTrials.WinStayToRight(x1:x2))*100), ...
    BehTrials.GambleProbChanges1, BehTrials.GambleProbChanges2, 'uniformoutput', false);

BehTrials.Stats.WinStayToLeftProts = arrayfun(@(x1,x2) ...
    round(nanmean(BehTrials.WinStayToLeft(x1:x2))*100), ...
    BehTrials.GambleProbChanges1, BehTrials.GambleProbChanges2, 'uniformoutput', false);

BehTrials.Stats.LooseShiftFromRight2LeftProts = arrayfun(@(x1,x2) ...
    round(nanmean(BehTrials.LooseShiftFromRight2Left(x1:x2))*100), ...
    BehTrials.GambleProbChanges1, BehTrials.GambleProbChanges2, 'uniformoutput', false);

BehTrials.Stats.LooseShiftFromLeft2RightProts = arrayfun(@(x1,x2) ...
    round(nanmean(BehTrials.LooseShiftFromLeft2Right(x1:x2))*100), ...
    BehTrials.GambleProbChanges1, BehTrials.GambleProbChanges2, 'uniformoutput', false);

%% Calculate Stats for SideBias
BehTrials.Stats.LeftChoicePerc = round(nanmean(BehTrials.LeftChoice_Wheel2NaN_NoR2NaN)*100);
BehTrials.Stats.RightChoicePerc = round(nanmean(BehTrials.RightChoice_Wheel2NaN_NoR2NaN)*100);

%% Calculate Stats for SideBias, individual Trials
BehTrials.Stats.LeftChoicePercProts = arrayfun(@(x1,x2) round(nanmean(BehTrials.LeftChoice_Wheel2NaN_NoR2NaN(x1:x2))*100), ...
    BehTrials.GambleProbChanges1, BehTrials.GambleProbChanges2, 'uniformoutput', false);
BehTrials.Stats.RightChoicePercProts = arrayfun(@(x1,x2) round(nanmean(BehTrials.RightChoice_Wheel2NaN_NoR2NaN(x1:x2))*100), ...
    BehTrials.GambleProbChanges1, BehTrials.GambleProbChanges2, 'uniformoutput', false);

%% Calculating Preceived Reward Probability for Left and Right
Input = BehTrials.left_rewarded_Wheel2NaN_NoR2NaN_RightChoice2NaN;
BehTrials.left_rewarded_PerceivedRewProb(1:BehTrials.nTrials,1) = NaN;
BehTrials.left_rewarded_PerceivedRewProb(~isnan(Input),1) = movmean(Input(~isnan(Input)),[4 0]);

Input = BehTrials.right_rewarded_Wheel2NaN_NoR2NaN_LeftChoice2NaN;
BehTrials.right_rewarded_PerceivedRewProb(1:BehTrials.nTrials,1) = NaN;
BehTrials.right_rewarded_PerceivedRewProb(~isnan(Input),1) = movmean(Input(~isnan(Input)),[4 0]);

BehTrials.left_rewarded_PerceivedRewProb_InterPol = BehTrials.left_rewarded_PerceivedRewProb;
BehTrials.left_rewarded_PerceivedRewProb_InterPol(1) = 0;
BehTrials.left_rewarded_PerceivedRewProb_InterPol(end) = 0;
BehTrials.left_rewarded_PerceivedRewProb_InterPol = fillmissing(BehTrials.left_rewarded_PerceivedRewProb_InterPol,'previous');

BehTrials.right_rewarded_PerceivedRewProb_InterPol = BehTrials.right_rewarded_PerceivedRewProb;
BehTrials.right_rewarded_PerceivedRewProb_InterPol(1) = 0;
BehTrials.right_rewarded_PerceivedRewProb_InterPol(end) = 0;
BehTrials.right_rewarded_PerceivedRewProb_InterPol = fillmissing(BehTrials.right_rewarded_PerceivedRewProb_InterPol,'previous');

%% Checking GambleArm Side
DeleteCells = cell2mat(cellfun(@(x) isempty(x), BehTrials.GambleArmAllTrialsCell, 'uniformoutput', false));
GambleArmAllTrialsCellTemp = BehTrials.GambleArmAllTrialsCell;
GambleArmAllTrialsCellTemp(DeleteCells) = [];
BehTrials.GambleArm = unique(GambleArmAllTrialsCellTemp);

if length(BehTrials.GambleArm) > 1
    disp('ErrorMessage: Gamble Arm was swapped during Session')
    return
else
    if strcmp(BehTrials.GambleArm,'LEFT') == 1
        BehTrials.GambleArm = cell2mat(BehTrials.GambleArm);
        BehTrials.SafeArm = 'RIGHT';
    else
        BehTrials.GambleArm = cell2mat(BehTrials.GambleArm);
        BehTrials.SafeArm = 'LEFT';
    end
end

%% Checking Number of Drops given
if strcmp(BehTrials.GambleArm,'LEFT') == 1
    BehTrials.DropsForGambleArm = unique(BehTrials.DropsReceivedAllTrials(BehTrials.left_rewarded == 1));
    % If it doesnt exist I define it
    if isempty(BehTrials.DropsForGambleArm)
        BehTrials.DropsForGambleArm = 4;
    end
    BehTrials.DropsForSafeArm = unique(BehTrials.DropsReceivedAllTrials(BehTrials.right_rewarded == 1));
    if length(BehTrials.DropsForGambleArm) > 1
        disp('ErrorMessage: Different Amount of Drops given at Gamble Arm')
        return
    end
    if length(BehTrials.DropsForSafeArm) > 1
        disp('ErrorMessage: Different Amount of Drops given at Safe Arm')
        return
    end
else
    BehTrials.DropsForGambleArm = unique(BehTrials.DropsReceivedAllTrials(BehTrials.right_rewarded == 1));
    % If it doesnt exist I define it
    if isempty(BehTrials.DropsForGambleArm)
        BehTrials.DropsForGambleArm = 4;
    end
    BehTrials.DropsForSafeArm = unique(BehTrials.DropsReceivedAllTrials(BehTrials.left_rewarded == 1));
    if length(BehTrials.DropsForGambleArm) > 1
        disp('ErrorMessage: Different Amount of Drops given at Gamble Arm')
        return
    end
    if length(BehTrials.DropsForSafeArm) > 1
        disp('ErrorMessage: Different Amount of Drops given at Safe Arm')
        return
    end
end
if strcmp(BehTrials.GambleArm,'LEFT') == 1
    BehTrials.RewPerTrialLeft = BehTrials.DropsForGambleArm;
    BehTrials.RewPerTrialRight = BehTrials.DropsForSafeArm;
else
    BehTrials.RewPerTrialLeft = BehTrials.DropsForSafeArm;
    BehTrials.RewPerTrialRight = BehTrials.DropsForGambleArm;
end

%% Calculating Left and Right Value (WheelNotStopping put to NaN, but NoResponse included)
[BehTrials.LeftValue, BehTrials.RightValue] = Value ...
    (BehTrials.left_rewarded_Wheel2NaN, BehTrials.left_NOreward_Wheel2NaN, BehTrials.right_rewarded_Wheel2NaN, ...
    BehTrials.right_NOreward_Wheel2NaN, BehTrials.NoResponse_Wheel2NaN, BehTrials.RewPerTrialLeft, ...
    BehTrials.RewPerTrialRight, BehTrials.nTrials);

%% Calculating Choice Given Evidence (based on previously calculated Value)
BehTrials.ChoiceGivenEvidenceLeft(1:BehTrials.nTrials,1) = NaN;
BehTrials.ChoiceGivenEvidenceLeft(BehTrials.LeftChoice == 1 & (BehTrials.LeftValue > BehTrials.RightValue)) = 1;
BehTrials.ChoiceGivenEvidenceLeft(BehTrials.RightChoice == 1 & (BehTrials.LeftValue > BehTrials.RightValue)) = 0;
BehTrials.ChoiceGivenEvidenceRight(1:BehTrials.nTrials,1) = NaN;
BehTrials.ChoiceGivenEvidenceRight(BehTrials.RightChoice == 1 & (BehTrials.RightValue > BehTrials.LeftValue)) = 1;
BehTrials.ChoiceGivenEvidenceRight(BehTrials.LeftChoice == 1 & (BehTrials.RightValue > BehTrials.LeftValue)) = 0;

%% Calculating Total and Cummulative Reward received
RewardLeft = BehTrials.left_rewarded*BehTrials.RewPerTrialLeft;
BehTrials.CumRewardLeft = cumsum(RewardLeft);
RewardRight = BehTrials.right_rewarded*BehTrials.RewPerTrialRight;
BehTrials.CumRewardRight = cumsum(RewardRight);
BehTrials.TotalDropsReceivedLeft = sum(BehTrials.left_rewarded)*BehTrials.RewPerTrialLeft;
BehTrials.TotalDropsReceivedRight = sum(BehTrials.right_rewarded)*BehTrials.RewPerTrialRight;
BehTrials.TotalDropsReceivedLeftProts = arrayfun(@(x1,x2) sum(BehTrials.left_rewarded(x1:x2))*BehTrials.RewPerTrialLeft, ...
    BehTrials.GambleProbChanges1,BehTrials.GambleProbChanges2,'uniformoutput',false);
BehTrials.TotalDropsReceivedRightProts = arrayfun(@(x1,x2) sum(BehTrials.right_rewarded(x1:x2))*BehTrials.RewPerTrialRight, ...
    BehTrials.GambleProbChanges1,BehTrials.GambleProbChanges2,'uniformoutput',false);

%% Conditioning State Durations
BehTrials.LeftRewardedRespTime(1:BehTrials.nTrials,1) = NaN;
BehTrials.LeftNoRewardRespTime(1:BehTrials.nTrials,1) = NaN;
BehTrials.RightRewardedRespTime(1:BehTrials.nTrials,1) = NaN;
BehTrials.RightNoRewardRespTime(1:BehTrials.nTrials,1) = NaN;
BehTrials.NoResponseRespTime(1:BehTrials.nTrials,1) = NaN;

BehTrials.LeftRewardedRespTime(BehTrials.left_rewarded == 1) = ...
    BehTrials.OutputStateDurations.OutcomeStateTimes(BehTrials.left_rewarded == 1);
BehTrials.LeftNoRewardRespTime(BehTrials.left_NOreward == 1) = ...
    BehTrials.OutputStateDurations.OutcomeStateTimes(BehTrials.left_NOreward == 1);
BehTrials.RightRewardedRespTime(BehTrials.right_rewarded == 1) = ...
    BehTrials.OutputStateDurations.OutcomeStateTimes(BehTrials.right_rewarded == 1);
BehTrials.RightNoRewardRespTime(BehTrials.right_NOreward == 1) = ...
    BehTrials.OutputStateDurations.OutcomeStateTimes(BehTrials.right_NOreward == 1);
BehTrials.NoResponseRespTime(BehTrials.NoResponse == 1) = ...
    BehTrials.OutputStateDurations.OutcomeStateTimes(BehTrials.NoResponse == 1);

%% State Durations for individual protocols
BehTrials.LeftRewardedRespTimeProts = arrayfun(@(x1,x2) round(nanmean(BehTrials.LeftRewardedRespTime(x1:x2))*10)/10, ...
    BehTrials.GambleProbChanges1,BehTrials.GambleProbChanges2,'uniformoutput',false);
BehTrials.LeftNoRewardRespTimeProts = arrayfun(@(x1,x2) round(nanmean(BehTrials.LeftNoRewardRespTime(x1:x2))*10)/10, ...
    BehTrials.GambleProbChanges1,BehTrials.GambleProbChanges2,'uniformoutput',false);
BehTrials.RightRewardedRespTimeProts = arrayfun(@(x1,x2) round(nanmean(BehTrials.RightRewardedRespTime(x1:x2))*10)/10, ...
    BehTrials.GambleProbChanges1,BehTrials.GambleProbChanges2,'uniformoutput',false);
BehTrials.RightNoRewardRespTimeProts = arrayfun(@(x1,x2) round(nanmean(BehTrials.RightNoRewardRespTime(x1:x2))*10)/10, ...
    BehTrials.GambleProbChanges1,BehTrials.GambleProbChanges2,'uniformoutput',false);
BehTrials.LeftRespTimeProts = arrayfun(@(x1,x2) ...
    round(nanmean([BehTrials.LeftRewardedRespTime(x1:x2);BehTrials.LeftNoRewardRespTime(x1:x2)])*10)/10, ...
    BehTrials.GambleProbChanges1,BehTrials.GambleProbChanges2,'uniformoutput',false);
BehTrials.RightRespTimeProts = arrayfun(@(x1,x2) ...
    round(nanmean([BehTrials.RightRewardedRespTime(x1:x2);BehTrials.RightNoRewardRespTime(x1:x2)])*10)/10, ...
    BehTrials.GambleProbChanges1,BehTrials.GambleProbChanges2,'uniformoutput',false);

%% Processing State Durations (putting zeros to NaNs, these are empty spots)
BehTrials.OutputStateDurations.IndStateTimesStruct2.TIstarts(BehTrials.OutputStateDurations.IndStateTimesStruct2.TIstarts == 0) = NaN;
BehTrials.OutputStateDurations.IndStateTimesStruct2.IndCue(BehTrials.OutputStateDurations.IndStateTimesStruct2.IndCue == 0) = NaN;
BehTrials.OutputStateDurations.IndStateTimesStruct2.SOUND_start(BehTrials.OutputStateDurations.IndStateTimesStruct2.SOUND_start == 0) = NaN;
BehTrials.OutputStateDurations.IndStateTimesStruct2.NoResponse(BehTrials.OutputStateDurations.IndStateTimesStruct2.NoResponse == 0) = NaN;
BehTrials.OutputStateDurations.IndStateTimesStruct2.ITIstarts(BehTrials.OutputStateDurations.IndStateTimesStruct2.ITIstarts == 0) = NaN;
BehTrials.OutputStateDurations.IndStateTimesStruct2.ITIends(BehTrials.OutputStateDurations.IndStateTimesStruct2.ITIends == 0) = NaN;
BehTrials.OutputStateDurations.IndStateTimesStruct2.WheelNotStopping(BehTrials.OutputStateDurations.IndStateTimesStruct2.WheelNotStopping == 0) = NaN;
BehTrials.OutputStateDurations.IndStateTimesStruct2.End(BehTrials.OutputStateDurations.IndStateTimesStruct2.End == 0) = NaN;
BehTrials.OutputStateDurations.IndStateTimesStruct2.left_rewarded(BehTrials.OutputStateDurations.IndStateTimesStruct2.left_rewarded == 0) = NaN;
BehTrials.OutputStateDurations.IndStateTimesStruct2.left_NOreward(BehTrials.OutputStateDurations.IndStateTimesStruct2.left_NOreward == 0) = NaN;
BehTrials.OutputStateDurations.IndStateTimesStruct2.right_rewarded(BehTrials.OutputStateDurations.IndStateTimesStruct2.right_rewarded == 0) = NaN;
BehTrials.OutputStateDurations.IndStateTimesStruct2.right_NOreward(BehTrials.OutputStateDurations.IndStateTimesStruct2.right_NOreward == 0) = NaN;
BehTrials.OutputStateDurations.IndStateTimesStruct2.RespTimeWin(BehTrials.OutputStateDurations.IndStateTimesStruct2.RespTimeWin == 0) = NaN;

BehTrials.OutputStateDurations.IndOutcomeStateDurations.left_rewarded(BehTrials.OutputStateDurations.IndOutcomeStateDurations.left_rewarded == 0) = NaN;
BehTrials.OutputStateDurations.IndOutcomeStateDurations.left_NOreward(BehTrials.OutputStateDurations.IndOutcomeStateDurations.left_NOreward == 0) = NaN;
BehTrials.OutputStateDurations.IndOutcomeStateDurations.right_NOreward(BehTrials.OutputStateDurations.IndOutcomeStateDurations.right_NOreward == 0) = NaN;
BehTrials.OutputStateDurations.IndOutcomeStateDurations.right_rewarded(BehTrials.OutputStateDurations.IndOutcomeStateDurations.right_rewarded == 0) = NaN;
BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse(BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse == 0) = NaN;

%% Conditioning Output Left and Right Choice Response State Durations
BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice = ...
    nansum([BehTrials.OutputStateDurations.IndOutcomeStateDurations.left_rewarded, ...
    BehTrials.OutputStateDurations.IndOutcomeStateDurations.left_NOreward],2);
BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice = ...
    nansum([BehTrials.OutputStateDurations.IndOutcomeStateDurations.right_rewarded, ...
    BehTrials.OutputStateDurations.IndOutcomeStateDurations.right_NOreward],2);

BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice(BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice == 0) = NaN;
BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice(BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice == 0) = NaN;

if isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice(end)) == 1
    BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice(end) = 0;
end
if isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice(end)) == 1
    BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice(end) = 0;
end
if isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse(end)) == 1
    BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse(end) = 0;
end

%% Interpolating NaNs using shape-preserving piecewise cubic spline interpolation
if isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice(1))
    BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice(1) = ...
        BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice(find( ...
        ~isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice),1,'first'));
end
if isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice(end))
    BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice(end) = ...
        BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice(find( ...
        ~isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice),1,'last'));
end
BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice_InterPol = ...
    fillmissing(BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice,'linear');

if isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice(1))
    BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice(1) = ...
        BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice(find( ...
        ~isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice),1,'first'));
end
if isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice(end))
    BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice(end) = ...
        BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice(find( ...
        ~isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice),1,'last'));
end
BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice_InterPol = ...
    fillmissing(BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice,'linear');

if isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse(1))
    BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse(1) = ...
        BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse(find( ...
        ~isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse),1,'first'));
end
if isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse(end))
    BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse(end) = ...
        BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse(find( ...
        ~isnan(BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse),1,'last'));
end
BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse_InterPol = ...
    fillmissing(BehTrials.OutputStateDurations.IndOutcomeStateDurations.NoResponse,'linear');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cell Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function UpdatingOutput = UpdatingBehaviour(UpdatingInput1, UpdatingInput12, Protocol, ProtIndex)

if nargin == 2
    UP1 = UpdatingInput1(~isnan(UpdatingInput1));
    UP2 = UpdatingInput12(~isnan(UpdatingInput1));
    UpdatingOutput = sum(UP2 == 1 & UP1 == 1)/sum(UP1 == 1);
else
    UP1 = UpdatingInput1(~isnan(UpdatingInput1) & Protocol == ProtIndex);
    UP2 = UpdatingInput12(~isnan(UpdatingInput1) & Protocol == ProtIndex);
    UpdatingOutput = sum(UP2 == 1 & UP1 == 1)/sum(UP1 == 1);
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
function [LeftValue, RightValue] = Value ...
    (left_rewarded, left_NOrewarded, right_rewarded, right_NOrewarded, NoResponse, RewPerTrialLeft, RewPerTrialRight, nTrials)

LeakRate = 0.1;
AdaptRate = 0.75;
Memory = 0.9;

LeftValue(1:nTrials,1) = NaN;
RightValue(1:nTrials,1) = NaN;

for i = 1:nTrials
    if i == 1
        if left_rewarded(i) == 1
            LeftValue(i) =  RewPerTrialLeft*AdaptRate;
            RightValue(i) = 0;
        elseif left_NOrewarded(i) == 1
            LeftValue(i) =  0;
            RightValue(i) = 0;
            % LeftValue(i) =  -1*AdaptRate;
        elseif right_rewarded(i) == 1
            LeftValue(i) =  0;
            RightValue(i) = RewPerTrialRight*AdaptRate;
        elseif right_NOrewarded(i) == 1
            LeftValue(i) =  0;
            RightValue(i) = 0;
            % RightValue(i) = -1*AdaptRate;
        elseif NoResponse(i) == 1
            LeftValue(i) =  0;
            RightValue(i) = 0;
        else
            LeftValue(i) =  0;
            RightValue(i) = 0;
        end
    else
        if left_rewarded(i) == 1
            LeftValue(i) = (LeftValue(i-1)*Memory) + (RewPerTrialLeft*AdaptRate);
            if RightValue(i-1) > LeakRate
                RightValue(i) = RightValue(i-1) - LeakRate;
            elseif RightValue(i-1) < LeakRate*(-1)
                RightValue(i) = RightValue(i-1) + LeakRate;
            else
                RightValue(i) = 0;
            end
        elseif right_rewarded(i) == 1
            RightValue(i) = (RightValue(i-1)*Memory) + (RewPerTrialRight*AdaptRate);
            if LeftValue(i-1) > LeakRate
                LeftValue(i) = LeftValue(i-1) - LeakRate;
            elseif LeftValue(i-1) < LeakRate*(-1)
                LeftValue(i) = LeftValue(i-1) + LeakRate;
            else
                LeftValue(i) = 0;
            end
        elseif left_NOrewarded(i) == 1
            LeftValue(i) = LeftValue(i-1);
            if RightValue(i-1) > LeakRate
                RightValue(i) = RightValue(i-1) - LeakRate;
            elseif RightValue(i-1) < LeakRate*(-1)
                RightValue(i) = RightValue(i-1) + LeakRate;
            else
                RightValue(i) = 0;
            end
        elseif right_NOrewarded(i) == 1
            RightValue(i) = RightValue(i-1);
            if LeftValue(i-1) > LeakRate
                LeftValue(i) = LeftValue(i-1) - LeakRate;
            elseif LeftValue(i-1) < LeakRate*(-1)
                LeftValue(i) = LeftValue(i-1) + LeakRate;
            else
                 LeftValue(i) = 0;
            end
        elseif NoResponse(i) == 1
            if LeftValue(i-1) > LeakRate
                LeftValue(i) = LeftValue(i-1) - LeakRate;
            elseif LeftValue(i-1) < LeakRate*(-1)
                LeftValue(i) = LeftValue(i-1) + LeakRate;
            else
                 LeftValue(i) = 0;
            end
            if RightValue(i-1) > LeakRate
                RightValue(i) = RightValue(i-1) - LeakRate;
            elseif RightValue(i-1) < LeakRate*(-1)
                RightValue(i) = RightValue(i-1) + LeakRate;
            else
                RightValue(i) = 0;
            end
        else
            if LeftValue(i-1) > LeakRate
                LeftValue(i) = LeftValue(i-1) - LeakRate;
            elseif LeftValue(i-1) < LeakRate*(-1)
                LeftValue(i) = LeftValue(i-1) + LeakRate;
            else
                 LeftValue(i) = 0;
            end
            if RightValue(i-1) > LeakRate
                RightValue(i) = RightValue(i-1) - LeakRate;
            elseif RightValue(i-1) < LeakRate*(-1)
                RightValue(i) = RightValue(i-1) + LeakRate;
            else
                RightValue(i) = 0;
            end
        end
    end
end

end