clear all;
close all;

tic

%   0) Préliminaires (pour utiliser unisens4matlab)
% a. path
path='C:\Users\Alex\Documents\data_edamove\2018-06-29 10.22.46';

% b. create unisens object

jUnisensFactory = org.unisens.UnisensFactoryBuilder.createFactory();
jUnisens = jUnisensFactory.createUnisens(path);


%	1) identifying suspicious data variables

edaCeiling = 60; %in µS
edaFloor = 0.2; %in µS
maxslope = 1; %in µS per sec

% Read a binary file
edaEntry = jUnisens.getEntry('eda.bin');
edaData = edaEntry.readScaled(edaEntry.getCount()); 

accEntry = jUnisens.getEntry('acc.bin');
accData = accEntry.readScaled(accEntry.getCount());

% Get sample rate
SReda = edaEntry.getSampleRate(); 
SRacc = accEntry.getSampleRate();


% Time axis

TimeStart = unisens_get_timestampstart(path);


%% Analyzing data

% -- Part 1 :

suspiciousData = NaN(length(edaData),1);
edafiltered = NaN(length(edaData),1);
k=1:5;
edaData(k,:)=0;
k=1:size(edaData,1);
TimeEda = k/SReda;
edaData_decale = circshift(edaData,1);
index = edaData>edaCeiling | edaData<edaFloor | (edaData_decale-edaData)>maxslope/32 | edaData_decale-edaData<-maxslope/32;

edafiltered(not(index))=edaData(not(index));
suspiciousData(index)=edaData(index);
TimeStampEDA = datetime(TimeStart) + (k-1)*seconds(1/SReda);

% -- Part 2:


k=1:size(accData,1);
TimeAcc = k/SRacc;
TimeStampAcc = datetime(TimeStart) + (k-1)*seconds(1/SRacc);

medfiltEda = movmean(edaData,64);

%%	3) Output

figure(1);
ax1 = subplot(3,1,1);
plot(ax1,TimeStampAcc,accData);
title('Acceleration over time');
xlabel('Time');
ylabel('Acceleration in g');

ax2 = subplot(3,1,2);
plot(ax2,TimeStampEDA,edafiltered);
hold on;
plot(ax2,TimeStampEDA,suspiciousData,'-r');
title('EDA recorded over time');
xlabel('Time');
ylabel('EDA in µS');
legend(ax2,{'EDA','suspicious data'});
ylim([0 20]);

ax3 = subplot(3,1,3);
plot(ax3,TimeStampEDA,medfiltEda);
title('Test with moving average transform');
xlabel('Time');
ylabel('EDA in µS');
ylim([0 20]);

toc

conductance = edaData;
time = TimeEda;
timeoff = 0;

csvwrite('conductance.csv',conductance);
csvwrite('time.csv',time');
