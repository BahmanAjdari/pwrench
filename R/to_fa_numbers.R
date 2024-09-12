#' English numbers to Persian numbers
#'
#' @param x The English number
#'
#' @return Persian Number
#' @export
#'
#' @examples to_fa_numbers(123)
to_fa_numbers <- function(x) {
  persian <- "\u0660\u0661\u0662\u0663\u0664\u0665\u0666\u0667\u0668\u0669\u06F0\u06F1\u06F2\u06F3\u06F4\u06F5\u06F6\u06F7\u06F8\u06F9"
  english <- "\U0030\U0031\U0032\U0033\U0034\U0035\U0036\U0037\U0038\U0039\U0030\U0031\U0032\U0033\U0034\U0035\U0036\U0037\U0038\U0039"
  return(chartr(english,persian, x))
}
