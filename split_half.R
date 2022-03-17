box::use(
  dplyr[...],
  tidyr[...],
  purrr[...],
  stringr[...]
)
index_map <- readr::read_csv("config/index_map.csv", show_col_types = FALSE) |>
  tibble::deframe()
expand_grid(
  task = names(index_map),
  half = c("Even", "Odd")
) |>
  mutate(
    file_data = map2(
      task, half,
      ~ fs::dir_ls("EFRes", regexp = str_c(.x, ".+", .y), ignore.case = TRUE)
    )
  ) |>
  unnest(file_data) |>
  mutate(
    indices = map2(
      task, file_data,
      ~ readr::read_csv(.y, show_col_types = FALSE) |>
        inner_join(
          readxl::read_excel(
            fs::dir_ls("config", regexp = .x, ignore.case = TRUE)
          ),
          by = "id"
        ) |>
        group_by(id) |>
        filter(row_number(PE) == 1) |>
        ungroup() |>
        select(id, all_of(set_names(index_map[.x], "index")))
    )
  ) |>
  unnest(indices) |>
  pivot_wider(c("task", "id"), names_from = "half", values_from = "index") |>
  group_by(task) |>
  summarise(
    r_split_half = cor(Even, Odd),
    split_half = 2 * r_split_half / (1 + r_split_half)
  ) |>
  writexl::write_xlsx("results/reliability.xlsx")
subjects <- readr::read_lines(
  "config/2110sublist_EAS_noGRM0.05_withAgeSex.txt"
) |>
  readr::parse_double()
splithalf_stopsignal <- readr::read_csv(
  "EFRes/StopSignalResultBlocks.csv"
) |>
  filter(iBlock %in% c(3, 4), id %in% subjects) |>
  drop_na() |>
  pivot_wider(
    id_cols = c(id, time),
    names_from = iBlock,
    values_from = SSRT
  ) |>
  drop_na() |>
  summarise(
    r = cor(`3`, `4`),
    reliability = 2 * r / (1 + r)
  )
readr::read_csv("KeepTrack/keepTrack_4scores_v1.csv") |>
  select(-ID) |>
  psych::alpha() |>
  summary()
readr::read_csv("KeepTrack/keepTrack_4scores_v2.csv") |>
  select(-ID) |>
  psych::alpha() |>
  summary()
