function [stats, labels] = stopSignal(RT, ACC, IsStop, SSD, SSDCat)
% By Zhang, Liang. 04/13/2016. E-mail:psychelzh@gmail.com

% calculate percentile rt based on https://elifesciences.org/articles/46323
p_resp_signal = mean(ACC(IsStop == 1) == 0);
RT(ACC == -1) = 1000; % use maximal rt for no response trials
RT_go = RT(~IsStop);
rt_nth = quantile(RT_go, p_resp_signal);

% record trial information
NTrial = length(RT);
NResp = sum(ACC ~= -1);
% remove RT's with no response
RT(ACC == -1) = NaN;
% remove RT outlier
RT(~IsStop) = utils.rmoutlier(RT(~IsStop));
ACC(isnan(RT)) = nan;
NInclude = sum(~isnan(ACC));
% mean reaction time and proportion of error for Go and Stop condition
MRT_Go = mean(RT(ACC == 1 & IsStop == 0));
MRT_Stop = mean(RT(ACC == 0 & IsStop == 1));
PE_Go = 1 - mean(ACC(IsStop == 0), 'omitnan');
PE_Stop = 1 - mean(ACC(IsStop == 1));
% mark out those ssd categories with negative ssd
ssdcats = 1:4;
ssdnormal = arrayfun(@(ssdcat) ...
    ~any(SSD(IsStop == 1 & SSDCat == ssdcat) <= 0), ...
    ssdcats);
% mean SSD
MSSDMat = arrayfun(@(ssdcat) mean( ...
    [findpeaks(SSD(IsStop == 1 & SSDCat == ssdcat)); ...
    -findpeaks(-SSD(IsStop == 1 & SSDCat == ssdcat))]), ...
    ssdcats);
SSSD = std(MSSDMat(ssdnormal ~= 0), 'omitnan');
MSSD = mean(MSSDMat(ssdnormal ~= 0), 'omitnan');
SSRT = rt_nth - MSSD;

stats = [SSRT, rt_nth, MSSD, NTrial, NResp, NInclude, MRT_Go, MRT_Stop, PE_Go, PE_Stop, SSSD, MSSDMat, ssdnormal];
labels = {'SSRT', 'rt_nth', 'MSSD', 'NTrial', 'NResp', 'NInclude', 'MRT_Go', 'MRT_Stop', 'PE_Go', 'PE_Stop', 'SSSD', 'MSSD1', 'MSSD2', 'MSSD3', 'MSSD4', 'SSSD1', 'SSSD2', 'SSSD3', 'SSSD4'};
end
