# please set working directory as the directory of this file.

# load packages ----
library(tidyverse)

# user defined functions ----
PE_keep_idx <- function(PE, N, p = 0.5){
  mu <- p
  sigma <- sqrt(p * (1 - p) / N)
  PE < 1 - (mu + qnorm(0.95) * sigma)
}

# set some configurations ----
data_dir <- "EFMerge"
rate <- 0.8

# AntiSac ----
antisac <- read_csv(file.path(data_dir, "AntiSacResult.csv"))
antisac_filtered <- antisac %>% 
  # remove subjects without enough responses
  filter(NResp > rate * NTrial) %>% 
  # remove subjects with too many errors
  filter(PE_keep_idx(PE, NInclude, 1 / 3)) %>% 
  # remove duplicate id's
  group_by(id) %>% 
  mutate(ranking = row_number(PE)) %>% 
  ungroup() %>% 
  filter(ranking == 1) %>% 
  select(-ranking)
write_csv(antisac_filtered, file.path(data_dir, "AntiSacFiltered.csv"))

# CateSwitch ----
cateswitch <- read_csv(file.path(data_dir, "CateSwitchResult.csv"))
cateswitch_filtered <- cateswitch %>% 
  # remove subjects without enough responses
  filter(NResp > rate * NTrial) %>% 
  # remove subjects with too many errors
  filter(PE_keep_idx(PE, NInclude)) %>% 
  # remove subjects with outlier response time of difference
    # get the first quantile and the third quantile
  Q = quantile(MRT_diff, c(0.25, 0.75)) %>%
    # interquantile range
  IQR = Q(2) - Q(1) %>%
  filter((MRT_diff > Q(1) - 1.5 * IQR)) & (MRT_diff < (Q(2) + 1.5 * IQR)) %>%
  # remove duplicate id's
  group_by(id) %>% 
  mutate(ranking = row_number(PE)) %>% 
  ungroup() %>% 
  filter(ranking == 1) %>% 
  select(-ranking)
write_csv(cateswitch_filtered, file.path(data_dir, "CateSwitchFiltered.csv"))

# shiftcolor ----
shiftcolor <- read_csv(file.path(data_dir, "ShiftColorResult.csv"))
shiftcolor_filtered <- shiftcolor %>% 
  # remove subjects without enough responses
  filter(NResp > rate * NTrial) %>% 
  # remove subjects with too many errors
  filter(PE_keep_idx(PE, NInclude)) %>% 
  # remove subjects with outlier response time of difference
    # get the first quantile and the third quantile
  Q = quantile(MRT_diff, c(0.25, 0.75)) %>%
    # interquantile range
  IQR = Q(2) - Q(1) %>%
  filter((MRT_diff > Q(1) - 1.5 * IQR)) & (MRT_diff < (Q(2) + 1.5 * IQR)) %>% 
  # remove duplicate id's
  group_by(id) %>% 
  mutate(ranking = row_number(PE)) %>% 
  ungroup() %>% 
  filter(ranking == 1) %>% 
  select(-ranking)
write_csv(shiftcolor_filtered, file.path(data_dir, "ShiftColorFiltered.csv"))

# shiftnumber ----
shiftnumber <- read_csv(file.path(data_dir, "ShiftNumberResult.csv"))
shiftnumber_filtered <- shiftnumber %>% 
  # remove subjects without enough responses
  filter(NResp > rate * NTrial) %>% 
  # remove subjects with too many errors
  filter(PE_keep_idx(PE, NInclude)) %>%
  # remove subjects with outlier response time of difference
    # get the first quantile and the third quantile
  Q = quantile(MRT_diff, c(0.25, 0.75)) %>%
    # interquantile range
  IQR = Q(2) - Q(1) %>%
  filter((MRT_diff > Q(1) - 1.5 * IQR)) & (MRT_diff < (Q(2) + 1.5 * IQR)) %>% 
  # remove duplicate id's
  group_by(id) %>% 
  mutate(ranking = row_number(PE)) %>% 
  ungroup() %>% 
  filter(ranking == 1) %>% 
  select(-ranking)
write_csv(shiftnumber_filtered, file.path(data_dir, "ShiftNumberFiltered.csv"))

# spatial ----
spatial <- read_csv(file.path(data_dir, "SpatialWMResult.csv"))
spatial_filtered <- spatial %>% 
  # remove subjects without enough responses
  filter(NResp > rate * NTrial) %>% 
  # remove subjects with outlier dprime
  filter(dprime > 0) %>%
    # get the first quantile and the third quantile
  Q = quantile(dprime, c(0.25, 0.75)) %>%
    # interquantile range
  IQR = Q(2) - Q(1) %>%
  filter((dmrime > Q(1) - 1.5 * IQR)) & (dprime < (Q(2) + 1.5 * IQR)) %>%
  # remove duplicate id's
  group_by(id) %>% 
  mutate(ranking = row_number(dprime)) %>% 
  ungroup() %>% 
  filter(ranking == 2) %>% 
  select(-ranking)
write_csv(spatial_filtered, file.path(data_dir, "SpatialFiltered.csv"))

# stopsignal ----
stopsignal <- read_csv(file.path(data_dir, "StopSignalResult.csv"))
stopsignal_filtered <- stopsignal %>% 
  # remove subjects without enough responses
  filter(NResp > rate * NTrial) %>% 
  # remove subjects with outlier SSSD
    # get the first quantile and the third quantile
  Q = quantile(SSSD, c(0.25, 0.75)) %>%
    # interquantile range
  IQR = Q(2) - Q(1) %>%
  filter((SSSD > Q(1) - 1.5 * IQR)) & (SSSD < (Q(2) + 1.5 * IQR)) %>% 
  # remove duplicate id's
  group_by(id) %>% 
  mutate(ranking = row_number(SSSD)) %>% 
  ungroup() %>% 
  filter(ranking == 1) %>% 
  select(-ranking)
write_csv(stopsignal_filtered, file.path(data_dir, "StopSignalFiltered.csv"))

# stroop ----
stroop <- read_csv(file.path(data_dir, "StroopResult.csv"))
stroop_filtered <- stroop %>% 
  # remove subjects without enough responses
  filter(NResp > rate * NTrial) %>% 
  # remove subjects with too many errors
  filter(PE_keep_idx(PE, NInclude, 1 / 4)) %>% 
  # remove subjects with outlier response time of difference
    # get the first quantile and the third quantile
  Q = quantile(MRT_diff, c(0.25, 0.75)) %>%
    # interquantile range
  IQR = Q(2) - Q(1) %>%
  filter((MRT_diff > Q(1) - 1.5 * IQR)) & (MRT_diff < (Q(2) + 1.5 * IQR)) %>%   
  # remove duplicate id's
  group_by(id) %>% 
  mutate(ranking = row_number(PE)) %>% 
  ungroup() %>% 
  filter(ranking == 1) %>% 
  select(-ranking)
write_csv(stroop_filtered, file.path(data_dir, "StroopFiltered.csv"))

# WM ----
WM <- read_csv(file.path(data_dir, "WM3Result.csv"))
WM_filtered <- stroop %>% 
  # remove subjects without enough responses
  filter(NResp > rate * NTrial) %>% 
  # remove subjects with outlier dprime
  filter(dprime > 0) %>%
    # get the first quantile and the third quantile
  Q = quantile(dprime, c(0.25, 0.75)) %>%
    # interquantile range
  IQR = Q(2) - Q(1) %>%
  filter((dmrime > Q(1) - 1.5 * IQR)) & (dprime < (Q(2) + 1.5 * IQR)) %>%
  # remove duplicate id's
  group_by(id) %>% 
  mutate(ranking = row_number(dprime)) %>% 
  ungroup() %>% 
  filter(ranking == 2) %>% 
  select(-ranking)
write_csv(WM_filtered, file.path(data_dir, "WM3Filtered.csv"))
