#' Detecting fake mobile numbers in Iran
#'
#' @param phone_numbers
#'
#' @return TRUE or FALSE
#' @export
#'
#' @examples detect_fake_phone_numbers("09121234567")
detect_fake_phone_numbers <- function(phone_numbers) {
  # Helper function to check for repetitive numbers more than 3 times
  has_repetitive_numbers <- function(number) {
    return(grepl("(\\d)\\1{4,}", number))
  }

  # Helper function to check for consecutive sequences
  has_consecutive_sequence <- function(number) {
    consecutive_sequences <- "1234567|2345678|3456789|4567890|5678901|6789012|7890123|8901234|9012345|0987654|9876543|8765432|7654321|6543210|5432109"
    return(grepl(consecutive_sequences, number))
  }

  # Apply the helper functions to the phone numbers
  fake_numbers <- sapply(phone_numbers, function(number) {
    has_repetitive_numbers(number) || has_consecutive_sequence(number)
  })

  return(fake_numbers)
}
