#' NLDgem
#'
#' @description Generates a plot of the Netherlands where each municipality is
#' coloured according to some value, using a continuous scale.
#' @param stat Dataset containing the names of all Dutch municipalities in the
#' first column and the values of the variables of interest in the second column.
#' If no dataset is provided, municipalities will be coloured randomly.
#' @param varname Name of the variable of interest as shown above the legend.
#' @param getGEM If TRUE the functions returns a vector with all Dutch municipalities.
#' @param title,subtitle Title and subtitle of the plot. NULL if omitted.
#' @param copyright Adds a footnote with copyright sign and the string provided to the plot
#' @param mincol,maxcol Minimum and maximum values of the continuous colour scale
#' @param legendposition Place of the legend. Needs a vector of two numbers between
#' 0 and 1, where (0,0) is topright and (1,1) bottom left.
#' @param theme_add Change the theme of the plot by adding a theme() element.
#' @examples
#' NLDgem(stat = NULL, varname = 'random')
#' @import sf ggplot2 dplyr
#' @export
NLDgem <- function(stat = NULL, varname = 'value', getGEM = FALSE,
                   title = 'Kaart van Nederland', subtitle = NULL,
                   copyright = NULL, mincol = 'turquoise1' , maxcol = 'steelblue4',
                   legendposition = c(0.05,0.75), theme_add = theme()){
  # data over gemeente grenzen opgehaald
  gemeentegrenzen <- st_read("https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&service=WFS&version=2.0.0&typeName=cbs_gemeente_2020_gegeneraliseerd&outputFormat=json",
                             quiet = TRUE)
  gemeentegrenzen$statnaam <- as.character(gemeentegrenzen$statnaam)
  if (!is.null(copyright)){
    copyright <- paste("\uA9", as.character(copyright))
  }
  # random data als er geen dataset is
  if (is.null(stat)){
    data <- gemeentegrenzen %>%
      dplyr::mutate(value = runif(nrow(gemeentegrenzen), min = 0, max = 1000))
    if (getGEM){
      return(gemeentegrenzen$statnaam)
    }
  }

  # data in goede vorm
  else{
    if (getGEM){
      print('WARNING: dataset available, getGEM ignored')
    }

    names(stat) = c("name", "value")
    data <- gemeentegrenzen %>%
      left_join(stat, by=c(statnaam = "name"))
  }

  # plot kaart
  data %>%
    ggplot() +
    geom_sf(aes(fill = value)) +
    scale_fill_gradient(low = mincol, high = maxcol) +
    labs(title = title, subtitle = subtitle, fill = varname, caption = copyright) +
    theme_void() +
    theme(legend.position = legendposition) +
    theme_add
}
