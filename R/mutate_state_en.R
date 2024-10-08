
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
mutate_state_en <- function(data, column_name) {
  data %>%
    mutate(state_en = case_when(
      {{column_name}}=="آذربایجان شرقی" ~ "East Azerbaijan",
      {{column_name}}=="آذربایجان شرقی" ~ "East Azerbaijan",
      {{column_name}}=="آذربایجان غربی" ~ "West Azerbaijan",
      {{column_name}}=="اردبیل" ~ "Ardabil",
      {{column_name}}=="اصفهان" ~ "Isfahan",
      {{column_name}}=="البرز" ~ "Alborz",
      {{column_name}}=="ایلام" ~ "Ilam",
      {{column_name}}=="بوشهر" ~ "Bushehr",
      {{column_name}}=="تهران" ~ "Tehran",
      {{column_name}}=="چهارمحال وبختیاری"~"Chaharmahal and Bakhtiari",
      {{column_name}}=="چهارمحال و بختیاری"~"Chaharmahal and Bakhtiari",
      {{column_name}}=="خراسان جنوبی" ~ "South Khorasan",
      {{column_name}}=="خراسان جنوبی" ~ "South Khorasan",
      {{column_name}}=="خراسان رضوی" ~ "Razavi Khorasan",
      {{column_name}}=="خراسان شمالی" ~ "North Khorasan",
      {{column_name}}=="خوزستان" ~ "Khuzestan",
      {{column_name}}=="زنجان" ~ "Zanjan",
      {{column_name}}=="سمنان" ~ "Semnan",
      {{column_name}}=="سیستان وبلوچستان" ~ "Sistan and Baluchestan",
      {{column_name}}=="سیستان بلوچستان" ~ "Sistan and Baluchestan",
      {{column_name}}=="سیستان و بلوچستان" ~ "Sistan and Baluchestan",
      {{column_name}}=="فارس" ~ "Fars",
      {{column_name}}=="قزوین" ~ "Qazvin",
      {{column_name}}=="قزوین" ~ "Qazvin",
      {{column_name}}=="قم" ~ "Qom",
      {{column_name}}=="کردستان" ~"Kurdistan",
      {{column_name}}=="کرمان" ~ "Kerman",
      {{column_name}}=="کرمانشاه" ~ "Kermanshah",
      {{column_name}}=="کهگیلویه وبویراحمد" ~"Kohgiluyeh and Boyer-Ahmad",
      {{column_name}}=="کهگلویه و بویراحمد" ~"Kohgiluyeh and Boyer-Ahmad",
      {{column_name}}=="گلستان" ~ "Golestan",
      {{column_name}}=="گیلان" ~ "Gilan",
      {{column_name}}=="لرستان" ~ "Lorestan",
      {{column_name}}=="مازندران" ~ "Mazandaran",
      {{column_name}}=="مرکزی" ~ "Markazi",
      {{column_name}}=="هرمزگان" ~ "Hormozgan",
      {{column_name}}=="همدان" ~ "Hamadan",
      {{column_name}}=="یزد" ~ "Yazd",
      TRUE ~ NA_character_
    ),
    state_code = case_when(
      {{column_name}} == "تهران" ~ "21",
      {{column_name}} == "آذربایجان شرقی" ~ "41",
      {{column_name}} == "آذربایجان غربی" ~ "44",
      {{column_name}} == "اردبیل" ~ "45",
      {{column_name}} == "اصفهان" ~ "31",
      {{column_name}} == "البرز" ~ "26",
      {{column_name}} == "ایلام" ~ "84",
      {{column_name}} == "بوشهر" ~ "77",
      {{column_name}} == " چهارمحال و بختیاری" ~ "38",
      {{column_name}} == "چهارمحال و بختیاری" ~ "38",
      {{column_name}} == "خراسان جنوبی" ~ "56",
      {{column_name}} == "خراسان رضوی" ~ "51",
      {{column_name}} == "خراسان شمالی" ~ "58",
      {{column_name}} == "خوزستان" ~ "61",
      {{column_name}} == "زنجان" ~ "24",
      {{column_name}} == "سمنان" ~ "23",
      {{column_name}} == "سیستان بلوچستان" ~ "54",
      {{column_name}} == "سیستان و بلوچستان" ~ "54",
      {{column_name}} == "فارس" ~ "71",
      {{column_name}} == "قزوین" ~ "28",
      {{column_name}} == "قم" ~ "25",
      {{column_name}} == "گلستان" ~ "17",
      {{column_name}} == "گیلان" ~ "13",
      {{column_name}} == "لرستان" ~ "66",
      {{column_name}} == "مازندران" ~ "11",
      {{column_name}} == "مرکزی" ~ "86",
      {{column_name}} == "هرمزگان" ~ "76",
      {{column_name}} == "همدان" ~ "81",
      {{column_name}} == "کردستان" ~ "87",
      {{column_name}} == "کرمان" ~ "34",
      {{column_name}} == "کرمانشاه" ~ "83",
      {{column_name}} == "کهگیلویه و بویراحمد" ~ "74",
      {{column_name}} == "کهگیلویه وبویراحمد" ~ "74",
      {{column_name}} == "کهگلویه و بویراحمد" ~ "74",
      {{column_name}} == "یزد" ~ "35",
      TRUE ~ NA_character_
    )
    )
}
