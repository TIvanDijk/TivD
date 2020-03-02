#' setwd_here()
#'
#' @description Shortcut for setting the working directory  to the map where the
#' current file is located.
#' @examples
#' setwd_here()
#' @import rstudioapi
#' @export
setwd_here <- function(){
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}
