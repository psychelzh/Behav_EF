
clear
import utils.preproc
import utils.stopSignal
DATAFOLDER = 'EFMerge';
RESFOLDER = 'EFRes';
KEYMETAVAR = {'id', 'time'};
ANADATAVAR = {'RT', 'ACC', 'IsStop', 'SSD', 'SSDCat'};

data = readtable(fullfile(DATAFOLDER, 'StopSignal.csv'));
% calculate the accuracy type of each trial
data.ACC = zeros(height(data), 1);
data.ACC((data.IsStop == 1 & data.SSDNext == 1) | ...
    (data.IsStop == 0 & ...
    ((data.STIM == 0 & data.Resp == 70) | (data.STIM == 1 & data.Resp == 74)))) = 1;
data.ACC(data.IsStop == 0 & data.Resp == 0) = -1;
% modify unit of reaction time
data.RT = data.RT * 1000;
results = preproc(data, @stopSignal, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results, fullfile(RESFOLDER, 'StopSignalResult.csv'))
