#' correcting charachters from Arabic keyboards
#'
#' @param dataset your dataset
#' @param coln the column you want to clean
#'
#' @return Persian charachters
#' @export
#'
#' @examples
farsi_keyboard <- function(dataset, coln) {
  require(dplyr)
  require(stringr)
  fa_ya_false <- "ي"
  fa_ya_correct <- "ی"
  fa_ka_false <- "ك"
  fa_ka_correct <- "ک"
  dataset |>
    mutate(coln = str_replace(dataset, pattern = fa_ka_false, replacement = fa_ka_correct)) |>
    mutate(coln = str_replace(col_name, pattern = fa_ya_false, replacement = fa_ya_correct))
  return(dataset)
}
