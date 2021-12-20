function [stats, labels] = wm(ismatch, acc, rt)

NTrial = length(ismatch);
NResp = sum(acc ~= -1);
% set rt of no response trials as NaN
rt(rt == 0) = nan;
% remove too-quick trials
acc(utils.outlier(rt, 'Method', 'cutoff', 'Boundary', [0.1, inf])) = nan;
NInclude = sum(~isnan(acc));
acc(acc == -1) = 0;
PE = 1 - mean(acc, 'omitnan');
MRT = mean(rt(acc == 1));
IES = MRT / (1 - PE);
hitRate = mean(acc(ismatch == 1), 'omitnan');
FARate = 1 - mean(acc(ismatch == 0), 'omitnan');
[dprime, c] = utils.sdt(hitRate, FARate);
stats = [NTrial, NResp, NInclude, PE, MRT, IES, hitRate, FARate, dprime, c];
labels = {'NTrial', 'NResp', 'NInclude', 'PE', 'MRT', 'IES', 'hitRate', 'FARate', 'dprime', 'c'};

end