#' theme_notepad
#'
#' @description Theme for ggplot
#' @param base_size Size of standard text, 12 by default.
#' @param font Font used in theme, 'mono' by default.
#' @param bg.colour Background color used in theme.
#' @param void Boolean variable indiciting whether grid is visible or not.
#' @param ... Other variables that are allowed within 'theme' environment.
#' @import ggplot2
#' @export

theme_notepad <- function(base_size = 12, font = 'mono', bg.colour ='#fffef7',  void = FALSE, ...){
  arguments <- list(
    ...,
    axis.line.x = element_line(colour = 'grey30', size = 1.2),
    axis.ticks = element_blank(),
    axis.title.x = element_text(size = 7/6 * base_size, vjust = -1),
    axis.title.y = element_text(size = 7/6 * base_size, vjust = 3, angle = 90),
    axis.text = element_text(size = base_size, color = 'grey60'),
    legend.position = 'top',
    legend.background = element_blank(),
    legend.key = element_rect( fill = bg.colour, colour = bg.colour),
    panel.background = element_blank(),
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(colour = ifelse(void, bg.colour, 'grey30'), linetype = 'dotted'),
    panel.grid.minor = element_blank(),
    plot.background = element_rect( fill = bg.colour, color = bg.colour),
    plot.title = element_text(size = 5/3 * base_size, face = 'bold', hjust = 0, vjust = 2),
    plot.subtitle = element_text(size = 7/6 * base_size, color = 'grey50', hjust = 0),
    plot.caption = element_text(size = 5/6 * base_size, color = 'grey60', hjust = 1, vjust = -2),
    plot.margin = margin( t = 0.4, r = 1, b = 0.4, l = 1, 'cm'),
    text = element_text( family = font, color = 'gray40')
  )
  arguments <- arguments[!duplicated(names(arguments))]
  theme_grey() %+replace%
    do.call('theme', arguments)
}
