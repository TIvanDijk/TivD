#' theme_newgrey
#'
#' @description Theme for ggplot
#' @param base_size Size of standard text, 12 by default.
#' @param ... Other variables that are allowed within 'theme' environment.
#' @import ggplot2
#' @export
theme_newgrey <- function(base_size = 12, ...){
  arguments <- list(
    ...,
    axis.line = element_line(colour = "black", size = 1),
    axis.text.x = element_text(size = 7/6 * base_size, color = 'grey40'),
    axis.text.y = element_text(size= 7/6 * base_size, color = 'grey40'),
    axis.title.x = element_text(size = 5/4 * base_size, color = 'grey20'),
    axis.title.y = element_text(size = 5/4 * base_size, angle = 90, vjust = 2.5, color = 'grey20'),
    axis.ticks = element_line(size = 1.5),
    axis.ticks.length = unit(1.5, "mm"),
    panel.background = element_rect(fill = "grey96"),
    panel.border = element_rect(colour = "gray82", fill = NA, size = 1.5),
    panel.grid.major = element_line(colour = "grey70", linetype = "dashed"),
    panel.grid.minor = element_line(colour = "grey70", linetype = "dashed"),
    plot.title = element_text(size = 3/2 * base_size, hjust = 0, face = 'bold', color = 'grey20'),
    plot.subtitle = element_text(size = 7/6 * base_size, hjust = 0, color = 'grey20'),
    plot.caption = element_text(size = 4/5 * base_size, hjust = 1, color = 'grey60'),
    legend.key = element_blank(),
    legend.background = element_rect(colour="gray80"),
    legend.position = 'top'
  )
  arguments <- arguments[!duplicated(names(arguments))]
  theme_grey() %+replace%
    do.call('theme', arguments)
}
