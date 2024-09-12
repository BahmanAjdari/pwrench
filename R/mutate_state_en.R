
#' Ostan to Province
#' @description
#' This function gets Persian state name and transform the Persian col to English which is standard names for Iran's states in English
#'
#' @param data Pass the data you are working on
#' @param column_name the is the column that contains Persian names of Ostan(استان)
#'
#' @return state_en columns that contains English name of states in Iran.
#' @export
#'
#' @examples
mutate_state_en <- function(data, column_name) {
  data %>%
    mutate(state_en = case_when(
      {{column_name}}=="آذربایجان شرقی" ~ "East Azerbaijan",
      {{column_name}}=="آذربایجان غربی" ~ "West Azerbaijan",
      {{column_name}}=="اردبیل" ~ "Ardabil",
      {{column_name}}=="اصفهان" ~ "Isfahan",
      {{column_name}}=="البرز" ~ "Alborz",
      {{column_name}}=="ایلام" ~ "Ilam",
      {{column_name}}=="بوشهر" ~ "Bushehr",
      {{column_name}}=="تهران" ~ "Tehran",
      {{column_name}}=="چهارمحال وبختیاری"~"Chaharmahal and Bakhtiari",
      {{column_name}}=="خراسان جنوبی" ~ "South Khorasan",
      {{column_name}}=="خراسان رضوی" ~ "Razavi Khorasan",
      {{column_name}}=="خراسان شمالی" ~ "North Khorasan",
      {{column_name}}=="خوزستان" ~ "Khuzestan",
      {{column_name}}=="زنجان" ~ "Zanjan",
      {{column_name}}=="سمنان" ~ "Semnan",
      {{column_name}}=="سیستان وبلوچستان" ~ "Sistan and Baluchestan",
      {{column_name}}=="فارس" ~ "Fars",
      {{column_name}}=="قزوین" ~ "Qazvin",
      {{column_name}}=="قم" ~ "Qom",
      {{column_name}}=="کردستان" ~"Kurdistan",
      {{column_name}}=="کرمان" ~ "Kerman",
      {{column_name}}=="کرمانشاه" ~ "Kermanshah",
      {{column_name}}=="کهگیلویه وبویراحمد" ~"Kohgiluyeh and Boyer-Ahmad",
      {{column_name}}=="گلستان" ~ "Golestan",
      {{column_name}}=="گیلان" ~ "Gilan",
      {{column_name}}=="لرستان" ~ "Lorestan",
      {{column_name}}=="مازندران" ~ "Mazandaran",
      {{column_name}}=="مرکزی" ~ "Markazi",
      {{column_name}}=="هرمزگان" ~ "Hormozgan",
      {{column_name}}=="همدان" ~ "Hamadan",
      {{column_name}}=="یزد" ~ "Yazd",
      TRUE ~ NA_character_
    ))
}
