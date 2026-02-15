#' Add English province names and optional codes from Persian Ostan names
#'
#' Takes a column of Persian province names (استان) and adds standard English
#' names and/or numeric codes for Iran's provinces. Input is trimmed so
#' leading/trailing whitespace still matches.
#'
#' @param data A data frame or tibble.
#' @param column_name Unquoted name of the column containing Persian province
#'   names (استان).
#' @param add Character vector. Which columns to add: `"state_en"` (English name),
#'   `"state_code"` (numeric code as character), or both (default).
#'
#' @return The data with new column(s) `state_en` and/or `state_code` appended.
#'   Unmatched names yield `NA`.
#'
#' @export
#'
#' @examples
#' d <- data.frame(ostan = c("تهران", "  اصفهان  ", "خوزستان"))
#' mutate_state_en(d, ostan)
#' mutate_state_en(d, ostan, add = "state_en")
#'
mutate_state_en <- function(data,
                           column_name,
                           add = c("state_en", "state_code")) {
  col_chr <- as.character(substitute(column_name))
  if (!col_chr %in% names(data)) {
    stop("Column '", col_chr, "' not found in data.")
  }

  add <- match.arg(add, c("state_en", "state_code"), several.ok = TRUE)

  out <- data %>%
    mutate(
      .st = trimws({{ column_name }}),
      state_en = case_when(
        .st == "آذربایجان شرقی" ~ "East Azerbaijan",
        .st == "آذربایجان غربی" ~ "West Azerbaijan",
        .st == "اردبیل" ~ "Ardabil",
        .st == "اصفهان" ~ "Isfahan",
        .st == "البرز" ~ "Alborz",
        .st == "ایلام" ~ "Ilam",
        .st == "بوشهر" ~ "Bushehr",
        .st == "تهران" ~ "Tehran",
        .st == "چهارمحال وبختیاری" ~ "Chaharmahal and Bakhtiari",
        .st == "چهارمحال و بختیاری" ~ "Chaharmahal and Bakhtiari",
        .st == "خراسان جنوبی" ~ "South Khorasan",
        .st == "خراسان رضوی" ~ "Razavi Khorasan",
        .st == "خراسان شمالی" ~ "North Khorasan",
        .st == "خوزستان" ~ "Khuzestan",
        .st == "زنجان" ~ "Zanjan",
        .st == "سمنان" ~ "Semnan",
        .st == "سیستان وبلوچستان" ~ "Sistan and Baluchestan",
        .st == "سیستان بلوچستان" ~ "Sistan and Baluchestan",
        .st == "سیستان و بلوچستان" ~ "Sistan and Baluchestan",
        .st == "فارس" ~ "Fars",
        .st == "قزوین" ~ "Qazvin",
        .st == "قم" ~ "Qom",
        .st == "کردستان" ~ "Kurdistan",
        .st == "کرمان" ~ "Kerman",
        .st == "کرمانشاه" ~ "Kermanshah",
        .st == "کهگیلویه وبویراحمد" ~ "Kohgiluyeh and Boyer-Ahmad",
        .st == "کهگیلویه و بویراحمد" ~ "Kohgiluyeh and Boyer-Ahmad",
        .st == "کهگلویه و بویراحمد" ~ "Kohgiluyeh and Boyer-Ahmad",
        .st == "گلستان" ~ "Golestan",
        .st == "گیلان" ~ "Gilan",
        .st == "لرستان" ~ "Lorestan",
        .st == "مازندران" ~ "Mazandaran",
        .st == "مرکزی" ~ "Markazi",
        .st == "هرمزگان" ~ "Hormozgan",
        .st == "همدان" ~ "Hamadan",
        .st == "یزد" ~ "Yazd",
        TRUE ~ NA_character_
      ),
      state_code = case_when(
        .st == "آذربایجان شرقی" ~ "41",
        .st == "آذربایجان غربی" ~ "44",
        .st == "اردبیل" ~ "45",
        .st == "اصفهان" ~ "31",
        .st == "البرز" ~ "26",
        .st == "ایلام" ~ "84",
        .st == "بوشهر" ~ "77",
        .st == "تهران" ~ "21",
        .st == "چهارمحال و بختیاری" ~ "38",
        .st == "چهارمحال وبختیاری" ~ "38",
        .st == "خراسان جنوبی" ~ "56",
        .st == "خراسان رضوی" ~ "51",
        .st == "خراسان شمالی" ~ "58",
        .st == "خوزستان" ~ "61",
        .st == "زنجان" ~ "24",
        .st == "سمنان" ~ "23",
        .st == "سیستان بلوچستان" ~ "54",
        .st == "سیستان وبلوچستان" ~ "54",
        .st == "سیستان و بلوچستان" ~ "54",
        .st == "فارس" ~ "71",
        .st == "قزوین" ~ "28",
        .st == "قم" ~ "25",
        .st == "گلستان" ~ "17",
        .st == "گیلان" ~ "13",
        .st == "لرستان" ~ "66",
        .st == "مازندران" ~ "11",
        .st == "مرکزی" ~ "86",
        .st == "هرمزگان" ~ "76",
        .st == "همدان" ~ "81",
        .st == "کردستان" ~ "87",
        .st == "کرمان" ~ "34",
        .st == "کرمانشاه" ~ "83",
        .st == "کهگیلویه و بویراحمد" ~ "74",
        .st == "کهگیلویه وبویراحمد" ~ "74",
        .st == "کهگلویه و بویراحمد" ~ "74",
        .st == "یزد" ~ "35",
        TRUE ~ NA_character_
      )
    ) %>%
    select(-.st)

  keep <- setdiff(names(out), names(data))
  drop <- setdiff(keep, add)
  if (length(drop) > 0) {
    out <- select(out, -all_of(drop))
  }

  out
}
