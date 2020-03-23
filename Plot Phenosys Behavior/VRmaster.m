function VRmaster

warning('off')

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
while(1)
    VRpreprocessing
    pause(0.001)
end

end