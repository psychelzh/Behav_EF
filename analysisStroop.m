
clear
import utils.preproc
import utils.sngprocControl
DATAFOLDER = 'EFMerge';
RESFOLDER = 'EFRes';
KEYMETAVAR = {'id', 'time'};
ANADATAVAR = {'condition', 'RT', 'KeyResponse'};

data = readtable(fullfile(DATAFOLDER, 'Stroop.csv'));
data(isnan(data.id), :) = [];
data.condition = categorical ((strncmp (data.Material, 'r', 1)) & (data.Color == 32418) | ...
    (strncmp (data.Material, 'g', 1)) & (data.Color == 32511) | ...
    (strncmp (data.Material, 'b', 1)) & (data.Color == 34013) | ...
    (strncmp (data.Material, 'y', 1)) & (data.Color == 40644) == 1, [true, false], {'Cong', 'Incong'});
data.RT = data.RT * 1000;
results = preproc(data, @sngprocControl, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results, fullfile(RESFOLDER, 'StroopResult.csv'))
results_odd = preproc(data(1:2:end, :), @sngprocControl, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_odd, fullfile(RESFOLDER, 'StroopResultOdd.csv'))
results_even = preproc(data(2:2:end, :), @sngprocControl, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_even, fullfile(RESFOLDER, 'StroopResultEven.csv'))
