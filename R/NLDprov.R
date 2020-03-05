#' NLDprov
#'
#' @description Generates a plot of the Netherlands where each province is
#' coloured according to some value, using a continuous scale.
#' @param stat Dataset containing the names of all Dutch provinces in the
#' first column and the values of the variables of interest in the second column.
#' If no dataset is provided, provinces will be coloured randomly.
#' @param varname Name of the variable of interest as shown above the legend.
#' @param getGEM If TRUE the functions returns a vector with all Dutch provinces
#' @param title,subtitle Title and subtitle of the plot. NULL if omitted.
#' @param copyright Adds a footnote with copyright sign and the string provided to the plot
#' @param mincol,maxcol Minimum and maximum values of the continuous colour scale
#' @param legendposition Place of the legend. Needs a vector of two numbers between
#' 0 and 1, where (0,0) is topright and (1,1) bottom left.
#' @param theme_add Change the theme of the plot by adding a theme() element.
#' @examples
#' NLDprov(stat = NULL, varname = 'random')
#' @import sf ggplot2 dplyr
#' @export
NLDprov <- function(stat = NULL, varname = 'value' ,getPROV = FALSE,
                    title = 'Kaart van Nederland', subtitle = NULL,
                    copyright = NULL, mincol = 'turquoise1' , maxcol = 'steelblue4',
                    legendposition = c(0.05,0.75), theme_add = theme(), legend.breaks = waiver()){
  #check arguments
  if (!is.null(stat)){
    if  (nrow(stat) != 12) stop("Dataset needs to be of length 12")
    if (ncol(stat) != 2) stop("Dataset needs to have two columns. One with names of provinces, one with associated values.")
  }

  # collect data on provinces
  provgrenzen <- st_read("https://geodata.nationaalgeoregister.nl/cbsgebiedsindelingen/wfs?request=GetFeature&service=WFS&version=2.0.0&typeName=cbs_provincie_2020_gegeneraliseerd&outputFormat=json",
                         quiet = TRUE)
  provgrenzen$statnaam = as.character(provgrenzen$statnaam)
  # prepare dataset
  if (getPROV){return(provgrenzen$statnaam)}
  else if (is.null(stat) ){
    data <- provgrenzen %>%
      dplyr::mutate(value = runif(nrow(provgrenzen), min = 1, max = 10))
  }

  else{
    names(stat) = c("name", "value")
    data <- provgrenzen %>%
      left_join(stat, by=c(statnaam = "name"))
    if (sum(is.na(data$value)) != 0){
      warning(paste('Missing values for',sum(is.na(data$value)), 'provinces'))
      }
  }
  # plot map
  if (!is.null(copyright)){copyright <- paste("\uA9", as.character(copyright))}

  data %>%
    ggplot() +
    geom_sf(aes(fill = value)) +
    scale_fill_gradient(low = mincol, high = maxcol, breaks = legend.breaks) +
    labs(title = title, subtitle = subtitle, fill = varname, caption = copyright ) +
    theme_void() +
    theme(legend.position = legendposition) +
    theme_add
}
