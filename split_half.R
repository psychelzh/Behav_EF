box::use(
  dplyr[...],
  tidyr[...],
  purrr[...],
  stringr[...]
)
index_map <- readr::read_csv("config/index_map.csv", show_col_types = FALSE) |>
  tibble::deframe()
c("AntiSac", "CateSwitch", "ShiftColor", "ShiftNumber", "spatialWM", "Stroop", "WM3") |>
  tibble::as_tibble_col(column_name = "task") |>
  expand_grid(half = c("Even", "Odd")) |>
  mutate(
    indices = map2(
      task, half,
      ~ readr::read_csv(
        fs::dir_ls("EFRes", regexp = str_c(.x, ".+", .y), ignore.case = TRUE),
        show_col_types = FALSE
      ) |>
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
  pivot_wider(names_from = "half", values_from = "index") |>
  group_by(task) |>
  summarise(
    r_split_half = cor(Even, Odd),
    split_half = 2 * r_split_half / (1 + r_split_half)
  ) |>
  writexl::write_xlsx("results/reliability.xlsx")
