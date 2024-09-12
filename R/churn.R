# Function to calculate churn rate
#' churn rates by year
#' @description
#' This function returns churn rate for product id in year.
#'
#' @param data
#' @param year
#' @param product_id
#'
#' @return churn rate
#' @export
#'
#' @examples
#' years <- 2018:2021
#' churn_rates <- lapply(years, function(y) calculate_churn_rate(x, y))
calculate_churn_rate <- function(data, year, product_id = "product_id") {
  data_year <- data |>
    filter(purchase_year == year)

  churn_rate <- data_year |>
    group_by(product_id) |>
    summarise(
      total_customers = n(),
      churned_customers = sum(!renewed),
      churn_rate = churned_customers / total_customers
    ) |>
    mutate(year = year)

  churn_rate
}
