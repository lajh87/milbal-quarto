
file <- "data-raw/Textract_Vol_061(1)_The Military Balance.csv"
readr::read_csv(file, show_col_types = FALSE) |>
  janitor::clean_names() |>
  dplyr::filter(page_number != "'1") |>
  dplyr::filter(!stringr::str_detect(layout, "Page number")) |>
  dplyr::mutate(text = stringr::str_remove_all(text, "^'")) |>
  dplyr::mutate(text = ifelse(stringr::str_detect(layout, "Title"), paste("#", text), text)) |>
  dplyr::mutate(text = ifelse(stringr::str_detect(layout, "Section header"), paste("##", text), text)) |>
  dplyr::mutate(text = ifelse(is.na(text), layout, text)) |>
  dplyr::filter(text != "PAGE") |> 
  dplyr::mutate(text = ifelse(stringr::str_detect(layout, "^'List"), "", text)) |>
  dplyr::pull(text) |>
  paste(collapse = "\n\n") |>
  write("data-raw/milbal_61_processed.qmd")
  