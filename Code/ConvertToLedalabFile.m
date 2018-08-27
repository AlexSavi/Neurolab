clear all;
close all;

load('typical_ledalab');
load 'C:\Users\Alex\Documents\TPS 2A\Stage 2A\TNO\cleaning signal\stimuli\Results\result.mat';
path='C:\Users\Alex\Documents\TPS 2A\Stage 2A\TNO\cleaning signal\Neurolab Git\Artifact Experiment\Laura 02-8-18 - Copy\2018-08-02 19.57.02 LAURA RIGHT PALM MOVING ARTIFACT EXP';


jUnisensFactory = org.unisens.UnisensFactoryBuilder.createFactory();
jUnisens = jUnisensFactory.createUnisens(path);

edaEntry = jUnisens.getEntry('eda.bin');
edaData = edaEntry.readScaled(edaEntry.getCount());

% Get sample rate
SReda = edaEntry.getSampleRate(); 
% 
% edaCeiling = 60; %in µS
% edaFloor = 0.2; %in µS
% maxslope = 1; %in µS per sec
% 
% TimeStart = unisens_get_timestampstart(path);
% 
% suspiciousData = NaN(length(edaData),1);
% edafiltered = NaN(length(edaData),1);
% 
% k=1:size(edaData,1);
% TimeEda = k/SReda;
% edaData_decale = circshift(edaData,1);
% index = edaData>edaCeiling | edaData<edaFloor | (edaData_decale-edaData)>maxslope/SReda | edaData_decale-edaData<-maxslope/SReda;
% 
% edafiltered(not(index))=edaData(not(index));
% suspiciousData(index)=edaData(index);
% TimeStampEDA = datetime(TimeStart) + (k-1)*seconds(1/SReda);

% LEDAdata=struct(data);
% LEDAdata.conductance = edaData(1:6399)';
% LEDAdata.time = TimeEda(1:6399);

cd(path);

data.conductance = edaData(5:length(edaData));
data.time = (1:length(edaData(5:length(edaData))))/SReda;
data.timeoff = 0;
data.event = [];
save('mydata','data')

