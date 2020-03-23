function IGTonline(BehTrials)

%% Smoothing Data
FilterInput = BehTrials.left_rewarded_Wheel2NaN_NoR2NaN;
FilterInput(1) = 0;
FilterInput(find(~isnan(FilterInput),1,'last'):end) = FilterInput(find(~isnan(FilterInput),1,'last'));
Filtered_left_rewarded(1:BehTrials.nTrials,1) = NaN;
Filtered_left_rewarded(~isnan(FilterInput),1) = Gaussian1D(FilterInput(~isnan(FilterInput)),10);

FilterInput = BehTrials.left_NOreward_Wheel2NaN_NoR2NaN;
FilterInput(1) = 0;
FilterInput(find(~isnan(FilterInput),1,'last'):end) = FilterInput(find(~isnan(FilterInput),1,'last'));
Filtered_left_NOreward(1:BehTrials.nTrials,1) = NaN;
Filtered_left_NOreward(~isnan(FilterInput),1) = Gaussian1D(FilterInput(~isnan(FilterInput)),10);

FilterInput = BehTrials.right_rewarded_Wheel2NaN_NoR2NaN;
FilterInput(1) = 0;
FilterInput(find(~isnan(FilterInput),1,'last'):end) = FilterInput(find(~isnan(FilterInput),1,'last'));
Filtered_right_rewarded(1:BehTrials.nTrials,1) = NaN;
Filtered_right_rewarded(~isnan(FilterInput),1) = Gaussian1D(FilterInput(~isnan(FilterInput)),10);

FilterInput = BehTrials.right_NOreward_Wheel2NaN_NoR2NaN;
FilterInput(1) = 0;
FilterInput(find(~isnan(FilterInput),1,'last'):end) = FilterInput(find(~isnan(FilterInput),1,'last'));
Filtered_right_NOreward(1:BehTrials.nTrials,1) = NaN;
Filtered_right_NOreward(~isnan(FilterInput),1) = Gaussian1D(FilterInput(~isnan(FilterInput)),10);

FilterInput = BehTrials.NoResponse_Wheel2NaN;
FilterInput(1) = 0;
FilterInput(find(~isnan(FilterInput),1,'last'):end) = FilterInput(find(~isnan(FilterInput),1,'last'));
Filtered_NoResponse(1:BehTrials.nTrials,1) = NaN;
Filtered_NoResponse(~isnan(FilterInput),1) = Gaussian1D(FilterInput(~isnan(FilterInput)),10);

FilterInput = BehTrials.WheelNotStopping;
FilterInput(1) = 0;
FilterInput(find(~isnan(FilterInput),1,'last'):end) = FilterInput(find(~isnan(FilterInput),1,'last'));
Filtered_WheelNotStopping(1:BehTrials.nTrials,1) = NaN;
Filtered_WheelNotStopping(~isnan(FilterInput),1) = Gaussian1D(FilterInput(~isnan(FilterInput)),10);

FilterInput = BehTrials.WinStayToRight;
FilterInput(1) = 0;
FilterInput(find(~isnan(FilterInput),1,'last'):end) = FilterInput(find(~isnan(FilterInput),1,'last'));
Filtered_WinStayToRight(1:BehTrials.nTrials,1) = NaN;
Filtered_WinStayToRight(~isnan(FilterInput),1) = Gaussian1D(FilterInput(~isnan(FilterInput)),10);

FilterInput = BehTrials.LooseShiftFromLeft2Right;
FilterInput(1) = 0;
FilterInput(find(~isnan(FilterInput),1,'last'):end) = FilterInput(find(~isnan(FilterInput),1,'last'));
Filtered_LooseShiftFromLeft2Right(1:BehTrials.nTrials,1) = NaN;
Filtered_LooseShiftFromLeft2Right(~isnan(FilterInput),1) = Gaussian1D(FilterInput(~isnan(FilterInput)),10);

FilterInput = BehTrials.WinStayToLeft;
FilterInput(1) = 0;
FilterInput(find(~isnan(FilterInput),1,'last'):end) = FilterInput(find(~isnan(FilterInput),1,'last'));
Filtered_WinStayToLeft(1:BehTrials.nTrials,1) = NaN;
Filtered_WinStayToLeft(~isnan(FilterInput),1) = Gaussian1D(FilterInput(~isnan(FilterInput)),10);

FilterInput = BehTrials.LooseShiftFromRight2Left;
FilterInput(1) = 0;
FilterInput(find(~isnan(FilterInput),1,'last'):end) = FilterInput(find(~isnan(FilterInput),1,'last'));
Filtered_LooseShiftFromRight2Left(1:BehTrials.nTrials,1) = NaN;
Filtered_LooseShiftFromRight2Left(~isnan(FilterInput),1) = Gaussian1D(FilterInput(~isnan(FilterInput)),10);

FilterInput = BehTrials.LeftChoice_Wheel2NaN_NoR2NaN;
FilterInput(1) = 0;
FilterInput(find(~isnan(FilterInput),1,'last'):end) = FilterInput(find(~isnan(FilterInput),1,'last'));
Filtered_LeftChoice(1:BehTrials.nTrials,1) = NaN;
Filtered_LeftChoice(~isnan(FilterInput),1) = Gaussian1D(FilterInput(~isnan(FilterInput)),10);

FilterInput = BehTrials.RightChoice_Wheel2NaN_NoR2NaN;
FilterInput(1) = 0;
FilterInput(find(~isnan(FilterInput),1,'last'):end) = FilterInput(find(~isnan(FilterInput),1,'last'));
Filtered_RightChoice(1:BehTrials.nTrials,1) = NaN;
Filtered_RightChoice(~isnan(FilterInput),1) = Gaussian1D(FilterInput(~isnan(FilterInput)),10);

%% Interpolating NaNs using shape-preserving piecewise cubic spline interpolation
Filtered_right_rewarded = fillmissing(Filtered_right_rewarded,'pchip');
Filtered_right_NOreward = fillmissing(Filtered_right_NOreward,'pchip');
Filtered_left_rewarded = fillmissing(Filtered_left_rewarded,'pchip');
Filtered_left_NOreward = fillmissing(Filtered_left_NOreward,'pchip');
Filtered_WinStayToRight = fillmissing(Filtered_WinStayToRight,'pchip');
Filtered_LooseShiftFromLeft2Right = fillmissing(Filtered_LooseShiftFromLeft2Right,'pchip');
Filtered_WinStayToLeft = fillmissing(Filtered_WinStayToLeft,'pchip');
Filtered_LooseShiftFromRight2Left = fillmissing(Filtered_LooseShiftFromRight2Left,'pchip');
Filtered_LeftChoice = fillmissing(Filtered_LeftChoice,'pchip');
Filtered_RightChoice = fillmissing(Filtered_RightChoice,'pchip');
Filtered_NoResponse = fillmissing(Filtered_NoResponse,'pchip');
Filtered_WinStayToRightMoveMean = fillmissing(BehTrials.WinStayToRightMoveMean,'linear');
Filtered_WinStayToLeftMoveMean = fillmissing(BehTrials.WinStayToLeftMoveMean,'linear');
Filtered_LooseShiftFromRight2LeftMoveMean = fillmissing(BehTrials.LooseShiftFromRight2LeftMoveMean,'linear');
Filtered_LooseShiftFromLeft2RightMoveMean = fillmissing(BehTrials.LooseShiftFromLeft2RightMoveMean,'linear');

%% Plotting Data - Choice Behaviour
figure('Position', [0 0 600 1000])
subplot(4,1,1)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.left_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.left_rewarded == 1),ones(nTrialsForCondition,1)+0.1,25,'+g');
hold on
plot(BehTrials.Trials,Filtered_left_rewarded,'g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.left_NOreward == 1));
scatter(BehTrials.Trials(BehTrials.left_NOreward == 1),zeros(nTrialsForCondition,1)-0.1,25,'+r');
plot(BehTrials.Trials,Filtered_left_NOreward,'r');
plot([BehTrials.GambleProbChanges'; BehTrials.GambleProbChanges'], ...
    [(zeros(length(BehTrials.GambleProbChanges),1)-0.2)'; (ones(length(BehTrials.GambleProbChanges),1)+0.2)'], '--k');
ylim([-0.2 1.2])
set(gca,'Xticklabel',[]) 
title(['Gamble = ',BehTrials.GambleArm, ', {\color{green}LeftRewarded}, {\color{red}LeftNotRewarded}']);

subplot(4,1,2)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.right_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.right_rewarded == 1),ones(nTrialsForCondition,1)+0.1,25,'+g');
hold on
plot(BehTrials.Trials,Filtered_right_rewarded,'g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.right_NOreward == 1));
scatter(BehTrials.Trials(BehTrials.right_NOreward == 1),zeros(nTrialsForCondition,1)-0.1,25,'+r');
plot(BehTrials.Trials,Filtered_right_NOreward,'r');
plot([BehTrials.GambleProbChanges'; BehTrials.GambleProbChanges'], ...
    [(zeros(length(BehTrials.GambleProbChanges),1)-0.2)'; (ones(length(BehTrials.GambleProbChanges),1)+0.2)'], '--k');
ylim([-0.2 1.2])
set(gca,'Xticklabel',[]) 
title('{\color{green}RightRewarded}, {\color{red}RightNotRewarded}');

subplot(4,1,3)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.left_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.left_rewarded == 1),ones(nTrialsForCondition,1)+0.1,25,'+g');
hold on
plot(BehTrials.Trials,Filtered_left_rewarded,'g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.right_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.right_rewarded == 1),zeros(nTrialsForCondition,1)-0.1,25,'+b');
plot(BehTrials.Trials,Filtered_right_rewarded,'b');
plot([BehTrials.GambleProbChanges'; BehTrials.GambleProbChanges'], ...
    [(zeros(length(BehTrials.GambleProbChanges),1)-0.2)'; (ones(length(BehTrials.GambleProbChanges),1)+0.2)'], '--k');
ylim([-0.2 1.2])
set(gca,'Xticklabel',[]) 
title('{\color{green}LeftRewarded}, {\color{blue}RightRewarded}');

subplot(4,1,4)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.LeftChoice == 1));
scatter(BehTrials.Trials(BehTrials.LeftChoice == 1),ones(nTrialsForCondition,1)+0.1,25,'+g');
hold on
plot(BehTrials.Trials,Filtered_LeftChoice,'g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.RightChoice == 1));
scatter(BehTrials.Trials(BehTrials.RightChoice == 1),zeros(nTrialsForCondition,1)-0.1,25,'+b');
plot(BehTrials.Trials,Filtered_RightChoice,'b');
plot([BehTrials.GambleProbChanges'; BehTrials.GambleProbChanges'], ...
    [(zeros(length(BehTrials.GambleProbChanges),1)-0.2)'; (ones(length(BehTrials.GambleProbChanges),1)+0.2)'], '--k');
ylim([-0.2 1.2])
title('{\color{green}LeftChoice}, {\color{blue}RightChoice}');
xlabel('Trials');
GamProbString = cellstr(num2str(BehTrials.GambleProbAllTrials([1;BehTrials.GambleProbChanges])));
WSRstring = cellfun(@(x) num2str(x), BehTrials.Stats.RightChoicePercProts, 'uniformoutput', false);
StringYposTemp = 0.1:0.1:0.1*size(GamProbString,1);
StringYposTemp1 = StringYposTemp';
StringYposTemp2 = StringYposTemp1 + StringYposTemp1(end);
StringYpos1 = num2cell(StringYposTemp1);
StringYpos2 = num2cell(StringYposTemp2);
cellfun(@(x1,x2,x3) text(BehTrials.nTrials,1-x3,[x1,'%: RC: ',x2,'%'], 'HorizontalAlignment', 'left', 'Color', 'b'),...
    GamProbString, WSRstring, {StringYpos1{1:length(GamProbString)}}', 'uniformoutput', false);
WSLstring = cellfun(@(x) num2str(x), BehTrials.Stats.LeftChoicePercProts, 'uniformoutput', false);
cellfun(@(x1,x2,x3) text(BehTrials.nTrials,1-x3,[x1,'%: LC: ',x2,'%'], 'HorizontalAlignment', 'left', 'Color', 'g'),...
    GamProbString, WSLstring, {StringYpos2{1:length(GamProbString)}}', 'uniformoutput', false);

%% Plotting Data - Updating Behaviour
figure('Position', [620 0 600 1000])
subplot(4,1,1)
plot(BehTrials.GambleProbAllTrials/100,'k','LineWidth',2);
hold on
plot(BehTrials.left_rewarded_PerceivedRewProb_InterPol,'g');
plot(BehTrials.right_rewarded_PerceivedRewProb_InterPol,'b');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.left_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.left_rewarded == 1),ones(nTrialsForCondition,1)+0.1,25,'+g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.right_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.right_rewarded == 1),zeros(nTrialsForCondition,1)-0.1,25,'+b');
plot([BehTrials.GambleProbChanges'; BehTrials.GambleProbChanges'], ...
    [(zeros(length(BehTrials.GambleProbChanges),1)-0.2)'; (ones(length(BehTrials.GambleProbChanges),1)+0.2)'], '--k');
ylim([-0.2 1.2])
title('{\color{green}LeftPerceived}, {\color{blue}RightPerceived}');
xlabel('Trials');
ylabel('RewProb');
set(gca,'Xticklabel',[]) 

subplot(4,1,2)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.WinStayToLeft == 1));
scatter(BehTrials.Trials(BehTrials.WinStayToLeft == 1),ones(nTrialsForCondition,1)+0.1,25,'+g');
hold on
nTrialsForCondition = length(BehTrials.Trials(BehTrials.WinStayToLeft == 0));
scatter(BehTrials.Trials(BehTrials.WinStayToLeft == 0),ones(nTrialsForCondition,1),25,'+r');
% plot(BehTrials.Trials,Filtered_WinStayToLeft,'g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.WinStayToRight == 1));
scatter(BehTrials.Trials(BehTrials.WinStayToRight == 1),zeros(nTrialsForCondition,1)-0.1,25,'+b');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.WinStayToRight == 0));
scatter(BehTrials.Trials(BehTrials.WinStayToRight == 0),zeros(nTrialsForCondition,1),25,'+r');
% plot(BehTrials.Trials,Filtered_WinStayToRight,'b');
plot([BehTrials.GambleProbChanges'; BehTrials.GambleProbChanges'], ...
    [(zeros(length(BehTrials.GambleProbChanges),1)-0.2)'; (ones(length(BehTrials.GambleProbChanges),1)+0.2)'], '--k');
plot(BehTrials.Trials,Filtered_WinStayToRightMoveMean,'b');
plot(BehTrials.Trials,Filtered_WinStayToLeftMoveMean,'g');
ylim([-0.2 1.2])
set(gca,'Xticklabel',[]) 
title('{\color{green}WinStay2Left}, {\color{blue}WinStay2Right}');
WSRstring = cellfun(@(x) num2str(x), BehTrials.Stats.WinStayToRightProts, 'uniformoutput', false);
cellfun(@(x1,x2,x3) text(BehTrials.nTrials,1-x3,[x1,'%: WSR: ',x2,'%'], 'HorizontalAlignment', 'left', 'Color', 'b'),...
    GamProbString, WSRstring, {StringYpos1{1:length(GamProbString)}}', 'uniformoutput', false);
WSLstring = cellfun(@(x) num2str(x), BehTrials.Stats.WinStayToLeftProts, 'uniformoutput', false);
cellfun(@(x1,x2,x3) text(BehTrials.nTrials,1-x3,[x1,'%: WSL: ',x2,'%'], 'HorizontalAlignment', 'left', 'Color', 'g'),...
    GamProbString, WSLstring, {StringYpos2{1:length(GamProbString)}}', 'uniformoutput', false);

subplot(4,1,3)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.LooseShiftFromLeft2Right == 1));
scatter(BehTrials.Trials(BehTrials.LooseShiftFromLeft2Right == 1),ones(nTrialsForCondition,1)+0.1,25,'+g');
hold on
nTrialsForCondition = length(BehTrials.Trials(BehTrials.LooseShiftFromLeft2Right == 0));
scatter(BehTrials.Trials(BehTrials.LooseShiftFromLeft2Right == 0),ones(nTrialsForCondition,1),25,'+r');
% plot(BehTrials.Trials,Filtered_LooseShiftFromLeft2Right,'g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.LooseShiftFromRight2Left == 1));
scatter(BehTrials.Trials(BehTrials.LooseShiftFromRight2Left == 1),zeros(nTrialsForCondition,1)-0.1,25,'+b');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.LooseShiftFromRight2Left == 0));
scatter(BehTrials.Trials(BehTrials.LooseShiftFromRight2Left == 0),zeros(nTrialsForCondition,1),25,'+r');
% plot(BehTrials.Trials,Filtered_LooseShiftFromRight2Left,'b');
plot([BehTrials.GambleProbChanges'; BehTrials.GambleProbChanges'], ...
    [(zeros(length(BehTrials.GambleProbChanges),1)-0.2)'; (ones(length(BehTrials.GambleProbChanges),1)+0.2)'], '--k');
plot(BehTrials.Trials,Filtered_LooseShiftFromRight2LeftMoveMean,'b');
plot(BehTrials.Trials,Filtered_LooseShiftFromLeft2RightMoveMean,'g');
ylim([-0.2 1.2])
set(gca,'Xticklabel',[]) 
title('{\color{green}LooseShift2Right}, {\color{blue}LooseShift2Left}');
WSRstring = cellfun(@(x) num2str(x), BehTrials.Stats.LooseShiftFromRight2LeftProts, 'uniformoutput', false);
cellfun(@(x1,x2,x3) text(BehTrials.nTrials,1-x3,[x1,'%: LSR2L: ',x2,'%'], 'HorizontalAlignment', 'left', 'Color', 'b'),...
    GamProbString, WSRstring, {StringYpos1{1:length(GamProbString)}}', 'uniformoutput', false);
WSLstring = cellfun(@(x) num2str(x), BehTrials.Stats.LooseShiftFromLeft2RightProts, 'uniformoutput', false);
cellfun(@(x1,x2,x3) text(BehTrials.nTrials,1-x3,[x1,'%: LSL2R: ',x2,'%'], 'HorizontalAlignment', 'left', 'Color', 'g'),...
    GamProbString, WSLstring, {StringYpos2{1:length(GamProbString)}}', 'uniformoutput', false);

subplot(4,1,4)
Yamp = round(max(max(abs([BehTrials.LeftValue,BehTrials.RightValue])))/10)*10;
plot(BehTrials.Trials,BehTrials.LeftValue,'g');
hold on
plot(BehTrials.Trials,BehTrials.RightValue,'b');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.left_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.left_rewarded == 1),ones(nTrialsForCondition,1)*Yamp-(Yamp*0.1),25,'+g');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.left_NOreward == 1));
scatter(BehTrials.Trials(BehTrials.left_NOreward == 1),ones(nTrialsForCondition,1)*Yamp-((Yamp*0.1)*2),25,'+r');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.right_rewarded == 1));
scatter(BehTrials.Trials(BehTrials.right_rewarded == 1),ones(nTrialsForCondition,1)*(Yamp-(Yamp*0.1))*(-1),25,'+b');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.right_NOreward == 1));
scatter(BehTrials.Trials(BehTrials.right_NOreward == 1),ones(nTrialsForCondition,1)*(Yamp-((Yamp*0.1)*2))*(-1),25,'+r');
plot([BehTrials.GambleProbChanges'; BehTrials.GambleProbChanges'], ...
    [(ones(length(BehTrials.GambleProbChanges),1)*(-Yamp))'; (ones(length(BehTrials.GambleProbChanges),1)*Yamp)'], '--k');
line([0 BehTrials.nTrials],[0 0],'Color','k','LineStyle','--');
title('{\color{green}ValueLeft}, {\color{blue}ValueRight}');
xlabel('Trials');
ylim([-Yamp Yamp]);

%% Plotting Data - Motivation
figure('Position', [1240 0 600 1000])
subplot(4,1,1)
nTrialsForCondition = length(BehTrials.Trials(BehTrials.NoResponse == 1));
scatter(BehTrials.Trials(BehTrials.NoResponse == 1),ones(nTrialsForCondition,1)+0.1,25,'+k');
hold on
plot(BehTrials.Trials,Filtered_NoResponse,'k');
nTrialsForCondition = length(BehTrials.Trials(BehTrials.WheelNotStopping == 1));
scatter(BehTrials.Trials(BehTrials.WheelNotStopping == 1),ones(nTrialsForCondition,1)-0.1,25,'+','MarkerFaceColor',[1 0 0.65]);
hold on
plot(BehTrials.Trials,Filtered_WheelNotStopping,'r');
plot([BehTrials.GambleProbChanges'; BehTrials.GambleProbChanges'], ...
    [(zeros(length(BehTrials.GambleProbChanges),1)-0.2)'; (ones(length(BehTrials.GambleProbChanges),1)+0.2)'], '--k');
ylim([-0.2 1.2])
set(gca,'Xticklabel',[])
title('{\color{black}No Response}, {\color{red}WheelNotSpotting}');

subplot(4,1,2)
Yamp = ceil(max(max(abs([BehTrials.CumRewardLeft,BehTrials.CumRewardRight])))/100)*100;
plot(BehTrials.Trials,BehTrials.CumRewardLeft,'g');
hold on
plot(BehTrials.Trials,BehTrials.CumRewardRight,'b');
plot([BehTrials.GambleProbChanges'; BehTrials.GambleProbChanges'], ...
    [zeros(length(BehTrials.GambleProbChanges),1)'; (ones(length(BehTrials.GambleProbChanges),1)*Yamp)'], '--k');
title('{\color{green}CumRewLeft}, {\color{blue}CumRewRight}');
ylabel('Drops');
set(gca,'Xticklabel',[]) 
DropsRstring = cellfun(@(x) num2str(x), BehTrials.TotalDropsReceivedRightProts, 'uniformoutput', false);
StringYposTemp1b = StringYposTemp1 * Yamp;
StringYpos1b = num2cell(StringYposTemp1b);
% StringYpos = {Yamp*0.1;Yamp*0.2;Yamp*0.3};
cellfun(@(x1,x2,x3) text(BehTrials.nTrials,Yamp-x3,[x1,'%: DR: ',x2], 'HorizontalAlignment', 'left', 'Color', 'b'),...
    GamProbString, DropsRstring, {StringYpos1b{1:length(GamProbString)}}', 'uniformoutput', false);
DropsLstring = cellfun(@(x) num2str(x), BehTrials.TotalDropsReceivedLeftProts, 'uniformoutput', false);
StringYposTemp2b = StringYposTemp2 * Yamp;
StringYpos2b = num2cell(StringYposTemp2b);
% StringYpos = {Yamp*0.5;Yamp*0.6;Yamp*0.7};
cellfun(@(x1,x2,x3) text(BehTrials.nTrials,Yamp-x3,[x1,'%: DL: ',x2], 'HorizontalAlignment', 'left', 'Color', 'g'),...
    GamProbString, DropsLstring, {StringYpos2b{1:length(GamProbString)}}', 'uniformoutput', false);

subplot(4,1,3)
Yamp = ceil(max(max(abs([BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice ...
    ,BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice])))/10)*10;
plot(BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice, 'og');
hold on
plot(BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice, 'ob');
plot([BehTrials.GambleProbChanges'; BehTrials.GambleProbChanges'], ...
    [zeros(length(BehTrials.GambleProbChanges),1)'; (ones(length(BehTrials.GambleProbChanges),1)*10)'], '--k');
title('{\color{green}RespTimeLeft}, {\color{blue}RespTimeRight}');
ylim([0 Yamp])
ylabel('Time (sec)');
xlabel('Trials');
RespTimeRstringR = cellfun(@(x) num2str(x), BehTrials.RightRespTimeProts, 'uniformoutput', false);
% StringYpos = {Yamp*0.1;Yamp*0.2;Yamp*0.3};
cellfun(@(x1,x2,x3) text(BehTrials.nTrials,Yamp-x3,[x1,'%: RT: ',x2,'s'], 'HorizontalAlignment', 'left', 'Color', 'b'),...
    GamProbString, RespTimeRstringR, {StringYpos1b{1:length(GamProbString)}}', 'uniformoutput', false);
RespTimeRstringL = cellfun(@(x) num2str(x), BehTrials.LeftRespTimeProts, 'uniformoutput', false);
% StringYpos = {Yamp*0.5;Yamp*0.6;Yamp*0.7};
cellfun(@(x1,x2,x3) text(BehTrials.nTrials,Yamp-x3,[x1,'%: LT: ',x2,'s'], 'HorizontalAlignment', 'left', 'Color', 'g'),...
    GamProbString, RespTimeRstringL, {StringYpos2b{1:length(GamProbString)}}', 'uniformoutput', false);

subplot(4,2,7)
HistogramsBorder1 = [1;BehTrials.GambleProbChanges];
HistogramsBorder2 = [BehTrials.GambleProbChanges;BehTrials.nTrials];
ProtN = (1:length(HistogramsBorder1))';
[countsLeft, binCentersLeft, ~] = arrayfun(@(x1,x2,x3) HistogramForCell(x1, x2, x3, ...
    BehTrials.OutputStateDurations.IndOutcomeStateDurations.LeftChoice), HistogramsBorder1, HistogramsBorder2, ProtN, 'uniformoutput', false);
plot(cell2mat(binCentersLeft)', cell2mat(countsLeft)');
title('{\color{black}RespTimeLeft}');
ylabel('count');
xlabel('Time (sec)');

subplot(4,2,8)
[countsRight, binCentersRight, LegendTitle] = arrayfun(@(x1,x2,x3) HistogramForCell(x1, x2, x3, ...
    BehTrials.OutputStateDurations.IndOutcomeStateDurations.RightChoice), HistogramsBorder1, HistogramsBorder2, ProtN, 'uniformoutput', false);
plot(cell2mat(binCentersRight)', cell2mat(countsRight)');
legend(LegendTitle)
title('{\color{black}RespTimeRight}');
ylabel('count');
xlabel('Time (sec)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cell Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Filtered_Data = Gaussian1D(Vector,WinSize)

w=gausswin(WinSize);
w=w./sum(w);
Filtered_Data = conv (Vector, w, 'same');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [count,Center,LegendTitle] = HistogramForCell(Border1, Border2, ProtN, Input)
    [count,Center] = hist(Input(Border1:Border2),20);
    % count = count/sum(count);
    LegendTitle = ['Prot',num2str(ProtN)];
end

end