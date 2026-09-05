#' Convert Gregorian date to Jalali date
#'
#' Takes a Gregorian date string in "YYYY-MM-DD" format and returns the
#' corresponding Jalali (Solar Hijri) date string in the same format.
#'
#' @param date_string Character. A date string in "YYYY-MM-DD" format (e.g. `"2026-09-02"`).
#'
#' @return Character. A Jalali date string in "YYYY-MM-DD" format (e.g. `"1405-06-11"`).
#'
#' @export
#'
#' @examples
#' gregorian_to_jalali("2026-09-02")
#' gregorian_to_jalali("2024-01-01")
#'
gregorian_to_jalali <- function(date_string) {
  if (!is.character(date_string) || length(date_string) != 1) {
    stop("'date_string' must be a single character string.")
  }

  parts <- strsplit(date_string, "-")[[1]]
  if (length(parts) != 3 || any(is.na(suppressWarnings(as.integer(parts))))) {
    stop("Invalid date format. Expected 'YYYY-MM-DD'.")
  }

  gy <- as.integer(parts[1])
  gm <- as.integer(parts[2])
  gd <- as.integer(parts[3])

  if (gm < 1 || gm > 12 || gd < 1 || gd > 31) {
    stop("Invalid Gregorian date values.")
  }

  # Days in each Gregorian month
  g_days_in_month <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

  # Leap year check
  is_leap_gregorian <- ((gy %% 4 == 0) & (gy %% 100 != 0)) | (gy %% 400 == 0)
  if (is_leap_gregorian) {
    g_days_in_month[2] <- 29
  }

  # Validate day
  if (gd > g_days_in_month[gm]) {
    stop("Invalid day for the given month.")
  }

  # Gregorian day of year
  g_doy <- sum(g_days_in_month[1:(gm - 1)]) + gd

  # Offset from March 21 (Nowruz)
  # Months before March: Jan(31) + Feb(28/29) = 59 or 60
  # So Jan 1 = day -60 or -61 from March 21
  if (is_leap_gregorian) {
    g_offset <- g_doy - 80  # Mar 21 is day 81 in leap year
  } else {
    g_offset <- g_doy - 79  # Mar 21 is day 80 in non-leap year
  }

  # Jalali leap year positions in a 33-year cycle
  # Years: 1, 5, 9, 13, 17, 22, 26, 30 are leap years
  # Total days in 33-year cycle: 33*365 + 8 = 12053
  leap_years <- c(1, 5, 9, 13, 17, 22, 26, 30)
  cycle_days <- 33 * 365 + 8  # 12053

  # Determine Jalali year
  # The epoch (Jalali year 1, Farvardin 1) corresponds to Gregorian March 21, 622 CE
  # We need to find how many days from epoch to our date

  # Days from epoch to start of given Gregorian year
  # Epoch: March 21, 622 CE (Gregorian)
  # Days from March 21, 622 to January 1, gy
  years_diff <- gy - 622

  # Days from epoch to Jan 1 of gy
  # From March 21, 622 to March 21, gy = years_diff * 365 + number of leap years between
  # From March 21, gy to Jan 1, gy = - (days from Jan 1 to March 21)
  # Jan 1 to Mar 21 = 31(Jan) + 28/29(Feb) + 21(Mar) = 79 or 80

  # Count Gregorian leap years from 622 to gy (exclusive of current year for the offset)
  # Leap years divisible by 4, not by 100, unless by 400
  count_leaps <- function(from_year, to_year) {
    leaps <- 0
    for (y in from_year:(to_year - 1)) {
      if (((y %% 4 == 0) & (y %% 100 != 0)) | (y %% 400 == 0)) {
        leaps <- leaps + 1
      }
    }
    leaps
  }

  n_leaps <- count_leaps(622, gy)

  # Days from epoch (Mar 21, 622) to Jan 1, gy
  days_to_jan1 <- years_diff * 365 + n_leaps - 79
  if (is_leap_gregorian) {
    days_to_jan1 <- years_diff * 365 + n_leaps - 80
  }

  # Total days from epoch
  days_from_epoch <- days_to_jan1 + g_doy - 1

  # Find Jalali year
  # Jalali year 1 starts on the epoch
  # Each year is 365 or 366 days
  jy <- 1
  remaining <- days_from_epoch

  while (remaining >= 0) {
    # Days in current Jalali year
    is_leap_jy <- (jy %in% leap_years) || (((jy + 1) %% 33) %in% leap_years)
    # Actually, the leap year pattern is: years 1, 5, 9, 13, 17, 22, 26, 30 in each 33-year cycle
    # But year numbering starts at 1, so we check (jy-1) mod 33
    cycle_pos <- ((jy - 1) %% 33) + 1
    is_leap_jy <- cycle_pos %in% leap_years
    year_days <- ifelse(is_leap_jy, 366, 365)

    if (remaining < year_days) {
      break
    }
    remaining <- remaining - year_days
    jy <- jy + 1
  }

  # Day within Jalali year (0-indexed)
  j_day_of_year <- remaining

  # Jalali month lengths: first 6 months = 31, next 5 months = 30, last month = 29 or 30
  jalali_month_lengths <- c(rep(31, 6), rep(30, 5), ifelse(is_leap_jy, 30, 29))

  # Find month and day
  jm <- 1
  jd <- j_day_of_year + 1  # Convert to 1-indexed

  for (m in 1:12) {
    if (jd <= jalali_month_lengths[m]) {
      jm <- m
      break
    }
    jd <- jd - jalali_month_lengths[m]
  }

  sprintf("%04d-%02d-%02d", jy, jm, jd)
}
