%% AntiSac
% merge data
% clear variables in case of incompatibilities
clear

% directory of spatial working memory data
ANTISAC_DIR = 'AntiSac';
MRGDAT_DIR = 'EFMerge';

% get the files information
antisacfiles = dir(fullfile(ANTISAC_DIR, 'AntiSac_sub*.mat'));

% load and merge files
% use a table `mrgdata` to store all the data
mrgdata = table;
for ifile = 1:length(antisacfiles)
    % get data file name
    filename = antisacfiles(ifile).name;
    % extract subject id and participate date and time
    sid = str2double(regexp(filename, '(?<=sub)\d+', 'once', 'match'));
    sdate = datetime(regexp(filename, '\d{2}-[A-Za-z]{3}_\d{2}-\d{2}', 'once', 'match'), ...
        'InputFormat', 'dd-MMM_HH-mm', 'Locale', 'en_US');
    % load data
    load(fullfile(ANTISAC_DIR, filename))
    % get number the trials and recorded variables
    [ntrial, nvar] = size(Seq);
    % check whether the data is correctly recorded
    if nvar ~= 8
        warning('SCRIPT:DATAINVALID', 'Invalid data for subject: %d.', sid)
        continue
    end
    % form a table to store the subject info and experiment data
    SeqTrans = table;
    SeqTrans.id = repmat(sid, ntrial, 1);
    SeqTrans.time = repmat(sdate, ntrial, 1);
    varnames = {'iTrial', 'targetLoc', 'targetDir', 'fixationDur', 'keySelect', 'RT', 'Score', 'OnsetTime'};
    SeqTrans = [SeqTrans, array2table(Seq, 'VariableNames', varnames)]; %#ok<AGROW>
    % merge current subject data to the total data set
    mrgdata = [mrgdata; SeqTrans]; %#ok<AGROW>
end

% write out data.
if ~exist(MRGDAT_DIR, 'dir'), mkdir(MRGDAT_DIR); end
writetable(mrgdata, fullfile(MRGDAT_DIR, 'AntiSac.csv'))

% calculate indices
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

%% CateSwitch
% merge data
% clear variables in case of incompatibilities
clear

% directory of spatial working memory data
CATESWI_DIR = 'CateSwitch';
MRGDAT_DIR = 'EFMerge';

% get the files information
cateswifiles = dir(fullfile(CATESWI_DIR, 'CateSwitch_Sub*.mat'));

% load and merge files
% use a table `mrgdata` to store all the data
mrgdata = table;
for ifile = 1:length(cateswifiles)
    % get data file name
    filename = cateswifiles(ifile).name;
    % extract subject id and participate date and time
    sid = str2double(regexp(filename, '(?<=Sub)\d+', 'once', 'match'));
    sdate = datetime(regexp(filename, '\d{2}-[A-Za-z]{3}-\d{4}_\d{2}-\d{2}', 'once', 'match'), ...
        'InputFormat', 'dd-MMM-yyyy_HH-mm', 'Locale', 'en_US');
    % load data
    load(fullfile(CATESWI_DIR, filename))
    % get number the trials and recorded variables
    [ntrial, nvar] = size(SM);
    % check whether the data is correctly recorded
    if nvar ~= 13
        warning('SCRIPT:DATAINVALID', 'Invalid data for subject: %d.', sid)
        continue
    end
    % form a table to store the subject info and experiment data
    SMTrans = table;
    SMTrans.id = repmat(sid, ntrial, 1);
    SMTrans.time = repmat(sdate, ntrial, 1);
    varnames = {'iTrial', 'iMaterial', 'task', 'semL', 'semS', 'respCorrect', 'keySelect', 'Score', 'RT', 'DonsetTime', 'AonsetTime', 'tskSwitch', 'respSwitch'};
    SMTrans = [SMTrans, array2table(SM, 'VariableNames', varnames)]; %#ok<AGROW>
    % merge current subject data to the total data set
    mrgdata = [mrgdata; SMTrans]; %#ok<AGROW>
end

% write out data.
if ~exist(MRGDAT_DIR, 'dir'), mkdir(MRGDAT_DIR); end
writetable(mrgdata, fullfile(MRGDAT_DIR, 'CateSwitch.csv'))

% calculate indices
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

%% ShiftingColor
% merge data
% clear variables in case of incompatibilities
clear

% directory of spatial working memory data
SHIFTCOL_DIR = 'ShiftingColor';
MRGDAT_DIR = 'EFMerge';

% get the files information
shiftcolfiles = dir(fullfile(SHIFTCOL_DIR, 'ShiftingColor_Sub*.mat'));

% load and merge files
% use a table `mrgdata` to store all the data
mrgdata = table;
for ifile = 1:length(shiftcolfiles)
    % get data file name
    filename = shiftcolfiles(ifile).name;
    % extract subject id and participate date and time
    sid = str2double(regexp(filename, '(?<=Sub)\d+', 'once', 'match'));
    sdate = datetime(regexp(filename, '\d{2}-[A-Za-z]{3}-\d{4}_\d{2}-\d{2}', 'once', 'match'), ...
        'InputFormat', 'dd-MMM-yyyy_HH-mm', 'Locale', 'en_US');
    % load data
    load(fullfile(SHIFTCOL_DIR, filename))
    % get number the trials and recorded variables
    [ntrial, nvar] = size(rec);
    % check whether the data is correctly recorded
    if nvar ~= 8
        warning('SCRIPT:DATAINVALID', 'Invalid data for subject: %d.', sid)
        continue
    end
    % form a table to store the subject info and experiment data
    recTrans = table;
    recTrans.id = repmat(sid, ntrial, 1);
    recTrans.time = repmat(sdate, ntrial, 1);
    varnames = {'iTrial', 'shape', 'color', 'task', 'keepsameasnumber', 'keyPressed', 'respCorrect', 'RT'};
    recTrans = [recTrans, array2table(rec, 'VariableNames', varnames)]; %#ok<AGROW>
    % merge current subject data to the total data set
    mrgdata = [mrgdata; recTrans]; %#ok<AGROW>
end

% write out data.
if ~exist(MRGDAT_DIR, 'dir'), mkdir(MRGDAT_DIR); end
writetable(mrgdata, fullfile(MRGDAT_DIR, 'ShiftColor.csv'))

% calculate indices
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

%% ShiftingNumber
% merge data
% clear variables in case of incompatibilities
clear

% directory of spatial working memory data
SHIFTNUM_DIR = 'ShiftNumber';
MRGDAT_DIR = 'EFMerge';

% get the files information
shiftnumfiles = dir(fullfile(SHIFTNUM_DIR, 'ShiftNumber_Sub*.mat'));

% load and merge files
% use a table `mrgdata` to store all the data
mrgdata = table;
for ifile = 1:length(shiftnumfiles)
    % get data file name
    filename = shiftnumfiles(ifile).name;
    % extract subject id and participate date and time
    sid = str2double(regexp(filename, '(?<=Sub)\d+', 'once', 'match'));
    sdate = datetime(regexp(filename, '\d{2}-[A-Za-z]{3}-\d{4}_\d{2}_\d{2}', 'once', 'match'), ...
        'InputFormat', 'dd-MMM-yyyy_HH_mm', 'Locale', 'en_US');
    % load data
    load(fullfile(SHIFTNUM_DIR, filename))
    % get number the trials and recorded variables
    [ntrial, nvar] = size(rec);
    % check whether the data is correctly recorded
    if nvar ~= 8
        warning('SCRIPT:DATAINVALID', 'Invalid data for subject: %d.', sid)
        continue
    end
    % form a table to store the subject info and experiment data
    recTrans = table;
    recTrans.id = repmat(sid, ntrial, 1);
    recTrans.time = repmat(sdate, ntrial, 1);
    varnames = {'iTrial', 'number', 'letter', 'task', 'flipLR', 'keyPressed', 'respCorrect', 'RT'};
    recTrans = [recTrans, array2table(rec, 'VariableNames', varnames)]; %#ok<AGROW>
    % merge current subject data to the total data set
    mrgdata = [mrgdata; recTrans]; %#ok<AGROW>
end

% write out data.
if ~exist(MRGDAT_DIR, 'dir'), mkdir(MRGDAT_DIR); end
writetable(mrgdata, fullfile(MRGDAT_DIR, 'ShiftNumber.csv'))

% calculate indices
clear
import utils.preproc
import utils.sngprocControl
DATAFOLDER = 'EFMerge';
RESFOLDER = 'EFRes';
KEYMETAVAR = {'id', 'time'};
ANADATAVAR = {'condition', 'RT', 'respCorrect'};

data = readtable(fullfile(DATAFOLDER, 'ShiftNumber.csv'));
data(isnan(data.id), :) = [];
data.tskSwitch = abs(data.task - circshift(data.task, 1));
data(data.iTrial == 1, :) = [];
stimMap = containers.Map(0:1, {'Repeat', 'Switch'});
data.condition = values(stimMap, num2cell(data.tskSwitch));
data.RT = data.RT * 1000;
results = preproc(data, @sngprocControl, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results, fullfile(RESFOLDER, 'ShiftNumberResult.csv'))
results_odd = preproc(data(1:2:end, :), @sngprocControl, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_odd, fullfile(RESFOLDER, 'ShiftNumberResultOdd.csv'))
results_even = preproc(data(2:2:end, :), @sngprocControl, Keys = KEYMETAVAR, Vars = ANADATAVAR);
writetable(results_even, fullfile(RESFOLDER, 'ShiftNumberResultEven.csv'))

%% Spatial
% merge data
% clear variables in case of incompatibilities
clear

% directory of spatial working memory data
SPATIAL_DIR = 'spatial';
MRGDAT_DIR = 'EFMerge';

% get the files information
spatialfiles = dir(fullfile(SPATIAL_DIR, 'spatial_2back_Sub*.mat'));

% load and merge files
% use a table `mrgdata` to store all the data
mrgdata = table;
for ifile = 1:length(spatialfiles)
    % get data file name
    filename = spatialfiles(ifile).name;
    % extract subject id and participate date and time
    sid = str2double(regexp(filename, '(?<=Sub)\d+', 'once', 'match'));
    sdate = datetime(regexp(filename, '\d{2}-[A-Za-z]{3}-\d{4}_\d{2}-\d{2}', 'once', 'match'), ...
        'InputFormat', 'dd-MMM-yyyy_HH-mm', 'Locale', 'en_US');
    % load data
    load(fullfile(SPATIAL_DIR, filename))
    % remove the first two trials of each block
    blocks = unique(rec(:, 2));
    subcfg.type = '()';
    subcfg.subs = {[1, 2]};
    rmRows = arrayfun(@(block) subsref(find(rec(:, 2) == block), subcfg), blocks, 'UniformOutput', false);
    rmRows = cat(1, rmRows{:});
    rec(rmRows, :) = []; %#ok<SAGROW>
    % get number the trials and recorded variables
    [ntrial, nvar] = size(rec);
    % check whether the data is correctly recorded
    if nvar ~= 6
        warning('SCRIPT:DATAINVALID', 'Invalid data for subject: %d.', sid)
        continue
    end
    % form a table to store the subject info and experiment data
    recTrans = table;
    recTrans.id = repmat(sid, ntrial, 1);
    recTrans.time = repmat(sdate, ntrial, 1);
    varnames = {'iTrial', 'iBlock', 'flashLoc', 'respCorrect', 'RT', 'OnsetTime'};
    recTrans = [recTrans, array2table(rec, 'VariableNames', varnames)]; %#ok<AGROW>
    % merge current subject data to the total data set
    mrgdata = [mrgdata; recTrans]; %#ok<AGROW>
end

% write out data.
if ~exist(MRGDAT_DIR, 'dir'), mkdir(MRGDAT_DIR); end
writetable(mrgdata, fullfile(MRGDAT_DIR, 'spatialWM.csv'))

% calculate indices
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

%% StopSignal
% merge data
% clear variables in case of incompatibilities
clear

% directory of spatial working memory data
STOPSIG_DIR = 'StopSignal';
MRGDAT_DIR = 'EFMerge';

% get the files information
stopsignalfiles = dir(fullfile(STOPSIG_DIR, 'StopSignal_Sub*.mat'));

% load and merge files
% use a table `mrgdata` to store all the data
mrgdata = table;
for ifile = 1:length(stopsignalfiles)
    % get data file name
    filename = stopsignalfiles(ifile).name;
    % extract subject id and participate date and time
    sid = str2double(regexp(filename, '(?<=Sub)\d+', 'once', 'match'));
    sdate = datetime(regexp(filename, '\d{2}-[A-Za-z]{3}-\d{4}_\d{2}_\d{2}', 'once', 'match'), ...
        'InputFormat', 'dd-MMM-yyyy_HH_mm', 'Locale', 'en_US');
    % load data
    load(fullfile(STOPSIG_DIR, filename))
    % get number the trials and recorded variables
    [ntrial, nvar] = size(Seeker);
    % check whether the data is correctly recorded
    if nvar ~= 10
        warning('SCRIPT:DATAINVALID', 'Invalid data for subject: %d.', sid)
        continue
    end
    % form a table to store the subject info and experiment data
    SeekerTrans = table;
    SeekerTrans.id = repmat(sid, ntrial, 1);
    SeekerTrans.time = repmat(sdate, ntrial, 1);
    varnames = {'iTrial', 'iBlock', 'IsStop', 'STIM', 'SSDCat', 'SSD', 'Resp', 'RT', 'OnsetTime', 'SSDNext'};
    SeekerTrans = [SeekerTrans, array2table(Seeker, 'VariableNames', varnames)]; %#ok<AGROW>
    % merge current subject data to the total data set
    mrgdata = [mrgdata; SeekerTrans]; %#ok<AGROW>
end

% write out data.
if ~exist(MRGDAT_DIR, 'dir'), mkdir(MRGDAT_DIR); end
writetable(mrgdata, fullfile(MRGDAT_DIR, 'StopSignal.csv'))

% calculate indices
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

%% Stroop
% merge data
% clear variables in case of incompatibilities
clear

% directory of spatial working memory data
STROOP_DIR = 'Stroop';
MRGDAT_DIR = 'EFMerge';

% get the files information
stroopfiles = dir(fullfile(STROOP_DIR, 'Stroop_Sub*.mat'));

% load and merge files
% use a table `mrgdata` to store all the data
mrgdata = table;
for ifile = 1:length(stroopfiles)
    % get data file name
    filename = stroopfiles(ifile).name;
    % extract subject id and participate date and time
    sid = str2double(regexp(filename, '(?<=Sub)\d+', 'once', 'match'));
    sdate = datetime(regexp(filename, '\d{2}-[A-Za-z]{3}-\d{4}_\d{2}_\d{2}', 'once', 'match'), ...
        'InputFormat', 'dd-MMM-yyyy_HH_mm', 'Locale', 'en_US');
    % load data
    load(fullfile(STROOP_DIR, filename))
    % get number the trials and recorded variables
    [ntrial, nvar] = size(result);
    % check whether the data is correctly recorded
    if nvar ~= 7
        warning('SCRIPT:DATAINVALID', 'Invalid data for subject: %d.', sid)
        continue
    end
    % form a table to store the subject info and experiment data
    resultTrans = table;
    resultTrans.id = repmat(sid, ntrial, 1);
    resultTrans.time = repmat(sdate, ntrial, 1);
    varnames = {'iBlock', 'iTrial', 'Material', 'Color', 'RT', 'Key', 'KeyResponse'};
    resultTrans = [resultTrans, cell2table(result, 'VariableNames', varnames)]; %#ok<AGROW>
    % merge current subject data to the total data set
    mrgdata = [mrgdata; resultTrans]; %#ok<AGROW>
end

% write out data.
if ~exist(MRGDAT_DIR, 'dir'), mkdir(MRGDAT_DIR); end
writetable(mrgdata, fullfile(MRGDAT_DIR, 'Stroop.csv'))

% calculate indices
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

%% WM3
% merge data
% clear variables in case of incompatibilities
clear

% directory of spatial working memory data
WM_DIR = 'WM';
MRGDAT_DIR = 'EFMerge';

% get the files information
WMfiles = dir(fullfile(WM_DIR, 'WM3_Sub*.mat'));

% load and merge files
% use a table `mrgdata` to store all the data
mrgdata = table;
for ifile = 1:length(WMfiles)
    % get data file name
    filename = WMfiles(ifile).name;
    % extract subject id and participate date and time
    sid = str2double(regexp(filename, '(?<=Sub)\d+', 'once', 'match'));
    sdate = datetime(regexp(filename, '\d{2}-[A-Za-z]{3}-\d{4}_\d{2}_\d{2}', 'once', 'match'), ...
        'InputFormat', 'dd-MMM-yyyy_HH_mm', 'Locale', 'en_US');
    % load data
    load(fullfile(WM_DIR, filename))
    % get number the trials and recorded variables
    [~, nvar] = size(rec);
    varnames = {'iTrial', 'stim', 'ismatch', 'type', 'ACC', 'RT', 'Resp'};
    % check whether the data is correctly recorded
    if nvar ~= 7
        warning('SCRIPT:DATAINVALID', 'Invalid data for subject: %d.', sid)
        continue
    end
    % remove trials of no response required
    rec(ismissing(rec(:, 4)), :) = []; %#ok<*SAGROW>
    % transform multiple response trials
    invalidRows = cellfun(@length, rec(:, 7)) ~= 1;
    rec(invalidRows, 5) = {-1};
    rec(invalidRows, 6) = {0};
    rec(invalidRows, 7) = {''};
    % form a table to store the subject info and experiment data
    recTrans = table;
    recTrans.id = repmat(sid, size(rec, 1), 1);
    recTrans.time = repmat(sdate, size(rec, 1), 1);
    % transform to table for better readability
    recTrans = [recTrans, cell2table(rec, 'VariableNames', varnames)]; %#ok<AGROW>
    % merge current subject data to the total data set
    mrgdata = [mrgdata; recTrans]; %#ok<AGROW>
end

% write out data.
if ~exist(MRGDAT_DIR, 'dir'), mkdir(MRGDAT_DIR); end
writetable(mrgdata, fullfile(MRGDAT_DIR, 'WM3.csv'))

% calculate indices
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
