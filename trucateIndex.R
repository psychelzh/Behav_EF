# load packages ----
library(tidyverse)
library(readxl)

# user defined functions ----
PE_keep_idx <- function(PE, N, p = 0.5){
  mu <- p
  sigma <- sqrt(p * (1 - p) / N)
  PE < 1 - (mu + qnorm(0.95) * sigma)
}
rm_dup_id <- function(tbl, var_crit){
  tbl |>
    group_by(id) |>
    filter(row_number({{ var_crit }}) == 1) |>
    ungroup()
}
truncate_extremum <- function(data, var, coef = 1.5) {
  data |>
    mutate(
      "{{ var }}" := scales::oob_squish(
        {{ var }},
        c(quantile({{ var }}, 0.25) - coef * IQR({{ var }}),
          quantile({{ var }}, 0.75) + coef * IQR({{ var }}))
      )
    )
}

# set some configurations ----
data_dir <- file.path("EFRes")
filt_dir <- file.path("EFFiltered")
rate <- 0.8
data_suffix <- "Result"
filt_suffix <- "Filtered"
file_ext <- ".csv"
indices <- read_csv(file.path("config", "index_map.csv"))
index_map <- setNames(indices$index, indices$Taskname)

# AntiSac ----
taskname <- "AntiSac"
antisac <- read_csv(file.path(data_dir, paste0(taskname, data_suffix, file_ext)))
antisac_filtered <- antisac |>
  # remove subjects without enough responses
  filter(NResp > rate * NTrial) |>
  # remove subjects with too many errors
  filter(PE_keep_idx(PE, NInclude, 1 / 3)) |>
  # remove duplicate id"s
  rm_dup_id(PE)
write_csv(antisac_filtered, file.path(filt_dir, paste0(taskname, filt_suffix, file_ext)))

# CateSwitch ----
taskname <- "CateSwitch"
cateSwitch <- read_csv(file.path(data_dir, paste0(taskname, data_suffix, file_ext)))
cateSwitch_filtered <- cateSwitch |>
  # remove subjects without enough responses
  filter(NInclude > rate * NTrial) |>
  # remove subjects with too many errors
  filter(PE_keep_idx(PE, NInclude)) |>
  # truncate subjects with abnormal switch costs
  truncate_extremum(MRT_diff) |>
  # remove duplicate id"s
  rm_dup_id(PE)
write_csv(cateSwitch_filtered, file.path(filt_dir, paste0(taskname, filt_suffix, file_ext)))

# ShiftColor ----
taskname <- "ShiftColor"
shiftColor <- read_csv(file.path(data_dir, paste0(taskname, data_suffix, file_ext)))
shiftColor_filtered <- shiftColor |>
  # remove subjects without enough responses
  filter(NInclude > rate * NTrial) |>
  # remove subjects with too many errors
  filter(PE_keep_idx(PE, NInclude)) |>
  # truncate subjects with abnormal switch costs
  truncate_extremum(MRT_diff) |>
  # remove duplicate id"s
  rm_dup_id(PE)
write_csv(shiftColor_filtered, file.path(filt_dir, paste0(taskname, filt_suffix, file_ext)))

# ShiftNumber ----
taskname <- "ShiftNumber"
shiftNumber <- read_csv(file.path(data_dir, paste0(taskname, data_suffix, file_ext)))
shiftNumber_filtered <- shiftNumber |>
  # remove subjects without enough responses
  filter(NInclude > rate * NTrial) |>
  # remove subjects with too many errors
  filter(PE_keep_idx(PE, NInclude)) |>
  # remove subjects with abnormal switch costs
  truncate_extremum(MRT_diff) |>
  # remove duplicate id"s
  rm_dup_id(PE)
write_csv(shiftNumber_filtered, file.path(filt_dir, paste0(taskname, filt_suffix, file_ext)))

# spatialWM ----
taskname <- "spatialWM"
spatialWM <- read_csv(file.path(data_dir, paste0(taskname, data_suffix, file_ext)))
spatialWM_filtered <- spatialWM |>
  filter(
    # remove subjects without enough responses
    NResp > rate * NTrial,
    NInclude > rate * NTrial,
    # remove subjects with too many errors
    PE_keep_idx(PE, NInclude)
  ) |>
  # remove subjects with abnormal score
  truncate_extremum(dprime) |>
  # remove duplicate id"s
  rm_dup_id(PE)
write_csv(spatialWM_filtered, file.path(filt_dir, paste0(taskname, filt_suffix, file_ext)))

# StopSignal ----
taskname <- "StopSignal"
stopSignal <- read_csv(file.path(data_dir, paste0(taskname, data_suffix, file_ext)))
stopSignal_filtered <- stopSignal |>
  filter(
    # remove subjects without enough responses
    NResp > rate * NTrial,
    NInclude > rate * NTrial,
    # remove subjects with too many errors
    PE_keep_idx(PE_Go, NInclude),
    # remove subjects with NaN results
    ! is.nan(SSRT),
    # remove subjects with too spread SSDs
    ! SSSD %in% boxplot.stats(SSSD)$out
  ) |>
  # remove subjects with abnormal score
  truncate_extremum(SSRT) |>
  # remove duplicate id"s
  rm_dup_id(PE_Go)
write_csv(stopSignal_filtered, file.path(filt_dir, paste0(taskname, filt_suffix, file_ext)))

# Stroop ----
taskname <- "Stroop"
stroop <- read_csv(file.path(data_dir, paste0(taskname, data_suffix, file_ext)))
stroop_filtered <- stroop |>
  # remove subjects without enough responses
  filter(NInclude > rate * NTrial) |>
  # remove subjects with too many errors
  filter(PE_keep_idx(PE, NInclude, 1 / 4)) |>
  # remove NaN result
  filter(!is.na(MRT_diff)) |>
  # remove subjects with abnormal score
  truncate_extremum(MRT_diff) |>
  # remove duplicate id"s
  rm_dup_id(PE)
write_csv(stroop_filtered, file.path(filt_dir, paste0(taskname, filt_suffix, file_ext)))

# WM3 ----
taskname <- "WM3"
WM3 <- read_csv(file.path(data_dir, paste0(taskname, data_suffix, file_ext)))
WM3_filtered <- WM3 |>
  filter(
    # remove subjects without enough responses
    NResp > rate * NTrial,
    NInclude > rate * NTrial,
    # remove subjects with too many errors
    PE_keep_idx(PE, NInclude)
  ) |>
  # remove subjects with abnormal score
  truncate_extremum(dprime) |>
  # remove duplicate id"s
  rm_dup_id(PE)
write_csv(WM3_filtered, file.path(filt_dir, paste0(taskname, filt_suffix, file_ext)))

# Keep track ----
taskname <- "KeepTrack"
keepTrack <- read_excel(file.path(data_dir, "KeepTrack.xlsx"))
keepTrack_filtered <- keepTrack |>
  filter(
    # remove subjects with NA results
    ! is.na(score)
  ) |>
  # remove subjects with abnormal score
  truncate_extremum(score) |>
  rename(id = ID)
write_csv(keepTrack_filtered, file.path(filt_dir, paste0(taskname, filt_suffix, file_ext)))

# merge datasets ----
data_merged <- fs::dir_ls(filt_dir, regexp = "Filtered.csv") |>
  imap(
    ~ {
      taskname <- str_extract(.y, "(?<=/).+(?=Filtered)")
      index <- index_map[taskname]
      read_csv(.x, show_col_types = FALSE) |>
        select(
          id,
          "{taskname}" := .data[[index]]
        )
    }
  ) |>
  reduce(full_join, by = "id")
write_csv(data_merged, file.path(filt_dir, "ef_behav_all.csv"))
