function [BehTrials] = TrialConditionsWCS(BehTrials)

BehTrials.NoResponse(1:BehTrials.nTrials,1) = NaN;
BehTrials.NoResponse(BehTrials.chosenSIDE == BehTrials.ZeroAngle) = 1;
BehTrials.NoResponse(BehTrials.chosenSIDE == BehTrials.RightAngle) = 0;
BehTrials.NoResponse(BehTrials.chosenSIDE == BehTrials.LeftAngle) = 0;

BehTrials.CorrectChoice(1:BehTrials.nTrials,1) = NaN;
BehTrials.CorrectChoice(BehTrials.chosenSIDE == BehTrials.corrAngle) = 1;
BehTrials.CorrectChoice(BehTrials.chosenSIDE ~= BehTrials.corrAngle) = 0;

BehTrials.LeftRewarded(1:BehTrials.nTrials,1) = NaN;
BehTrials.LeftRewarded(BehTrials.LeftChoice == 1 & BehTrials.CorrectChoice == 1) = 1;
BehTrials.LeftRewarded(BehTrials.LeftChoice == 1 & BehTrials.CorrectChoice == 0) = 0;

BehTrials.CumLeftRewarded = cumsum(BehTrials.LeftRewarded,'omitnan');

BehTrials.RightRewarded(1:BehTrials.nTrials,1) = NaN;
BehTrials.RightRewarded(BehTrials.RightChoice == 1 & BehTrials.CorrectChoice == 1) = 1;
BehTrials.RightRewarded(BehTrials.RightChoice == 1 & BehTrials.CorrectChoice == 0) = 0;

BehTrials.CumRightRewarded = cumsum(BehTrials.RightRewarded,'omitnan');

BehTrials.RewardedTrial(1:BehTrials.nTrials,1) = NaN;
BehTrials.RewardedTrial(BehTrials.LeftRewarded == 1 | BehTrials.RightRewarded == 1) = 1;
BehTrials.RewardedTrial(BehTrials.LeftRewarded == 0 | BehTrials.RightRewarded == 0) = 0;

BehTrials.StimColorID1Correct(1:BehTrials.nTrials,1) = NaN;
BehTrials.StimColorID1Correct(BehTrials.CcolorID == 1 & BehTrials.CorrectChoice == 1) = 1;
BehTrials.StimColorID1Correct(BehTrials.CcolorID == 1 & BehTrials.CorrectChoice == 0) = 0;

BehTrials.StimColorID2Correct(1:BehTrials.nTrials,1) = NaN;
BehTrials.StimColorID2Correct(BehTrials.CcolorID == 0 & BehTrials.CorrectChoice == 1) = 1;
BehTrials.StimColorID2Correct(BehTrials.CcolorID == 0 & BehTrials.CorrectChoice == 0) = 0;

BehTrials.WinStayLeft(1:BehTrials.nTrials,1) = NaN;
WinStayTempLeft = [BehTrials.LeftRewarded, [NaN;BehTrials.LeftChoice(1:end-1,1)], [NaN;BehTrials.RightChoice(1:end-1,1)]];
BehTrials.WinStayLeft(WinStayTempLeft(:,1) == 1 & WinStayTempLeft(:,2) == 1) = 1;
BehTrials.WinStayLeft(WinStayTempLeft(:,1) == 1 & WinStayTempLeft(:,3) == 1) = 0;

BehTrials.WinStayRight(1:BehTrials.nTrials,1) = NaN;
WinStayTempRight = [BehTrials.RightRewarded, [NaN;BehTrials.RightChoice(1:end-1,1)], [NaN;BehTrials.LeftChoice(1:end-1,1)]];
BehTrials.WinStayRight(WinStayTempRight(:,1) == 1 & WinStayTempRight(:,2) == 1) = 1;
BehTrials.WinStayRight(WinStayTempRight(:,1) == 1 & WinStayTempRight(:,3) == 1) = 0;

BehTrials.WinStay(1:BehTrials.nTrials,1) = NaN;
BehTrials.WinStay(BehTrials.WinStayLeft == 1 | BehTrials.WinStayRight == 1) = 1;
BehTrials.WinStay(BehTrials.WinStayLeft == 0 | BehTrials.WinStayRight == 0) = 0;

BehTrials.LooseShiftLeft(1:BehTrials.nTrials,1) = NaN;
LooseShiftTempLeft = [BehTrials.LeftRewarded == 0, [NaN;BehTrials.RightChoice(1:end-1,1)], [NaN;BehTrials.LeftChoice(1:end-1,1)]];
BehTrials.LooseShiftLeft(LooseShiftTempLeft(:,1) == 1 & LooseShiftTempLeft(:,2) == 1) = 1;
BehTrials.LooseShiftLeft(LooseShiftTempLeft(:,1) == 1 & LooseShiftTempLeft(:,3) == 1) = 0;

BehTrials.LooseShiftRight(1:BehTrials.nTrials,1) = NaN;
LooseShiftTempRight = [BehTrials.RightRewarded == 0, [NaN;BehTrials.LeftChoice(1:end-1,1)], [NaN;BehTrials.RightChoice(1:end-1,1)]];
BehTrials.LooseShiftRight(LooseShiftTempRight(:,1) == 1 & LooseShiftTempRight(:,2) == 1) = 1;
BehTrials.LooseShiftRight(LooseShiftTempRight(:,1) == 1 & LooseShiftTempRight(:,3) == 1) = 0;

BehTrials.LooseShift(1:BehTrials.nTrials,1) = NaN;
BehTrials.LooseShift(BehTrials.LooseShiftLeft == 1 | BehTrials.LooseShiftRight == 1) = 1;
BehTrials.LooseShift(BehTrials.LooseShiftLeft == 0 | BehTrials.LooseShiftRight == 0) = 0;

end