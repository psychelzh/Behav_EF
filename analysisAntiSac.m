
clear
import utils.preproc
import utils.antisac
DATAFOLDER = 'EFMerge';
RESFOLDER = 'EFRes';
KEYMETAVAR = {'id', 'time'};
ANADATAVAR = {'RT', 'Score'};

data = readtable(fullfile(DATAFOLDER, 'AntiSac.csv'));
results = preproc(data, @antisac, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results, fullfile(RESFOLDER, 'AntiSacResult.csv'))
results_odd = preproc(data(1:2:end, :), @antisac, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_odd, fullfile(RESFOLDER, 'AntiSacResultOdd.csv'))
results_even = preproc(data(2:2:end, :), @antisac, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_even, fullfile(RESFOLDER, 'AntiSacResultEven.csv'))
