%%This program is aimed at extracting data from 2 sets (initially for the
%%artifact experiment so left and right hands) to matlab variables in order
%%to be imported in Viz2SetsArtifExp.m

clear all;
close all;

path = uigetdir; %here you select the folder which contains the two sets retrieved from edamove


path1 = [path '\LEFT HAND NOT MOVING']; %feel free to adapt if the subfolders are named differently
path2 = [path '\RIGHT HAND MOVING'];

%Creation of the unisens objects
jUnisensFactory = org.unisens.UnisensFactoryBuilder.createFactory();
jUnisens1 = jUnisensFactory.createUnisens(path1);
jUnisens2 = jUnisensFactory.createUnisens(path2);

% Read binary files
edaEntry1 = jUnisens1.getEntry('eda.bin');
edaData1 = edaEntry1.readScaled(edaEntry1.getCount()); 
edaData1(1:10) = 0; %removing the spike from first values in the EDA signal (sensor activation)

edaEntry2 = jUnisens2.getEntry('eda.bin');
edaData2 = edaEntry2.readScaled(edaEntry2.getCount()); 
edaData2(1:10) = 0;

%get the sample rates
SReda1 = edaEntry1.getSampleRate(); 
SReda2 = edaEntry2.getSampleRate();

%Timestamp array creation
TimeStart1 = unisens_get_timestampstart(path1);
TimeStart2 = unisens_get_timestampstart(path2);

k=1:size(edaData1,1);
TimeStampEDA1 = datetime(TimeStart1) + (k-1)*seconds(1/SReda1);
k=1:size(edaData2,1);
TimeStampEDA2 = datetime(TimeStart2) + (k-1)*seconds(1/SReda2);

k=1:size(edaData1,1);
TimeEda1 = k/SReda1;
TimeEda1 = TimeEda1';

k=1:size(edaData2,1);
TimeEda2 = k/SReda2;
TimeEda2 = TimeEda2';

%export
cd(path);

save timestampset1.mat TimeStampEDA1;
save edaDataSet1.mat edaData1;

save timestampset2.mat TimeStampEDA2;
save edaDataSet2.mat edaData2;

