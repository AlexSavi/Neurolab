%This program is meant to extract data from edaMove files to csv. THe
%preprocessing applied will be simply to set the first values (outliers) to
%0. They should not hold any relevant info anyway. It requires the
%unisens4matlab toolbox

clear all;
close all;

%Choose the desired set
path = uigetdir;

%Create the Unisens4matlab environment

jUnisensFactory = org.unisens.UnisensFactoryBuilder.createFactory();
jUnisens = jUnisensFactory.createUnisens(path);


edaEntry = jUnisens.getEntry('eda.bin');
edaData = edaEntry.readScaled(edaEntry.getCount()); 

k=1:5;
edaData(k) = 0;
accEntry = jUnisens.getEntry('acc.bin');
accData = accEntry.readScaled(accEntry.getCount());

movaccEntry = jUnisens.getEntry('movementacceleration.bin');
movaccData = movaccEntry.readScaled(movaccEntry.getCount());

edasclmeanEntry = jUnisens.getEntry('edasclmean.bin');
edasclmeanData = edasclmeanEntry.readScaled(edasclmeanEntry.getCount());






% Get sample rate
SReda = edaEntry.getSampleRate(); 
SRacc = accEntry.getSampleRate();
SRmovacc = movaccEntry.getSampleRate();
SRedasclmean = edasclmeanEntry.getSampleRate();

%Time

TimeStart = unisens_get_timestampstart(path);

k=1:size(edaData,1);
TimeEda = k/SReda;

k=1:size(accData,1);
TimeAcc = k/SRacc;

k=1:size(movaccData,1);
TimeMovAcc = k/SRmovacc;

k=1:size(edasclmeanData,1);
TimeEdasclmean = k/SRedasclmean;

%export
cd(path);

EDA = [];
EDA(:,1) = TimeEda;
EDA(:,2) = edaData;
csvwrite('EDA.csv',EDA);

Acc = [];
Acc(:,1) = TimeAcc;
Acc(:,2) = accData(:,1);
Acc(:,3) = accData(:,2);
Acc(:,4) = accData(:,3);
csvwrite('Acc.csv',Acc);

EDASCLMEAN = [];
EDASCLMEAN(:,1) = TimeEdasclmean;
EDASCLMEAN(:,2,3,4) = edasclmeanData;
csvwrite('EDASCLMEAN.csv',EDASCLMEAN);

movementAcceleration = [];
movementAcceleration(:,1) = TimeMovAcc;
movementAcceleration(:,2) = movaccData;
csvwrite('movementAcceleration.csv',movementAcceleration);

