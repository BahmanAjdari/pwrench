#' Correcting characters from Arabic keyboards
#'
#' @param dataset Your dataset
#' @param coln The column you want to clean
#'
#' @return Dataset with Persian characters corrected
#' @export
#'
#' @examples
farsi_keyboard <- function(dataset, coln) {
  library(dplyr)
  library(stringr)

  fa_ya_false <- "ي"
  fa_ya_correct <- "ی"
  fa_ka_false <- "ك"
  fa_ka_correct <- "ک"

  dataset |>
    mutate({{coln}} := str_replace_all({{coln}}, fa_ka_false, fa_ka_correct)) |>
    mutate({{coln}} := str_replace_all({{coln}}, fa_ya_false, fa_ya_correct))
}
