
clear
import utils.preproc
import utils.spatial
DATAFOLDER = 'EFMerge';
RESFOLDER = 'EFRes';
KEYMETAVAR = {'id', 'time'};
ANADATAVAR = {'flashLoc', 'respCorrect', 'RT'};

data = readtable(fullfile(DATAFOLDER, 'spatialWM.csv'));
results = preproc(data, @spatial, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results, fullfile(RESFOLDER, 'SpatialWMResult.csv'))
results_odd = preproc(data(1:2:end, :), @spatial, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_odd, fullfile(RESFOLDER, 'SpatialWMResultOdd.csv'))
results_even = preproc(data(2:2:end, :), @spatial, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_even, fullfile(RESFOLDER, 'SpatialWMResultEven.csv'))
