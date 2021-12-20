function [stats, labels] = spatial(loc, acc, rt)

NTrial = length(loc);
NResp = sum(~isnan(acc));
acc(isnan(acc)) = 0;
% remove too-quick trials
acc(utils.outlier(rt, 'Method', 'cutoff', 'Boundary', [0.1, inf])) = nan;
NInclude = sum(~isnan(acc));
PE = 1 - mean(acc, 'omitnan');
MRT = mean(rt(acc == 1));
IES = MRT / (1 - PE);
cond = categorical((loc - circshift(loc, 2)) == 0, [false, true], {'Change', 'Stay'});
hitRate = mean(acc(cond == 'Stay'), 'omitnan');
FARate = 1 - mean(acc(cond == 'Change'), 'omitnan');
[dprime, c] = utils.sdt(hitRate, FARate);
stats = [NTrial, NResp, NInclude, PE, MRT, IES, hitRate, FARate, dprime, c];
labels = {'NTrial', 'NResp', 'NInclude', 'PE', 'MRT', 'IES', 'hitRate', 'FARate', 'dprime', 'c'};

end
