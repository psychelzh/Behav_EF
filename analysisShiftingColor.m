clear
import utils.preproc
import utils.sngprocControl
DATAFOLDER = 'EFMerge';
RESFOLDER = 'EFRes';
KEYMETAVAR = {'id', 'time'};
ANADATAVAR = {'condition', 'RT', 'respCorrect'};

data = readtable(fullfile(DATAFOLDER, 'ShiftColor.csv'));
data(isnan(data.id), :) = [];
data.tskSwitch = abs(data.task - circshift(data.task, 1));
data(data.iTrial == 1, :) = [];
stimMap = containers.Map(0:1, {'Repeat', 'Switch'});
data.condition = values(stimMap, num2cell(data.tskSwitch));
data.RT = data.RT * 1000;
results = preproc(data, @sngprocControl, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results, fullfile(RESFOLDER, 'ShiftColorResult.csv'))
results_odd = preproc(data(1:2:end, :), @sngprocControl, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_odd, fullfile(RESFOLDER, 'ShiftColorResultOdd.csv'))
results_even = preproc(data(2:2:end, :), @sngprocControl, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_even, fullfile(RESFOLDER, 'ShiftColorResultEven.csv'))
