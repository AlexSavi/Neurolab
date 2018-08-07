clear all;
close all;

tic

path1='C:\Users\Alex\Documents\TPS 2A\Stage 2A\TNO\cleaning signal\stimuli\Marc 05-8-18\2018-08-05 15.30.01 MARC  LEFT PALM NOT MOVING ARTIFACT EXP';
path2='C:\Users\Alex\Documents\TPS 2A\Stage 2A\TNO\cleaning signal\stimuli\Marc 05-8-18\2018-08-05 15.30.01 MARC RIGHT PALM MOVING ARTIFACT EXP';

jUnisensFactory = org.unisens.UnisensFactoryBuilder.createFactory();
jUnisens1 = jUnisensFactory.createUnisens(path1);
jUnisens2 = jUnisensFactory.createUnisens(path2);

% Read a binary file
edaEntry1 = jUnisens1.getEntry('eda.bin');
edaData1 = edaEntry1.readScaled(edaEntry1.getCount()); 

accEntry1 = jUnisens1.getEntry('acc.bin');
accData1 = accEntry1.readScaled(accEntry1.getCount());

edaEntry2 = jUnisens2.getEntry('eda.bin');
edaData2 = edaEntry2.readScaled(edaEntry2.getCount()); 

accEntry2 = jUnisens2.getEntry('acc.bin');
accData2 = accEntry2.readScaled(accEntry2.getCount());



% Get sample rate
SReda1 = edaEntry1.getSampleRate(); 
SRacc1 = accEntry1.getSampleRate();

SReda2 = edaEntry2.getSampleRate();
SRacc2 = accEntry2.getSampleRate();

TimeStart1 = unisens_get_timestampstart(path1);
TimeStart2 = unisens_get_timestampstart(path2);

TimeStampEDA1 = NaT(1,length(edaData1));
TimeStampAcc1 = NaT(1,length(accData1));

TimeStampEDA2 = NaT(1,length(edaData2));
TimeStampAcc2 = NaT(1,length(accData2));

k=1:size(edaData1,1);
TimeStampEDA1 = datetime(TimeStart1) + (k-1)*seconds(1/SReda1);
k=1:size(accData1,1);
TimeStampAcc1 = datetime(TimeStart1) + (k-1)*seconds(1/SRacc1);

k=1:size(edaData2,1);
TimeStampEDA2 = datetime(TimeStart2) + (k-1)*seconds(1/SReda2);
k=1:size(accData2,1);
TimeStampAcc2 = datetime(TimeStart2) + (k-1)*seconds(1/SRacc2);

k=1:size(edaData1,1);
TimeEda1 = k/SReda1;
TimeEda1 = TimeEda1';

k=1:size(edaData2,1);
TimeEda2 = k/SReda2;
TimeEda2 = TimeEda2';

plot(TimeStampEDA1,edaData1);
hold on;
plot(TimeStampEDA2,edaData2);
ylim([0 6*max(mean(edaData1),mean(edaData1))]);
xlim([datetime(min(TimeStart1,TimeStart2))- minutes(5),datetime(max(TimeStampEDA1(length(TimeStampEDA1)),TimeStampEDA2(length(TimeStampEDA2))))+minutes(5)]);
title("Comparing 2 EDA sigals");
ylabel("EDA in µS");
legend('Left palm sensor ','Right palm sensor ');

toc