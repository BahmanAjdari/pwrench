#' Rasmio Theme
#'
#' This function handles theme with Rasmio standards
#'
#' @param persian_font font family. Defaults tp Sahel Family. Make sure you have it!
#' @param title_size size
#' @param subtitle_size description
#' @param legend_position legend position
#' @param axis_size this value controls the font size of the axis for both x and y
#' @return Nice Theme for plots in Persian!
#' @export
#'
#'
rasmio_theme <- function(persian_font = "Sahel FD", title_size = 28, subtitle_size = 22,
                         legend_position = "bottom" , axis_size = 18) {
  theme_minimal(base_family = persian_font) +
    theme(
      axis.title = element_text(size = axis_size),
      axis.text = element_text(size = 16),
      axis.title.y = element_text(size = 8),
      plot.title = element_text(size = title_size, hjust = 0.5 , face = "bold"),  # Center the title
      plot.subtitle = element_text(size = subtitle_size, hjust = 0.5), # subtitle size
      legend.position = legend_position,  # Position the legend at the bottom
      legend.title = element_blank(),  # Remove the legend title
      panel.grid.minor = element_blank(),  # Remove minor grid lines
      axis.ticks = element_blank()  # Remove minor axis ticks
    )
}
