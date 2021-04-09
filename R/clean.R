#' clean
#'
#' @description Cleans the global environment, console and graphical device with an animation.
#' Purely for fun purposes.
#' @examples
#' clean()
#' @export
clean <- function(envir = parent.frame(), list.function = ls){
  broom.mid = paste0('\t\t\t\t\t',
                     c(rep('  ||\n',8), ' /||\\\n', '/||||\\\n', '======\n', rep('||||||\n', 3)))
  spaces = sapply( c(40, 38:26), function(x) paste0(rep(' ', x), collapse = ''))
  broom.left = c( paste0(spaces[1:8], rep('  //\n', 8)), paste0(spaces[8], '-//|\n'),
                  paste0(spaces[10], '-////|\n'), paste0(spaces[11], '======\n'),
                  paste0(spaces[12:14], rep('//////\n', 3)))
  spaces = sapply( c(40, 40:52), function(x) paste0(rep(' ', x), collapse = ''))
  broom.right = c( paste0(spaces[1:8], rep('\\\\\n', 8)), paste0(spaces[9], '|\\\\-\n'),
                   paste0(spaces[10], '|\\\\\\\\-\n'), paste0(spaces[11], '======\n'),
                   paste0(spaces[12:14], rep('\\\\\\\\\\\\\n', 3)))

  bin <- list.function(envir = envir)

  left = T
  while (length(bin) > 0){
    cat(rep('\n', 15))
    item = bin[1]
    next.item = ifelse(length(bin) > 1, bin[2], '')

    cat(broom.mid, '\n', rep('\t', ifelse(left == T, 3, 7)), item)
    Sys.sleep(0.35)
    cat(rep('\n', 15))
    if (left == T) {cat(broom.left, '\n', rep('\t', 7), next.item); left = F}
    else {cat(broom.right, '\n', rep('\t', 3), next.item); left = T}
    Sys.sleep(0.35)
    bin = bin[-1]
  }

  rm(list = list.function(envir = envir), envir = envir)
  graphics.off()
  cat("\014")
}
