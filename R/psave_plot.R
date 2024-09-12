#' Save plots easily
#'
#' @param plot
#' @param height
#' @param width
#' @param dpi
#' @param units
#' @param path
#'
#' @description
#' This function save your plots in ggplot2 in a dir named plot that may or may not exists in you wd dir.
#'
#' @return
#' @export
#'
#' @examples
psave_plot <- function(plot, height = 8, width = 12,dpi = 300,units = "in" ,path = getwd()) {
  # Ensure the directory exists
  if (!dir.exists("plot")) {
    dir.create("plot/", recursive = TRUE)
  }

  # Save the plot
  ggsave(
    plot = plot,
    filename = paste0("plot/", deparse(substitute(plot)), ".png"),
    height = height,
    width = width,
    units = units,
    dpi = dpi
  )
}
