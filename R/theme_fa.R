#' Theme Farsi
#'
#' This function handles theme in Persian plot
#'
#' @param persian_font font
#' @param title_size size
#' @param subtitle_size description
#' @param legend_position legend position
#' @return Nice looking Persian Theme in ggplot2
#' @export
#'
#'
theme_fa <- function(persian_font = "Sahel FD", title_size = 32, subtitle_size = 22,
                     legend_position = "bottom", facet_text_size = 16){
  theme_light(base_family = persian_font)+
  theme(axis.title.x = element_text(family = persian_font, size = 12),
        axis.title.y = element_text(family = persian_font),
        plot.title = element_text(family = persian_font , size = title_size, hjust = 0.5),
        plot.subtitle = element_text(family = persian_font, size = 18, hjust = 0.5),
        plot.background = element_rect(fill = "white"),
        panel.background = element_rect(fill = "white"),
        panel.border = element_blank(),
        axis.text = element_text(size = 18),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(margin = margin(t = -1)),  # Adjust top margin
        axis.text.y = element_text(margin = margin(r = -1)),   # Adjust right margin,
        axis.ticks.x = element_blank(),
        legend.text = element_text(size = facet_text_size),
        strip.text = element_text(size = 16, family = persian_font)
        #strip.background = element_rect(fill = "white")
        )
}
