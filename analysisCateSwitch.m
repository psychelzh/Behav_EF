clear
import utils.preproc
import utils.sngprocControl
DATAFOLDER = 'EFMerge';
RESFOLDER = 'EFRes';
KEYMETAVAR = {'id', 'time'};
ANADATAVAR = {'condition', 'RT', 'Score'};

data = readtable(fullfile(DATAFOLDER, 'CateSwitch.csv'));
data(data.tskSwitch == 0, :) = [];
stimMap = containers.Map(1:2, {'Repeat', 'Switch'});
data.condition = values(stimMap, num2cell(data.tskSwitch));
data.Score(data.RT == 0) = -1;
data.RT = data.RT * 1000;
results = preproc(data, @sngprocControl, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results, fullfile(RESFOLDER, 'CateSwitchResult.csv'))
results_odd = preproc(data(1:2:end, :), @sngprocControl, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_odd, fullfile(RESFOLDER, 'CateSwitchResultOdd.csv'))
results_even = preproc(data(2:2:end, :), @sngprocControl, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_even, fullfile(RESFOLDER, 'CateSwitchResultEven.csv'))
