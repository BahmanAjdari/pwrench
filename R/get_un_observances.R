#' Get UN International Days and Weeks
#'
#' Scrapes the UN website to retrieve international days and weeks, then
#' converts the Gregorian dates to Jalali dates for a specific year.
#' Note: UN international days are recurring annual events.
#'
#' @param year Integer. The Jalali year to filter events for (e.g., 1405).
#'
#' @return A data frame with columns:
#' \describe{
#'   \item{event_name}{Character. Name of the international day/week.}
#'   \item{gregorian_date}{Character. Gregorian date (e.g., "2026-09-02").}
#'   \item{jalali_date}{Character. Jalali date (e.g., "11 شهریور").}
#'   \item{jalali_month}{Integer. Jalali month number.}
#'   \item{jalali_day}{Integer. Jalali day number.}
#'   \item{resolution}{Character. UN resolution reference (if available).}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' get_un_observances(1405)
#' }
#'
get_un_observances <- function(year) {
  if (!requireNamespace("rvest", quietly = TRUE)) {
    stop("Package 'rvest' is required. Install it with: install.packages('rvest')")
  }
  if (!requireNamespace("httr2", quietly = TRUE)) {
    stop("Package 'httr2' is required. Install it with: install.packages('httr2')")
  }

  if (!is.numeric(year) || length(year) != 1 || year < 1) {
    stop("'year' must be a single positive integer (Jalali year).")
  }

  # Fetch the UN observances page
  url <- "https://www.un.org/en/observances/list-days-weeks"

  response <- tryCatch(
    httr2::request(url) |>
      httr2::req_headers(
        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      ) |>
      httr2::req_perform(),
    error = function(e) {
      stop("Failed to fetch UN observances: ", e$message)
    }
  )

  # Parse HTML
  page <- rvest::read_html(httr2::resp_body_string(response))

  # Extract all event rows
  event_rows <- page |> rvest::html_elements(".view-content .views-row")

  # Jalali month names for reference
  jalali_month_names <- c(
    "فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور",
    "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"
  )

  # Parse each event
  events <- data.frame(
    event_name = character(0),
    gregorian_date = character(0),
    jalali_date = character(0),
    jalali_month = integer(0),
    jalali_day = integer(0),
    resolution = character(0),
    stringsAsFactors = FALSE
  )

  for (row in event_rows) {
    # Extract event name
    title_elem <- row |> rvest::html_element(".views-field-title .field-content")
    if (is.null(title_elem)) next
    event_name <- title_elem |> rvest::html_text2()
    event_name <- gsub("\\s+", " ", trimws(event_name))

    # Extract date (ISO format from content attribute)
    date_elem <- row |> rvest::html_element(".views-field-field-event-date-1 .date-display-single")
    if (is.null(date_elem)) next
    iso_date <- date_elem |> rvest::html_attr("content")
    if (is.null(iso_date) || nchar(iso_date) == 0) next

    # Parse the ISO date (format: YYYY-MM-DDThh:mm:ss+00:00)
    gregorian_date_str <- substr(iso_date, 1, 10)
    date_parts <- strsplit(gregorian_date_str, "-")[[1]]
    if (length(date_parts) != 3) next

    # Extract month and day (ignore year for recurring events)
    gm <- as.integer(date_parts[2])
    gd <- as.integer(date_parts[3])

    # Convert the target Jalali year to Gregorian to find the right Gregorian year
    # Use a rough estimate: Jalali year + 621 or 622
    # Then refine by converting Jan 1 of that estimate
    estimated_gy <- year + 621
    # Test if this Gregorian year maps to the target Jalali year
    test_jan1 <- gregorian_to_jalali(paste0(estimated_gy, "-01-01"))
    test_jy <- as.integer(strsplit(test_jan1, "-")[[1]][1])
    if (test_jy > year) {
      estimated_gy <- estimated_gy - 1
    } else if (test_jy < year) {
      estimated_gy <- estimated_gy + 1
    }
    gregorian_str <- sprintf("%04d-%02d-%02d", estimated_gy, gm, gd)
    jalali_str <- tryCatch(
      gregorian_to_jalali(gregorian_str),
      error = function(e) NULL
    )

    if (is.null(jalali_str)) next

    # Parse Jalali date
    jalali_parts <- strsplit(jalali_str, "-")[[1]]
    jy <- as.integer(jalali_parts[1])
    jm <- as.integer(jalali_parts[2])
    jd <- as.integer(jalali_parts[3])

    # Filter for the requested year (in case of year boundary issues)
    if (jy != year) next

    # Extract resolution (optional)
    resolution_elem <- row |> rvest::html_element(".views-field-field-url .field-content")
    resolution <- if (!is.null(resolution_elem)) {
      res_text <- resolution_elem |> rvest::html_text2()
      gsub("[()]", "", trimws(res_text))
    } else {
      ""
    }

    # Format Jalali date for display
    jalali_display <- sprintf("%d %s", jd, jalali_month_names[jm])

    # Add to results
    events <- rbind(events, data.frame(
      event_name = event_name,
      gregorian_date = gregorian_str,
      jalali_date = jalali_display,
      jalali_month = jm,
      jalali_day = jd,
      resolution = resolution,
      stringsAsFactors = FALSE
    ))
  }

  # Sort by month and day
  if (nrow(events) > 0) {
    events <- events[order(events$jalali_month, events$jalali_day), ]
  }

  events
}
