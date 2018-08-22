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

plot(TimeStampEDA1,edaData1,'color', data1_color);
hold on;
plot(TimeStampEDA2,edaData2,'color', data2_color);
ylim([0 4*max(mean(edaData1),mean(edaData1))]); %arbitrary y limit to visualize the data even with the non pre-processe data
title("Comparing 2 EDA sigals");
ylabel("EDA in µS");
xticks(output_date); % Display the date of each event on the x axis

%% Linking each event to the corresponding color in the ListOfEvents and ListOfColors

for k = 1:length(output_date)    
    index = find(strcmp(ListOfEvents, output_marker(k)));
    color_option_cell = ListOfColors(index);
    color_option = color_option_cell{1};
    plot([output_date(k) output_date(k)], ylim, 'color', color_option{1});    
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

legend(legend_colors, legend_names);
