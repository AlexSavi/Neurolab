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

edaData = num2cell(edaData);

accEntry = jUnisens.getEntry('acc.bin');
accData = accEntry.readScaled(accEntry.getCount());
accData =num2cell(accData);

movaccEntry = jUnisens.getEntry('movementacceleration.bin');
movaccData = movaccEntry.readScaled(movaccEntry.getCount());
movaccData = num2cell(movaccData);

edasclmeanEntry = jUnisens.getEntry('edasclmean.bin');
edasclmeanData = edasclmeanEntry.readScaled(edasclmeanEntry.getCount());
edasclmeanData = num2cell(edasclmeanData);

chargingEntry = jUnisens.getEntry('charging.bin');
chargingData = chargingEntry.readScaled(chargingEntry.getCount());
chargingData = num2cell(chargingData);

pressEntry = jUnisens.getEntry('press.bin');
pressData = pressEntry.readScaled(pressEntry.getCount());
pressData = num2cell(pressData);

stateofchargeEntry = jUnisens.getEntry('stateofcharge.bin');
stateofchargeData = stateofchargeEntry.readScaled(stateofchargeEntry.getCount());
stateofchargeData = num2cell(stateofchargeData);

stepcountEntry = jUnisens.getEntry('stepcount.bin');
stepcountData = stepcountEntry.readScaled(stepcountEntry.getCount());
stepcountData = num2cell(stepcountData);

tempEntry = jUnisens.getEntry('temp.bin');
tempData = tempEntry.readScaled(tempEntry.getCount());
tempData = num2cell(tempData);

tempmeanEntry = jUnisens.getEntry('tempmean.bin');
tempmeanData = tempmeanEntry.readScaled(tempmeanEntry.getCount());
tempmeanData = num2cell(tempmeanData);





% Get sample rate
SRacc = accEntry.getSampleRate();
SRcharging = chargingEntry.getSampleRate();
SReda = edaEntry.getSampleRate(); 
SRedasclmean = edasclmeanEntry.getSampleRate();
SRmovacc = movaccEntry.getSampleRate();
SRpress = pressEntry.getSampleRate();
SRstateofcharge = stateofchargeEntry.getSampleRate();
SRstepcount = stepcountEntry.getSampleRate();
SRtemp = tempEntry.getSampleRate();
SRtempmean = tempmeanEntry.getSampleRate();


%Time

TimeStart = unisens_get_timestampstart(path);

k=1:size(accData,1);
TimeStampAcc = cellstr(datetime(TimeStart) + (k-1)*seconds(1/SRacc));

k=1:size(chargingData,1);
TimeStampCharging = cellstr(datetime(TimeStart) + (k-1)*seconds(1/SRcharging));

k=1:size(edaData,1);
TimeStampEDA = cellstr(datetime(TimeStart) + (k-1)*seconds(1/SReda));

k=1:size(edasclmeanData,1);
TimeStampEdasclmean = cellstr(datetime(TimeStart) + (k-1)*seconds(1/SRedasclmean));

k=1:size(movaccData,1);
TimeStampMovAcc = cellstr(datetime(TimeStart) + (k-1)*seconds(1/SRmovacc));

k=1:size(pressData,1);
TimeStampPress = cellstr(datetime(TimeStart) + (k-1)*seconds(1/SRpress));

k=1:size(stateofchargeData,1);
TimeStampStateOfCharge = cellstr(datetime(TimeStart) + (k-1)*seconds(1/SRstateofcharge));

k=1:size(stepcountData,1);
TimeStampStepCount = cellstr(datetime(TimeStart) + (k-1)*seconds(1/SRstepcount));

k=1:size(tempData,1);
TimeStampTemp = cellstr(datetime(TimeStart) + (k-1)*seconds(1/SRtemp));

k=1:size(tempmeanData,1);
TimeStampTempMean = cellstr(datetime(TimeStart) + (k-1)*seconds(1/SRtempmean));


%export
cd(path);

Acc = {};
Acc(:,1) = TimeStampAcc;
Acc(:,2) = accData(:,1);
Acc(:,3) = accData(:,2);
Acc(:,4) = accData(:,3);
xlswrite('acc.xlsx',Acc);

Charging = {};
Charging(:,1) = TimeStampCharging;
Charging(:,2) = chargingData;
xlswrite('charging.xlsx',Charging);

EDA = {};
EDA(:,1) = TimeStampEDA;
EDA(:,2) = edaData;
xlswrite('eda.xlsx',EDA);

EDASCLMEAN = {};
EDASCLMEAN(:,1) = TimeStampEdasclmean;
EDASCLMEAN(:,2) = edasclmeanData;
xlswrite('edasclmean.xlsx',EDASCLMEAN);

movementAcceleration = {};
movementAcceleration(:,1) = TimeStampMovAcc;
movementAcceleration(:,2) = movaccData;
xlswrite('movementacceleration.xlsx',movementAcceleration);

Press = {};
Press(:,1) = TimeStampPress;
Press(:,2) = pressData;
xlswrite('press.xlsx',Press);

StateOfCharge = {};
StateOfCharge(:,1) = TimeStampStateOfCharge;
StateOfCharge(:,2) = stateofchargeData;
xlswrite('stateofcharge.xlsx',StateOfCharge);

StepCount = {};
StepCount(:,1) = TimeStampStepCount;
StepCount(:,2) = stepcountData;
xlswrite('stepcount.xlsx',StepCount);

Temp = {};
Temp(:,1) = TimeStampTemp;
Temp(:,2) = tempData;
xlswrite('temp.xlsx',Temp);

TempMean = {};
TempMean(:,1) = TimeStampTempMean;
TempMean(:,2) = tempmeanData;
xlswrite('tempmean.xlsx',TempMean);