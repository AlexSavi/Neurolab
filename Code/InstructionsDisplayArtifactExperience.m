clear all;
close all;

% Clear the workspace and the screen
close all;
clearvars;
sca

% Randomly seed the random number generation
rng('shuffle');

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Skip sync tests for demo purposes only
Screen('Preference', 'SkipSyncTests', 2);

% Get the screen numbers
screens = Screen('Screens');

% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);

% Define black
black = BlackIndex(screenNumber);

% Open an on screen window and color it grey
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Set the blend functon for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

% We set the text size to be nice and big here
Screen('TextSize', window, 50);

% Get the nominal framerate of the monitor. For this simple timer we are
% going to change the counterdown number every second. This means we
% present each number for "frameRate" amount of frames. This is because
% "framerate" amount of frames is equal to one second. Note: this is only
% for a very simple timer to demonstarte the principle. You can make more
% accurate sub-second timers based on this.
nominalFrameRate = Screen('NominalFrameRate', window);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Customizing the text to show here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Setting stimuli to display: protocolText
%Setting duration in sec to display: secSeries

% Loads external config
data = load_config('config.xls');
protocolText = data{1}';
colorCode = data{2}';

%Repeating
%repProtocol = [10,10,10,10,10,10];
NumberofCycles = 10;
%Duration (secs)
% secOfProtocol = [10,10,10,10,10,10];
NumberofSeconds = 10;
protocolTextShuffled={};
colorCodeShuffled = {};

%%you permute randomly each 6 commands for the given number of cycles
for i=1:NumberofCycles
    shufflingOrder = randperm(length(protocolText));
    for idx = 1:length(shufflingOrder)
        protocolTextShuffled = horzcat(protocolTextShuffled,protocolText{shufflingOrder(idx)});
        colorCodeShuffled = horzcat(colorCodeShuffled,colorCode{shufflingOrder(idx)});
    end
end

protocolTextSeries = {};
colorCodeSeries = {};

for j=1:length(protocolTextShuffled)
    for countSec = sort(1:NumberofSeconds,'descend')
        for l = 1:nominalFrameRate
            protocolTextSeries = horzcat(protocolTextSeries,[protocolTextShuffled{j}]);
            fadingFactor = 0.85^(NumberofSeconds-countSec);
            colorCodeSeries = horzcat(colorCodeSeries,cell2mat(colorCodeShuffled(j))*fadingFactor);
        end
    end
end
    



textChangeCounter = 0;
timestamp_time = {};
timestamp_marker = {};
total = {};
% Here is our drawing loop
for i = 1:length(protocolTextSeries)    

    % Flip to the screen
    Screen('Flip', window);

    % Draw our number to the screen
    DrawFormattedText(window, protocolTextSeries{1,i}, 'center', 'center', colorCodeSeries{1,i});

    % Decide if to change the color on the next frame
    textChangeCounter = textChangeCounter + 1;
    if mod(textChangeCounter,nominalFrameRate) == 1       
          
          fprintf([protocolTextSeries{1,i} '\n']);
          timestamp_time = vertcat(timestamp_time,clock);
          timestamp_marker = vertcat(timestamp_marker,protocolTextSeries{1,i});
          
    end
    
end
% Wait a second before closing the screen
WaitSecs(1);

% %Creating an array containing both variables (useless)
% total = horzcat(timestamp_time,timestamp_marker);
% for i = 1:length(total)
%     total{i,1} = datetime(total{i,1});
% end

path = uigetdir; %% Choose where you want to save the variables
cd(path);
save 'timestamp_markers.mat' timestamp_marker;
save 'timestamp_time.mat' timestamp_time;
% save 'result.mat' total; 

% Clear the screen
close all;
clearvars -except timestamp_time timestamp_marker protocolTextSeries total %enables you to manually save the variables and/or visualize them in matlab
sca
 