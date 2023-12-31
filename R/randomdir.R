# WARNING - Generated by {fusen} from dev/flat_simulate_mvmt.Rmd: do not edit by hand

#' Return random direction angles
#'
#' @inheritParams circular::rwrappednormal 
#' @param kappa numeric, sd parameter
#'
#' @importFrom circular rwrappednormal 
#'
#' @return n random angles
#' @export
#' @family individual movement functions
#'
randomdir <- function(n,mu,kappa){
  out <- circular::rwrappednormal(10, mu = circular::circular(mu, units = "degrees", 
                                                              template = "geographic"),
                                 sd = kappa, control.circular = list()) %% 360
  return(as.double(out))
}

#' Return random step lengths
#'
#' @inheritParams stats::rgamma 
#' @param shape numeric, must be positive
#' 
#' @importFrom stats rgamma 
#'
#' @return n random step lengths
#' @export
#' @family individual movement functions
#'
randomdist <- function(n, shape, rate){
  out <- stats::rgamma(n, shape, rate)
  return(out)
}
