# WARNING - Generated by {fusen} from dev/flat_utils.Rmd: do not edit by hand

#' Normalize a vector
#'
#' @param cov a vector
#' 
#' @return a vector
#' @export
#' @examples
#' normalize(c(1:5))
normalize <- function(cov){ (cov-min(cov))/(max(cov)-min(cov)) }
# normalize <- function(cov){ cov/max(cov) }
