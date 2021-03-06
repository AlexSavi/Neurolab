clear all;
close all;

%%Select the folder where the data has been exported
path = uigetdir;

cd(path);

%% loading the two data sets and the markers from the experiment (previously saved)

load('edaDataSet1.mat');
load('timestampset1.mat');

load('edaDataSet2.mat');
load('timestampset2.mat');


load('timestamp_markers.mat');
load('timestamp_time.mat');

%% Loads config : corresponding vectors Events <-> Colors

data = load_config('config.xls');
ListOfEvents = data{1}';
ListOfColors = data{2}';

data1_color = [0.66 0.79 0.44]';
data2_color = [0.58 0.46 0.84]';

%% Extracting the event markers and corresponding date

timeStart_marker = timestamp_time{1, 1};
date_start = datetime(timeStart_marker);

output_date = [];
output_marker = {};

for index = 1:10:length(timestamp_time)
    output_date = [output_date date_start+(index-1)*seconds()];
    output_marker(end+1) = timestamp_marker(index);
end
 
%% Plot the data from both sets

plot(TimeStampEDA1,edaData1,'color', data1_color,'LineWidth',1.5);
hold on;
plot(TimeStampEDA2,edaData2,'color', data2_color,'LineWidth',1.5);
ylim([0 4*max(mean(edaData1),mean(edaData1))]); %arbitrary y limit to visualize the data even with the non pre-processe data
title("Comparing 2 EDA sigals",'FontSize',20);
ylabel("EDA in �S");
% xticks(output_date); % Display the date of each event on the x axis
set(gca,'fontsize',20);

%% Linking each event to the corresponding color in the ListOfEvents and ListOfColors

for k = 1:length(output_date)    
    index = find(strcmp(ListOfEvents, output_marker(k)));
    color_option_cell = ListOfColors(index);
    color_option = color_option_cell{1};
    plot([output_date(k) output_date(k)], ylim, 'color', color_option{1},'LineWidth',1.2);    
end

%% Legend customization

legend_colors = [plot([NaN,NaN], 'color', data1_color) plot([NaN,NaN], 'color', data2_color)];
legend_names = {'Left palm sensor reference ', 'Right palm sensor moving'};

for i=1:length(ListOfEvents)
    color_option_cell = ListOfColors(i);
    color_option = color_option_cell{1};
    legend_colors = [legend_colors plot([NaN,NaN],'color', color_option{1})];
    legend_names = [legend_names ListOfEvents(i)];
end

legend(legend_colors, legend_names,'FontSize',14);


%% 2nd part : Difference between left and right

time_ref = [];
time_else = [];
data_ref = [];
data_else = [];

if(TimeStampEDA1(1)<TimeStampEDA2(1)) %Which sensor has first started recording, if it's the 1st one, we choose the 2nd's first datetime as starting point
    time_ref = TimeStampEDA2;
    data_ref = edaData2;
    time_else = TimeStampEDA1;
    data_else = edaData1;
else
    time_ref = TimeStampEDA1;
    data_ref = edaData1;
    time_else = TimeStampEDA2;
    data_else = edaData2;
end


%time difference


time_difference = [];

k=1:length(time_else);
time_difference(k) = abs(datenum(time_ref(1))-datenum(time_else(k)));
min_index = find(time_difference==min(time_difference));

%Make sub-arrays
len_time_else = length(time_else);
time_else = time_else(min_index:len_time_else);
data_else = data_else(min_index:len_time_else);

if length(time_else) < length(time_ref)
    last_index = length(time_else)-1;
else
    last_index = length(time_ref) -1;
end

time_ref_output = [];
data_ref_output = [];
time_else_output = [];
data_else_output = [];

i = 1:last_index;
time_ref_output = time_ref(i);
data_ref_output = data_ref(i);
time_else_output = time_ref(i);
data_else_output = data_else(i);

figure(2);
hold on;

plot(time_ref_output, data_ref_output-data_else_output,'LineWidth',1.5);
% plot(time_ref_output, abs(max(data_ref_output,data_else_output)-min(data_ref_output,data_else_output)),'LineWidth',1.5);
title('Difference between both signals over time at the same datetime','FontSize',20);
ylabel('Difference in EDA in �S');
set(gca,'fontsize',20);

%% 3rd part : Display signals resulting from the same instruction

%N.B : we only display the 2nd signal which the "moving" hand sensor
% time_markers = NaN(;

for i=1:10:length(timestamp_marker)
    for j=1:length(ListOfEvents)
        logical_tab(i,j) = strcmp(timestamp_marker{i}, ListOfEvents{j});

    end
end

for j=1:size(logical_tab,2)
   for i=1:size(logical_tab,1)
      if logical_tab(i,j)==1
          time_markers(i,j) = datetime(timestamp_time{i});
      end
   end
end


for j=1:size(logical_tab,2)
   time_markers_clean(:,j) = time_markers(any(~isnat(time_markers(:,j)),2),j);
end

for j=1:size(time_markers_clean,2)
    figure(2+j);
    hold on;
    for i=1:size(time_markers_clean,1)

            time_ref2 = time_markers_clean(i,j);    %Regular raw signal
            time_else2 = TimeStampEDA2;
            data_else2 = edaData2;

            
%             time_ref2 = time_markers_clean(i,j);  %difference left/right
%             data_else2 = data_ref_output-data_else_output;
%             time_else2 = time_ref_output;


        time_difference2 = [];
        
        k=1:length(time_else2);
        time_difference2(k) = abs(datenum(time_ref2)-datenum(time_else2(k)));
        min_index2 = find(time_difference2==min(time_difference2));
        last_index2 = min_index2+320;

        %Make sub-arrays

        data_output = data_else2(min_index2:last_index2);
        if i==1
            offset_ref = data_else2(1);
        end
            data_output=data_output-(data_output(1)-offset_ref);
        
        ylim([-0.25 0.25]);
        axis_compare = (1:321);
        plot(axis_compare,data_output,'LineWidth',3);
        set(gca,'fontsize',20);
    end
    title(ListOfEvents(j),'FontSize',38);
end