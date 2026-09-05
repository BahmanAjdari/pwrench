#' Get events for a Jalali date from time.ir and UN observances
#'
#' Scrapes the time.ir website and UN observances to retrieve events and
#' holidays for a given Jalali (Solar Hijri) date.
#'
#' @param date_string Character. A Jalali date string in "YYYY-MM-DD" format (e.g. `"1405-06-11"`).
#' @param include_un Logical. Whether to include UN international days/weeks (default `TRUE`).
#'
#' @return A data frame with columns:
#' \describe{
#'   \item{event_name}{Character. Event description.}
#'   \item{source}{Character. Source of the event ("time.ir" or "UN").}
#'   \item{event_date}{Character. Date reference for the event.}
#'   \item{has_detail}{Logical. TRUE if the event has a detail page (time.ir only).}
#'   \item{detail_url}{Character. URL to the event detail page (if available).}
#'   \item{resolution}{Character. UN resolution reference (UN events only).}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' get_jalali_events("1405-06-11")
#' get_jalali_events("1405-01-01", include_un = TRUE)
#' }
#'
get_jalali_events <- function(date_string, include_un = TRUE) {
  if (!requireNamespace("rvest", quietly = TRUE)) {
    stop("Package 'rvest' is required. Install it with: install.packages('rvest')")
  }
  if (!requireNamespace("httr2", quietly = TRUE)) {
    stop("Package 'httr2' is required. Install it with: install.packages('httr2')")
  }

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

  # Jalali month names
  jalali_month_names <- c(
    "فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور",
    "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"
  )

  # Fetch events from time.ir
  url <- paste0("https://www.time.ir/event/", jy, "/", jm, "/", jd)

  response <- tryCatch(
    httr2::request(url) |>
      httr2::req_retry(max_tries = 3) |>
      httr2::req_perform(),
    error = function(e) {
      warning("Failed to fetch data from time.ir: ", e$message)
      return(NULL)
    }
  )

  # Initialize time.ir events data frame
  timeir_events <- data.frame(
    event_name = character(0),
    source = character(0),
    event_date = character(0),
    has_detail = logical(0),
    detail_url = character(0),
    resolution = character(0),
    stringsAsFactors = FALSE
  )

  if (!is.null(response)) {
    # Parse HTML
    page <- rvest::read_html(httr2::resp_body_string(response))

    # Extract all event items
    event_items <- page |> rvest::html_elements("[class*='SpecialDayEventListItem-module'][class*='root']:not([class*='root__title']):not([class*='title__date']):not([class*='root__detail'])")

    for (item in event_items) {
      # Extract event title
      title_elem <- item |> rvest::html_element("[class*='root__title']")
      if (is.null(title_elem)) next

      # Get the event name (text without the date span)
      date_span <- title_elem |> rvest::html_element("[class*='title__date']")
      event_date <- if (!is.null(date_span)) date_span |> rvest::html_text2() else ""

      # Get the full title text and remove the date part
      full_title <- title_elem |> rvest::html_text2()
      event_name <- gsub("\\[.*\\]", "", full_title) |> trimws()

      # Check if this event has a detail page
      has_detail <- !is.null(item) &&
        grepl("hasDetail", item |> rvest::html_attr("class") %||% "")

      # Extract detail URL if available
      detail_url <- ""
      if (has_detail) {
        href <- item |> rvest::html_attr("href")
        if (!is.null(href) && nchar(href) > 0) {
          detail_url <- paste0("https://www.time.ir", href)
        }
      }

      # Add to results
      timeir_events <- rbind(timeir_events, data.frame(
        event_name = event_name,
        source = "time.ir",
        event_date = event_date,
        has_detail = has_detail,
        detail_url = detail_url,
        resolution = "",
        stringsAsFactors = FALSE
      ))
    }
  }

  # Fetch UN observances if requested
  un_events <- data.frame(
    event_name = character(0),
    source = character(0),
    event_date = character(0),
    has_detail = logical(0),
    detail_url = character(0),
    resolution = character(0),
    stringsAsFactors = FALSE
  )

  if (include_un) {
    un_data <- tryCatch(
      get_un_observances(jy),
      error = function(e) {
        warning("Failed to fetch UN observances: ", e$message)
        return(NULL)
      }
    )

    if (!is.null(un_data) && nrow(un_data) > 0) {
      # Filter for the specific date
      un_filtered <- un_data[un_data$jalali_month == jm & un_data$jalali_day == jd, ]

      if (nrow(un_filtered) > 0) {
        un_events <- data.frame(
          event_name = un_filtered$event_name,
          source = "UN",
          event_date = un_filtered$jalali_date,
          has_detail = FALSE,
          detail_url = "",
          resolution = un_filtered$resolution,
          stringsAsFactors = FALSE
        )
      }
    }
  }

  # Combine results
  all_events <- rbind(timeir_events, un_events)

  all_events
}

# Helper operator for NULL coalescing
`%||%` <- function(x, y) if (is.null(x)) y else x
