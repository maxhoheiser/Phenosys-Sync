folder = 'C:\Users\Nutzer\Google Drive\1 Uni\1.3 Uni Projekte\Masterarbeit Laborarbeit Neuroscience\Data Analysis\JG14_190621';

ttl_event_1 = loadDigitalDat(folder,1);
[ttl_event_1, ttl_event_1_1] = convertToBehavior(ttl_event_1);
ttl_event_1_trials_2 = convertToTrials(ttl_event_1_1);
[excel, excel_trials] = readExcel(folder);
[output_data, output_data_ttl] = correctMisAlignment(excel_trials,ttl_event_1_trials_2);
[ground_truth, ground_truth_trial] = detailedTimeCorrelation(excel,ttl_event_1);
ground_truth(2481:end,:) = [];

%% find trials in ttl not in excel in ground turth
col = size(output_data_ttl,1)+1;
for i = 1:size(output_data_ttl,1)
    for j = 2:8
        if sum(output_data_ttl(i,j)==ground_truth(:,4))~=0
            output_data_ttl(col,j)=1;
        else
            output_data_ttl(col,j)=0;
        end
    end
    col = col + 1;
end

%%
find_not_in_excel = findNotInExcel(output_data, output_data_ttl, ground_truth);
compare_2_methods = compare2Methods(output_data,ground_truth);

% write to file
dir_char = convertStringsToChars(strcat(folder,"\ttl_behavior"));
save(dir_char,'ground_truth');
dir_char = convertStringsToChars(strcat(folder,"\ttl_behavior_trials"));
save(dir_char,'ground_truth_trial');

%writeFiles(directory,filename,vargin)
% vargin = [output_data, output_data_ttl, ttl_event_1_1, excel,
% ground_truth, ground_truth_trial, compare_2_methods, find_not_in_excel]



%% Plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% plotting methode 2
folder = 'figures/alignment/'

if ~exist('figures', 'dir')
    mkdir('figures')
end
if ~exist('figures/alignment', 'dir')
    mkdir('figures/alignment')
end

% histogram for diviation of behavior phenosys vs ttl for ground truth
for i = 1:11
    vec = ground_truth(ground_truth(:,2)==i,:); 
    h = histogram(vec(:,10));
    title('Time Difference Trial Start (Phenosis - TTL');
    xlabel('Event Number'); 
    ylabel('Difference in [ms]'); 
    x = h.BinEdges ;
    y = h.Values ;
    p = round((y.*100)/sum(y),2);
    yt=y';
    pt=p';
    str = strcat(num2str(yt),num2str(pt),{'%'});
    text(x(1:end-1),y,str,'vert','bottom'); 
    box off;
    drawnow;
    
    string = 'Ground Tuth - Diviation Behavior_';
    name = strcat(folder,string,num2str(i));
    saveas(gcf,name,'png');
    saveas(gcf,name,'fig');
    clear('fig','name','vec','string');
end


% histogram of diviation -> in a combined plot
%figure;
for i = 1:11
    subplot(4,3,i);
    vec = ground_truth(ground_truth(:,2)==i,:); 
    h = histogram(vec(:,10));
    string = ('Event - ');
    title(strcat(string,num2str(i)));
%    xlabel('Event Number'); 
    xlabel('Difference'); 
    xlim([-10, 10]);
    x = h.BinEdges ;
    y = h.Values ;
    p = round((y.*100)/sum(y),2);
    yt=y';
    pt=p';
    str = (strcat(num2str(pt),{'%'}))';
    str = str';
    str((p(1,:)==0),:)=cellstr(' ');
    text(x(1:end-1),y,str,'FontSize',4,'vert','bottom'); 
    box off;
    drawnow
end
drawnow;
title('Event Difference (Phenosis - TTL');
string = 'Ground Tuth - Diviation Behavior_all';
name = strcat(folder,string);
saveas(gcf,name,'png');
saveas(gcf,name,'fig');
clear('fig','name','vec','string');
close(figure(1))
figure(1)

% scatterplot of time difference for event start phenosys vs ttl
j=1;
for i = [1 2 3 4 10 11]
    col = ["r","g","b","m","c","k"]; 
    vec = ground_truth_trial(ground_truth_trial(:,2)==i,[11 9]);
    scatter(vec(:,1),vec(:,2),'.',col(j));
    j = j+1;
    hold on
end

vec = ground_truth_trial(not(ismember(ground_truth_trial(:,2),[1 2 3 4 10 11])),[11 9]);
scatter(vec(:,1),vec(:,2),'*','k');

% v line for trial begin ---
vec = ground_truth_trial(ground_truth_trial(:,2)==1,11);
for i = 1:sum(ground_truth_trial(:,2)==1)
    xline(vec(i,1),'-r');
end

% v line for trial end
vec = ground_truth_trial(ground_truth_trial(:,13)~=0,11);
for i = 1:sum(ground_truth_trial(:,13)~=0)
    xline(vec(i,1),'b');
end
hold off
title('Time Difference Trial Start (Phenosis - TTL')
xlabel('Event Number') 
ylabel('Difference in [ms]') 
legend('1','2','3','4','10','11','reward')
string = 'Ground Tuth - Diviation Time of Event';
name = strcat(folder,string);
saveas(gcf,name,'png');
saveas(gcf,name,'fig');


% histogram trial length diviation
vec = ground_truth_trial(ground_truth_trial(:,13)~=0,[12 15]);
vec2 = vec(abs(vec(:,2))<2,:);
h = histogram(vec2(:,2));
x = h.BinEdges ;
y = h.Values ;
p = round((y.*100)/sum(y),2);
str = strcat(num2str(p'),{'%'});
text(x(1:end-1),y,str,'FontSize',8,'vert','bottom');
box off;
drawnow;
title('Trial Length Difference (Phenosis - TTL')
xlabel('Difference in [ms]') 
string = 'Ground Tuth - Diviation Length of Trial - Histogram';
name = strcat(folder,string);
saveas(gcf,name,'png');
saveas(gcf,name,'fig');

% scatterplot trial and trial length diviation
vec = ground_truth_trial(ground_truth_trial(:,13)~=0,[12 15]);
vec2 = vec(abs(vec(:,2))<2,:);
scatter(vec2(:,1),vec2(:,2),'.');
yline(0)
title('Trial Length Difference (Phenosis - TTL')
xlabel('Trial Number') 
ylabel('Difference in [ms]') 
string = 'Ground Tuth - Diviation Length of Trial';
name = strcat(folder,string);
saveas(gcf,name,'png');
saveas(gcf,name,'fig');

% scatterplot trial and trial length
%% plotten methode 1
hold off
%sum(compare_2_methods(:,14)>40)
compare_2_methods(:,15)=compare_2_methods(:,14);
compare_2_methods(compare_2_methods(:,15)>40,14)=0;

j=1;
for i = [1 2 3 4 10 11]
    col = ["r","g","b","m","c","k"]; 
    vec = compare_2_methods(compare_2_methods(:,4)==i,[13 15]);
    scatter(vec(:,1),vec(:,2),'.',col(j));
    j = j+1;
    hold on
end

vec = compare_2_methods(not(ismember(compare_2_methods(:,4),[1 2 3 4 10 11])),[13 15]);
scatter(vec(:,1),vec(:,2),'*','k');

% v line for trial begin ---
vec = compare_2_methods(compare_2_methods(:,4)==1,13);
for i = 1:sum(compare_2_methods(:,4)==1)
    xline(vec(i,1),'-r');
end

% v line for trial end
vec = compare_2_methods(compare_2_methods(:,4)==11,13);
for i = 1:sum(compare_2_methods(:,4)==11)
    xline(vec(i,1),'b');
end

title('Time Difference Trial Start (Phenosis - TTL')
xlabel('Event Number') 
ylabel('Difference in [ms]') 
legend('1','2','3','4','10','11','reward')
string = 'Output Data - Diviation Time of Event';
name = strcat(folder,string);
saveas(gcf,name,'png');
saveas(gcf,name,'fig');
hold off

% histogram of trial length
h = histogram(output_data(:,16));
x = h.BinEdges ;
y = h.Values ;
p = round((y.*100)/sum(y),2);
str = strcat(num2str(y'),{' - '},num2str(p'),{'%'});
text(x(1:end-1),p,str,'FontSize',8,'vert','top');
box off;
drawnow;
title('Trial Length [ms]');
xlabel('Trial Length'); 
ylabel('Count') ;
string = 'Phenosys - Trial Length';
name = strcat(folder,string);
saveas(gcf,name,'png');
saveas(gcf,name,'fig');
%% plotting both methods all trials

missing_ttl = [];
for i=1:sum(output_data_ttl(:,1)~=0)
    s = size(missing_ttl,1);
    missing_ttl(s+1:s+7,1) = output_data_ttl(i,2:8)';
    missing_ttl(s+1:s+7,2) = output_data_ttl(i,9:15)';
    missing_ttl(s+1:s+7,3) = output_data_ttl(i,1);
    missing_ttl(s+7,4) = output_data_ttl(i,16);
end
missing_ttl(:,5)=(missing_ttl(:,1)-compare_2_methods(1,7));

compare_2 = output_data_ttl(output_data_ttl(:,1)~=0,1);
%compare_2(:,2)= (compare_2(:,1) - compare_2_methods(1,7));
for w = compare_2'
    hold off
    %w = 92;
    a_1 = find(compare_2_methods(:,1)==w,1);
    
    a = a_1-(3*7);
    b = a_1+(4*7);
    
    % phenosys trials
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Start_Index=ground_truth_trial(:,2)==1;
    Index=zeros(size(ground_truth_trial,1),1);
    Index(a:b)=1;
    New_Index=(Start_Index.*Index);
    vec1 = ground_truth_trial(logical(New_Index),4);
    hold on
    plot(vec1(:,1),0,'xr');
    
    j=1;
    for i = [2 3 4 10]
        col = ['g','b','m','c'];
        Start_Index=ground_truth_trial(:,2)==i;
        Index=zeros(size(ground_truth_trial,1),1);
        Index(a:b)=1;
        New_Index=(Start_Index.*Index);
        vec1 = ground_truth_trial(logical(New_Index),4);
        str = ['.',col(j)];
        hold on
        plot(vec1(:,1),0,str,'MarkerSize', 10);
        j = j+1;
    end
    
    
    %vec = ground_truth_trial(not(ismember(ground_truth_trial(a:b,2),[1 2 3 4 10 11])),[4 9]);
    
    Start_Index=not(ismember(ground_truth_trial(:,2),[1 2 3 4 10 11]));
    Index=zeros(size(ground_truth_trial,1),1);
    Index(a:b)=1;
    New_Index=(Start_Index.*Index);
    vec1 = ground_truth_trial(logical(New_Index),4);
    hold on
    plot(vec1(:,1),0,'.k','MarkerSize', 10);
    
    Start_Index=ground_truth_trial(:,2)==11;
    Index=zeros(size(ground_truth_trial,1),1);
    Index(a:b)=1;
    New_Index=(Start_Index.*Index);
    vec1 = ground_truth_trial(logical(New_Index),4);
    hold on
    plot(vec1(:,1),0,'*k');
    
    % line between start and end of trial
    vec_l = []
    for i = a:b %size(ground_truth_trial,1)-6
        s = size(vec_l,1);
        if ground_truth_trial(i,2)==1 && ground_truth_trial(i+6,2)==11
            vec_l(s+1,1) = ground_truth_trial(i,4);
            vec_l(s+1,2) = ground_truth_trial(i+6,4);
            hold on
            line([vec_l(s+1,1) vec_l(s+1,2)], [0 0]);
            hold on
            plot([vec_l(s+1,1) vec_l(s+1,1)], [-0.2 0.2], 'r');
            hold on
            plot([vec_l(s+1,2) vec_l(s+1,2)], [-0.2 0.2], 'k');
        end
    end
    
    % ttl trials
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    Start_Index=ground_truth_trial(:,5)==1;
    Index=zeros(size(ground_truth_trial,1),1);
    Index(a:b)=1;
    New_Index=(Start_Index.*Index);
    vec1 = ground_truth_trial(logical(New_Index),4);
    hold on
    plot(vec1(:,1),2,'xr');
    
    j=1;
    for i = [2 3 4 10]
        col = ["g","b","m","c",];
        Start_Index=ground_truth_trial(:,5)==i;
        Index=zeros(size(ground_truth_trial,1),1);
        Index(a:b)=1;
        New_Index=(Start_Index.*Index);
        vec1 = ground_truth_trial(logical(New_Index),4);
        str = strcat('.',col(j));
        hold on
        plot(vec1(:,1),2,str,'MarkerSize', 10);
        j = j+1;
    end
    
    
    
    Start_Index=not(ismember(ground_truth_trial(:,5),[1 2 3 4 10 11]));
    Index=zeros(size(ground_truth_trial,1),1);
    Index(a:b)=1;
    New_Index=(Start_Index.*Index);
    vec1 = ground_truth_trial(logical(New_Index),4);
    hold on
    plot(vec1(:,1),2,'.k','MarkerSize', 10);
    
    
    Start_Index=ground_truth_trial(:,5)==11;
    Index=zeros(size(ground_truth_trial,1),1);
    Index(a:b)=1;
    New_Index=(Start_Index.*Index);
    vec1 = ground_truth_trial(logical(New_Index),4);
    hold on
    plot(vec1(:,1),2,'*k');
    
    % line between start and end of trial
    vec_l = []
    for i = a:b %size(ground_truth_trial,1)-6
        s = size(vec_l,1);
        if ground_truth_trial(i,5)==1 && ground_truth_trial(i+6,5)==11
            vec_l(s+1,1) = ground_truth_trial(i,4);
            vec_l(s+1,2) = ground_truth_trial(i+6,4);
            hold on
            line([vec_l(s+1,1) vec_l(s+1,2)], [2 2]);
            hold on
            plot([vec_l(s+1,1) vec_l(s+1,1)], [1.8 2.2], 'r');
            hold on
            plot([vec_l(s+1,2) vec_l(s+1,2)], [1.8 2.2], 'k');
        end
    end
    
    % missing trials
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    vec_w = missing_ttl(missing_ttl(:,3)==w,:);
    vec1 = vec_w(vec_w(:,2)==1,5);
    hold on
    plot(vec1(:,1),1,'xr');
    
    j=1;
    for i = [2 3 4 10]
        col = ["g","b","m","c",];
        vec_w = missing_ttl(missing_ttl(:,3)==w,:);
        vec = vec_w(vec_w(:,2)==i,[5]);
        str = strcat('.',col(j));
        hold on
        if sum(vec)~=0
            plot(vec(:,1),1,str,'MarkerSize', 10);
        end
        j = j+1;
    end
    
    
    vec_w = missing_ttl(missing_ttl(:,3)==w,:);
    vec = vec_w(not(ismember(vec_w(:,2),[1 2 3 4 10 11])),[5]);
    hold on
    plot(vec(:,1),1,'.k','MarkerSize', 10);
    
    vec_w = missing_ttl(missing_ttl(:,3)==w,:);
    vec11 = vec_w(vec_w(:,2)==11,5);
    hold on
    plot(vec11(:,1),1,'*k');
    
    
    
    % line between start and end of trial
    % vec_l = []
    % for i = a:b %size(ground_truth_trial,1)-6
    %     s = size(vec_l,1);
    %     if missing_ttl(i,2)==1 && missing(i+6,5)==11
    %         vec_l(s+1,1) = ground_truth_trial(i,4);
    %         vec_l(s+1,2) = ground_truth_trial(i+6,4);
    %         hold on
    %         line([vec_l(s+1,1) vec_l(s+1,2)], [2 2]);
    %         hold on
    %         plot([vec_l(s+1,1) vec_l(s+1,1)], [1.8 2.2], 'r');
    %         hold on
    %         plot([vec_l(s+1,2) vec_l(s+1,2)], [1.8 2.2], 'k');
    %     end
    % end
    
    
    hold on
    %legend('0 = phenosys', '1 = missing ttl', '2=ttl')
    string_1 = 'Missing TTL Trial';
    string = strcat(string_1,{' - '},num2str(w));
    title(string);
    xlabel('Time [ms]');
    ylabel('File (0=ground truth phenosys, 5=ground truth ttl, 2=missing trials') ;
    
    trial = output_data_ttl(output_data_ttl(:,1)~=0,1);
    string = 'Missing TTL Trial';
    name = strcat(folder,string,' - ',num2str(w));
    saveas(gcf,name,'png');
    saveas(gcf,name,'fig');
    hold off
    close all


end
%% plot 30 random trials ttl signal + ground truth trials
max_t = 30

rng('shuffle');
r1 = randi(max(ground_truth_trial(:,12)),max_t,1);

for i = 1:max_t
    figure(i)
    dy = (-0.1+0.01); % displacement so the text does not overlay the data points
    
    % plot ttl in range of missing
    trial_now = r1(i,1);  
    trial_plot = ground_truth_trial(ground_truth_trial(:,12)==trial_now,:);
       
    anf = (trial_plot(1,8)-5)*20 
    ende = (trial_plot(7,8)+5)*20
    
    plot(ttl_signal(anf:ende,2));
    ylim([-0.3 1.2])
    xlim([-1000 (ende-anf+1000)])
    
    grid on
    
    % plott phenosys for same trial or range
    % plott ttl for same trial or range
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    for len=1:size(trial_plot,1)
        vec1(len,1) = (trial_plot(len,8)-trial_plot(1,8));
    end
    
    % for start
    vec1_now = vec1(1,1);
    vec1_now = (vec1_now+5)*20
    hold on
    plot(vec1_now(:,1),-0.1,'xr');
    hold on 
    text(vec1_now(:,1), dy, num2str(trial_plot(1,2)), 'Fontsize', 4);
    
    % for 2,3,4,10
    col_index=1;
    for index_event = [2 3 4 10]
        col = ["g","b","m","c",];
        vec1_now = vec1(trial_plot(:,2)==index_event,1);
        vec1_now = (vec1_now+5)*20
        str = strcat('.',col(col_index));
        hold on
        plot(vec1_now(:,1),-0.1,str,'MarkerSize', 10);
        col_index = col_index+1;
        text(vec1_now(:,1), dy, num2str(index_event), 'Fontsize', 4);
    end
    
    
    % for response   
    vec1_now = vec1(not(ismember(trial_plot(:,5),[1 2 3 4 10 11])),1);
    vec1_now = (vec1_now+5)*20
    hold on
    plot(vec1_now(:,1),-0.1,'xk','MarkerSize', 10);
    hold on 
    
    event_num = trial_plot(not(ismember(trial_plot(:,5),[1 2 3 4 10 11])),5);
    
    %text(vec1_now(:,1), dy, num2str(event_num), 'Fontsize', 4);
    % for 11
    vec1_now = vec1(trial_plot(:,5)==11,1);
    vec1_now = (vec1_now+5)*20
    hold on
    plot(vec1_now(:,1),-0.1,'*r');

    
    % line between start and end of trial
    plot([(vec1(1,1)*20) (vec1(end,1)*20)], [-0.1 -0.1], 'b');
    

    % plott phenosys for same trial or range
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    for len=1:size(trial_plot,1)
        vec1(len,1) = (trial_plot(len,8)-trial_plot(1,8));
    end
    
    % for start
    vec1_now = vec1(trial_plot(1,2)==1,1);
    vec1_now = (vec1_now+5)*20
    hold on
    plot(vec1_now(1,1),-0.2,'xr');
    
    % for 2,3,4,10
    col_index=1;
    for index_event = [2 3 4 10]
        col = ["g","b","m","c",];
        vec1_now = vec1(trial_plot(:,2)==index_event,1);
        vec1_now = (vec1_now+5)*20
        str = strcat('.',col(col_index));
        hold on
        plot(vec1_now(:,1),-0.2,str,'MarkerSize', 10);
        col_index = col_index+1;
    end
    
    
    % for response
    vec1_now = vec1(not(ismember(trial_plot(:,2),[1 2 3 4 10 11])),1);
    vec1_now = (vec1_now+5)*20
    hold on
    plot(vec1_now(:,1),-0.2,'xk','MarkerSize', 10);
    
    
    % for 11
    vec1_now = vec1(trial_plot(:,2)==11,1);
    vec1_now = (vec1_now+5)*20
    hold on
    plot(vec1_now(:,1),-0.2,'*r');
    
    
    % line between start and end of trial
    plot([(vec1(1,1)*20) (vec1(end,1)*20)], [-0.2 -0.2], 'b');
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % save to file
    folder_2 = 'figures/alignment/random/';
    
    if ~exist('figures', 'dir')
        mkdir('figures');
    end
    if ~exist('figures/alignment', 'dir')
        mkdir('figures/alignment');
    end
    
    if ~exist('figures/alignment/random', 'dir')
        mkdir('figures/alignment/random');
    end
    
    title(strcat('Random Trial',{' - '},num2str(i)));
    legend('-0.1 = ttl trials','-0.2 = phenosys trials');
    string = 'Random Trial';
    name = char(strcat(folder_2,'Random Trial',{' - '},num2str(i)));
    saveas(gcf,name,'jpeg');
    saveas(gcf,name,'fig');
    %clear('fig','name','vec','string');

    
    hold off
    close(figure(i))
end
