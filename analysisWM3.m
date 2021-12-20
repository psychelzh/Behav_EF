
clear
import utils.preproc
import utils.wm
DATAFOLDER = 'EFMerge';
RESFOLDER = 'EFRes';
KEYMETAVAR = {'id', 'time'};
ANADATAVAR = {'ismatch', 'ACC', 'RT'};

data = readtable(fullfile(DATAFOLDER, 'WM3.csv'));
results = preproc(data, @wm, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results, fullfile(RESFOLDER, 'WM3Result.csv'))
results_odd = preproc(data(1:2:end, :), @wm, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_odd, fullfile(RESFOLDER, 'WM3ResultOdd.csv'))
results_even = preproc(data(2:2:end, :), @wm, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_even, fullfile(RESFOLDER, 'WM3ResultEven.csv'))


