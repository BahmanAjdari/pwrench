#' Persian-friendly theme for ggplot2 maps
#'
#' A minimal map theme for ggplot2 tuned for Persian/Farsi text (e.g. Sahel font),
#' with no axes, white background, and configurable text sizes. Uses `theme_void()` as base.
#'
#' @param persian_font Character. Font family for all text (default `"Sahel FD"`). Ensure the font is installed.
#' @param title_size Numeric. Plot title size in pt (default `32`).
#' @param subtitle_size Numeric. Plot subtitle size in pt (default `22`).
#' @param legend_position Position of the legend: `"none"`, `"left"`, `"right"`, `"bottom"`, `"top"`, or a two-element numeric vector (default `"bottom"`).
#' @param facet_text_size Numeric. Legend and facet strip text size in pt (default `16`).
#' @param axis_text_size Numeric. Axis tick label size in pt (default `18`).
#' @param caption_size Numeric. Plot caption size in pt (default `10`).
#' @param title_hjust Numeric. Horizontal justification for title, subtitle, and caption: `0.5` = center, `1` = right (e.g. for RTL) (default `0.5`).
#'
#' @return A ggplot2 theme object.
#' @export
#'
#' @examples
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   library(ggplot2)
#'   # Use with a map (e.g. geom_sf) + labs(...) + theme_map_fa()
#' }
#'
theme_map_fa <- function(persian_font = "Sahel FD",
                         title_size = 32,
                         subtitle_size = 22,
                         legend_position = "bottom",
                         facet_text_size = 16,
                         axis_text_size = 18,
                         caption_size = 10,
                         title_hjust = 0.5) {
  theme_void(base_family = persian_font) +
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      axis.text = element_text(size = axis_text_size),
      axis.text.x = element_text(margin = margin(t = -1)),
      axis.text.y = element_text(margin = margin(r = -1)),
      axis.ticks.x = element_blank(),
      plot.title = element_text(family = persian_font, size = title_size, hjust = title_hjust),
      plot.subtitle = element_text(family = persian_font, size = subtitle_size, hjust = title_hjust),
      plot.caption = element_text(family = persian_font, size = caption_size, hjust = title_hjust),
      plot.background = element_rect(fill = "white"),
      panel.background = element_rect(fill = "white"),
      panel.border = element_blank(),
      panel.grid.minor = element_blank(),
      legend.position = legend_position,
      legend.title = element_blank(),
      legend.text = element_text(size = facet_text_size),
      strip.text = element_text(size = 16, family = persian_font),
      strip.background = element_rect(fill = "white")
    )
}
