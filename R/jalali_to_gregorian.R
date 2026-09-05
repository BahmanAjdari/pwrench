#' Convert Jalali date to Gregorian date
#'
#' Takes a Jalali (Solar Hijri) date string in "YYYY-MM-DD" format and returns
#' the corresponding Gregorian date string in the same format.
#'
#' @param date_string Character. A Jalali date string in "YYYY-MM-DD" format (e.g. `"1405-06-11"`).
#'
#' @return Character. A Gregorian date string in "YYYY-MM-DD" format (e.g. `"2026-09-02"`).
#'
#' @export
#'
#' @examples
#' jalali_to_gregorian("1405-06-11")
#' jalali_to_gregorian("1403-01-01")
#'
jalali_to_gregorian <- function(date_string) {
  if (!is.character(date_string) || length(date_string) != 1) {
    stop("'date_string' must be a single character string.")
  }

  parts <- strsplit(date_string, "-")[[1]]
  if (length(parts) != 3 || any(is.na(suppressWarnings(as.integer(parts))))) {
    stop("Invalid date format. Expected 'YYYY-MM-DD'.")
  }

  jy <- as.integer(parts[1])
  jm <- as.integer(parts[2])
  jd <- as.integer(parts[3])

  if (jy < 1 || jm < 1 || jm > 12 || jd < 1 || jd > 31) {
    stop("Invalid Jalali date values.")
  }

  # Jalali leap year positions in a 33-year cycle
  leap_years <- c(1, 5, 9, 13, 17, 22, 26, 30)

  # Check if current Jalali year is leap
  cycle_pos <- ((jy - 1) %% 33) + 1
  is_leap_jy <- cycle_pos %in% leap_years

  # Jalali month lengths
  jalali_month_lengths <- c(rep(31, 6), rep(30, 5), ifelse(is_leap_jy, 30, 29))

  # Validate day
  if (jd > jalali_month_lengths[jm]) {
    stop("Invalid day for the given Jalali month.")
  }

  # Days in Jalali year up to given month
  j_days_in_year <- sum(jalali_month_lengths[1:(jm - 1)]) + jd

  # Calculate number of leap years before year jy
  # Each 33-year cycle has 8 leap years
  full_cycles <- floor((jy - 1) / 33)
  remaining_years <- (jy - 1) - full_cycles * 33

  # Count leap years in remaining years (positions 1 to remaining_years)
  n_leaps_remaining <- sum(leap_years <= remaining_years)

  # Total leap years before year jy
  n_leaps <- full_cycles * 8 + n_leaps_remaining

  # Days from Jalali epoch (1 Farvardin 1) to start of year jy
  days_to_year_start <- (jy - 1) * 365 + n_leaps

  # Total days from epoch
  total_days <- days_to_year_start + j_days_in_year - 1

  # Jalali epoch: 1 Farvardin 1 = March 21, 622 CE (Gregorian)
  # JDN for March 21, 622 CE = 1948321
  jalali_epoch_jdn <- 1948321

  # Target JDN
  target_jdn <- jalali_epoch_jdn + total_days

  # Convert JDN to Gregorian date
  # Using the standard algorithm from "Practical Astronomy with your Calculator"
  a <- target_jdn + 32044
  b <- floor((4 * a + 3) / 146097)
  c <- a - floor(146097 * b / 4)
  d <- floor((4 * c + 3) / 1461)
  e <- c - floor(1461 * d / 4)
  m <- floor((5 * e + 2) / 153)

  gd <- e - floor((153 * m + 2) / 5) + 1
  gm <- m + 3 - 12 * floor(m / 10)
  gy <- 100 * b + d - 4800 + floor(m / 10)

  sprintf("%04d-%02d-%02d", gy, gm, gd)
}
