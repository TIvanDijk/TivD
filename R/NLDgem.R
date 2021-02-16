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
                   title = waiver(), subtitle = NULL,
                   copyright = NULL, mincol = 'turquoise1' , maxcol = 'steelblue4',
                   legendposition = c(0.05,0.75), theme_add = theme(), na.color = 'grey',
                   legend.breaks = waiver(), prov.seperate = NULL){
  #check arguments
  if (!is.null(stat)){
    if  (nrow(stat) != 352) stop("Dataset needs to be of length 352")
    if (ncol(stat) != 2) stop("Dataset needs to have two columns. One with names of municipalities, one with associated values.")
  }

  # random data als er geen dataset is
  if (getGEM){return(GPdata$gem)}
  else if (is.null(stat)){
    data <- GPdata %>%
      dplyr::mutate(value = runif(nrow(GPdata), min = 0, max = 1000))
  }

  # data in goede vorm
  else{
    names(stat) = c("name", "value")
    data <- GPdata %>%
      left_join(stat, by=c(gem = "name"))
    if (sum(is.na(data$value)) != 0){
      warning(paste('Missing values for',sum(is.na(data$value)), 'municipalities'))
    }
  }

  # plot kaart
  if (!is.null(copyright)){copyright <- paste("\uA9", as.character(copyright))}

  if (!is.null(prov.seperate)){
    data %>%
      filter( prov %in% prov.seperate) %>%
      ggplot() +
      geom_sf( aes(geometry = gem.geometry, fill = value)) +
      scale_fill_gradient(low = mincol, high = maxcol, breaks = legend.breaks,
                          na.value = na.color) +
      labs(title = title, subtitle = subtitle, fill = varname, caption = copyright) +
      theme_void() +
      theme(legend.position = legendposition) +
      theme_add
  }
  else{
    data %>%
      ggplot() +
      geom_sf(aes(geometry = gem.geometry, fill = value)) +
      scale_fill_gradient(low = mincol, high = maxcol, breaks = legend.breaks,
                          na.value = na.color) +
      labs(title = title, subtitle = subtitle, fill = varname, caption = copyright) +
      theme_void() +
      theme(legend.position = legendposition) +
      theme_add
  }
}
