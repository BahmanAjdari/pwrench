# Function to calculate churn rate
#' Churn and retention rates by year
#'
#' @description
#' Returns churn rate and retention rate per product (or other grouping id) for
#' one or more years. Expects one row per customer purchase/renewal with a year,
#' a product (or segment) id, and a renewal flag.
#'
#' @param data Your dataframe or tibble.
#' @param year Numeric vector of years to include (e.g. `2020` or `2019:2023`).
#' @param product_id Character. Name of the column that identifies the product/segment (default `"product_id"`).
#' @param year_column Character. Name of the column containing the purchase/renewal year (default `"purchase_year"`).
#' @param renewed_column Character. Name of the logical column indicating renewal (default `"renewed"`). `TRUE` = renewed, `FALSE` = churned.
#'
#' @return A tibble with columns: product id, year, total_customers, renewed_customers, churned_customers, churn_rate, retention_rate. Returns one row per product per year; products with no customers in a year are omitted.
#'
#' @export
#'
#' @examples
#' dat <- data.frame(
#'   purchase_year = c(2022, 2022, 2023, 2023),
#'   product_id = c("A", "A", "A", "B"),
#'   renewed = c(TRUE, FALSE, TRUE, FALSE)
#' )
#' calculate_churn_rate(dat, year = 2022:2023)
#'
calculate_churn_rate <- function(data,
                                 year,
                                 product_id = "product_id",
                                 year_column = "purchase_year",
                                 renewed_column = "renewed") {
  required <- c(product_id, year_column, renewed_column)
  missing_cols <- setdiff(required, names(data))
  if (length(missing_cols) > 0) {
    stop("Required columns missing in 'data': ", paste(missing_cols, collapse = ", "))
  }

  data_year <- data |>
    filter(.data[[year_column]] %in% year)

  out <- data_year |>
    group_by(.data[[product_id]], .data[[year_column]]) |>
    summarise(
      total_customers = n(),
      renewed_customers = sum(.data[[renewed_column]], na.rm = TRUE),
      churned_customers = sum(!.data[[renewed_column]], na.rm = TRUE),
      .groups = "drop"
    ) |>
    mutate(
      churn_rate = if_else(total_customers > 0, churned_customers / total_customers, NA_real_),
      retention_rate = if_else(total_customers > 0, renewed_customers / total_customers, NA_real_)
    ) |>
    rename(year = .data[[year_column]])

  out
}
