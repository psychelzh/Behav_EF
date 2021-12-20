function [stats, labels] = antisac(rt, acc)

NTrial = length(acc);
NResp = sum(rt ~= 0);
% set rt of no response trials as NaN
rt(rt == 0) = nan;
% remove too-quick trials
acc(utils.outlier(rt, 'Method', 'cutoff', 'Boundary', [0.1, inf])) = nan;
NInclude = sum(~isnan(acc));
MRT = mean(rt(acc == 1));
PE = 1 - mean(acc, 'omitnan');
stats = [NTrial, NResp, NInclude, MRT, PE];
labels = {'NTrial', 'NResp', 'NInclude', 'MRT', 'PE'};

end