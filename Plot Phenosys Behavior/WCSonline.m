function WCSonline(BehTrials, WindowSize, Overlap)

%% Windowed average of Behavioural Measures
WinStep = WindowSize-(WindowSize*(Overlap/100));

if WinStep == 0
    WinStep = 1;
end

MM_Correct = movmean(BehTrials.CorrectChoice, [WindowSize 0],'omitnan');
MMstepped_Correct = MM_Correct(1:WinStep:end);

MM_StimColorID1Correct = movmean(BehTrials.StimColorID1Correct, [WindowSize 0],'omitnan');
MMstepped_StimColorID1Correct = MM_StimColorID1Correct(1:WinStep:end);

MM_StimColorID2Correct = movmean(BehTrials.StimColorID2Correct, [WindowSize 0],'omitnan');
MMstepped_StimColorID2Correct = MM_StimColorID2Correct(1:WinStep:end);

MM_NotResponded = movmean(BehTrials.NoResponse, [WindowSize 0],'omitnan');
MMstepped_NotResponded = MM_NotResponded(1:WinStep:end);

MM_LeftChoice = movmean(BehTrials.LeftChoice, [WindowSize 0],'omitnan');
MMstepped_LeftChoice = MM_LeftChoice(1:WinStep:end);

MM_RightChoice = movmean(BehTrials.RightChoice, [WindowSize 0],'omitnan');
MMstepped_RightChoice = MM_RightChoice(1:WinStep:end);

MM_LeftRewarded = movmean(BehTrials.LeftRewarded, [WindowSize 0],'omitnan');
MMstepped_LeftRewarded = MM_LeftRewarded(1:WinStep:end);

MM_RightRewarded = movmean(BehTrials.RightRewarded, [WindowSize 0],'omitnan');
MMstepped_RightRewarded = MM_RightRewarded(1:WinStep:end);

MM_RewardedTrial = movmean(BehTrials.RewardedTrial, [WindowSize 0],'omitnan');
MMstepped_RewardedTrial = MM_RewardedTrial(1:WinStep:end);

MM_WinStay = movmean(BehTrials.WinStay, [WindowSize 0],'omitnan');
MMstepped_WinStay = MM_WinStay(1:WinStep:end);

MM_LooseShift = movmean(BehTrials.LooseShift, [WindowSize 0],'omitnan');
MMstepped_LooseShift = MM_LooseShift(1:WinStep:end);

%% Plotting
FigureHandles = get(gcf);

SubPlot1HandlesTemp1 = FigureHandles.Children(9);
SubPlot1HandlesTemp2 = get(SubPlot1HandlesTemp1);
SubPlot1Handles = SubPlot1HandlesTemp2.Children;
set(SubPlot1Handles, 'XData',1:BehTrials.nTrials);
set(SubPlot1Handles(4), 'YData',(BehTrials.currNINSINSstate+13)/12);
set(SubPlot1Handles(3), 'YData',MMstepped_Correct);
set(SubPlot1Handles(2), 'YData',MMstepped_StimColorID1Correct);
set(SubPlot1Handles(1), 'YData',MMstepped_StimColorID2Correct);
set(SubPlot1HandlesTemp1, 'XLim', [0 BehTrials.nTrials]);
set(SubPlot1HandlesTemp1, 'XTick', 0:200:BehTrials.nTrials);

SubPlot8HandlesTemp1 = FigureHandles.Children(8);
SubPlot8HandlesTemp2 = get(SubPlot8HandlesTemp1);
SubPlot8Handles = SubPlot8HandlesTemp2.Children;
set(SubPlot8Handles, 'XData',1:length(BehTrials.TrialRateHist));
set(SubPlot8Handles(2), 'YData',(BehTrials.currNINSINSstate+13)/12);
set(SubPlot8Handles(1), 'YData',BehTrials.TrialRateHist);
set(SubPlot8HandlesTemp1, 'XTick', 0:10:length(BehTrials.TrialRateHist));
set(SubPlot8HandlesTemp2.XLabel, 'String', 'Minute');
set(SubPlot8HandlesTemp2.YLabel, 'String', 'Trials/min');

SubPlot3HandlesTemp1 = FigureHandles.Children(7);
SubPlot3HandlesTemp2 = get(SubPlot3HandlesTemp1);
SubPlot3Handles = SubPlot3HandlesTemp2.Children;
set(SubPlot3Handles, 'XData',1:BehTrials.nTrials);
set(SubPlot3Handles(4), 'YData',(BehTrials.currNINSINSstate+13)/12);
set(SubPlot3Handles(3), 'YData',MMstepped_RewardedTrial);
set(SubPlot3Handles(2), 'YData',MMstepped_LeftChoice);
set(SubPlot3Handles(1), 'YData',MMstepped_RightChoice);
set(SubPlot3HandlesTemp1, 'XLim', [0 BehTrials.nTrials]);
set(SubPlot3HandlesTemp1, 'XTick', 0:200:BehTrials.nTrials);

SubPlot4HandlesTemp1 = FigureHandles.Children(6);
SubPlot4HandlesTemp2 = get(SubPlot4HandlesTemp1);
SubPlot4Handles = SubPlot4HandlesTemp2.Children;
set(SubPlot4Handles, 'XData',1:BehTrials.nTrials);
set(SubPlot4Handles(3), 'YData',(BehTrials.currNINSINSstate+13)/12);
set(SubPlot4Handles(2), 'YData',MMstepped_LeftRewarded);
set(SubPlot4Handles(1), 'YData',MMstepped_RightRewarded);
set(SubPlot4HandlesTemp1, 'XLim', [0 BehTrials.nTrials]);
set(SubPlot4HandlesTemp1, 'XTick', 0:200:BehTrials.nTrials);

SubPlot5HandlesTemp1 = FigureHandles.Children(5);
SubPlot5HandlesTemp2 = get(SubPlot5HandlesTemp1);
SubPlot5Handles = SubPlot5HandlesTemp2.Children;
set(SubPlot5Handles, 'XData',1:BehTrials.nTrials);
set(SubPlot5Handles(2), 'YData',BehTrials.CumLeftRewarded);
set(SubPlot5Handles(1), 'YData',BehTrials.CumRightRewarded);
set(SubPlot5HandlesTemp1, 'XLim', [0 BehTrials.nTrials]);
set(SubPlot5HandlesTemp1, 'XTick', 0:200:BehTrials.nTrials);
set(SubPlot5HandlesTemp1, 'YLim', [0 max([BehTrials.CumLeftRewarded;BehTrials.CumRightRewarded]+10)]);
set(SubPlot5HandlesTemp2.YLabel, 'String', 'Drops');
set(SubPlot5HandlesTemp2.XLabel, 'String', 'Trial');

SubPlot6HandlesTemp1 = FigureHandles.Children(4);
SubPlot6HandlesTemp2 = get(SubPlot6HandlesTemp1);
SubPlot6Handles = SubPlot6HandlesTemp2.Children;
set(SubPlot6Handles, 'XData',1:BehTrials.nTrials);
set(SubPlot6Handles(3), 'YData',(BehTrials.currNINSINSstate+13)/12);
set(SubPlot6Handles(2), 'YData',MMstepped_WinStay);
set(SubPlot6Handles(1), 'YData',MMstepped_LooseShift);
set(SubPlot6HandlesTemp1, 'XLim', [0 BehTrials.nTrials]);
set(SubPlot6HandlesTemp1, 'XTick', 0:200:BehTrials.nTrials);

SubPlot7HandlesTemp1 = FigureHandles.Children(3);
SubPlot7HandlesTemp2 = get(SubPlot7HandlesTemp1);
SubPlot7Handles = SubPlot7HandlesTemp2.Children;
set(SubPlot7Handles, 'XData',1:BehTrials.nTrials);
set(SubPlot7Handles(2), 'YData',(BehTrials.currNINSINSstate+13)/12);
set(SubPlot7Handles(1), 'YData',MMstepped_NotResponded);
set(SubPlot7HandlesTemp1, 'XTick', 0:200:BehTrials.nTrials);
set(SubPlot7HandlesTemp2.XLabel, 'String', 'Trial');

end