# WARNING - Generated by {fusen} from dev/flat_simulate_sp.Rmd: do not edit by hand

#' Custom rpoispp
#' 
#' Description
#' @import spatstat
#' @importFrom stats rpois
#' @importFrom stats runif
#' 
#' 
#' @noRd
rpoispp_custom <- function (lambda, lmax = NULL, win = spatstat.geom::owin(), ..., nsim = 1, 
          drop = TRUE, ex = NULL, warnwin = TRUE, N) 
{
  if (!missing(nsim)) {
    spatstat.utils::check.1.integer(nsim)
    stopifnot(nsim >= 1)
  }
  if (missing(lambda) && is.null(lmax) && missing(win) && 
      !is.null(ex)) {
    lambda <- spatstat.geom::intensity(spatstat.geom::unmark(ex))
    win <- spatstat.geom::Window(ex)
  }
  else {
    if (!(is.numeric(lambda) || is.function(lambda) || spatstat.geom::is.im(lambda))) 
      stop(paste(sQuote("lambda"), "must be a constant, a function or an image"))
    if (is.numeric(lambda) && !(length(lambda) == 1 && lambda >= 
                                0)) 
      stop(paste(sQuote("lambda"), "must be a single, nonnegative number"))
    if (!is.null(lmax)) {
      if (!is.numeric(lmax)) 
        stop("lmax should be a number")
      if (length(lmax) > 1) 
        stop("lmax should be a single number")
    }
    if (spatstat.geom::is.im(lambda)) {
      if (warnwin && !missing(win)) 
        warning("Argument win ignored", call. = FALSE)
      win <- spatstat.geom::rescue.rectangle(spatstat.geom::as.owin(lambda))
    }
    else {
      win <- spatstat.geom::as.owin(win)
    }
  }
  if (is.numeric(lambda)) 
    return(spatstat.random::runifpoispp(lambda, win, nsim = nsim, drop = drop))
  if (is.null(lmax)) {
    imag <- spatstat.geom::as.im(lambda, win, ...)
    summ <- summary(imag)
    lmax <- summ$max + 0.05 * diff(summ$range)
  }
  if (is.function(lambda)) {
    result <- spatstat.random::runifpoispp(lmax, win, nsim = nsim, drop = FALSE)
    for (isim in 1:nsim) {
      X <- result[[isim]]
      if (X$n > 0) {
        prob <- lambda(X$x, X$y, ...)/lmax
        u <- runif(X$n)
        retain <- (u <= prob)
        result[[isim]] <- X[retain]
      }
    }
    if (nsim == 1 && drop) 
      result <- result[[1L]]
    return(result)
  }
  if (spatstat.geom::is.im(lambda)) {
    if (spatstat.geom::spatstat.options("fastpois")) {
      # mu <- integral(lambda)
      mu <- N
      dx <- lambda$xstep/2
      dy <- lambda$ystep/2
      df <- as.data.frame(lambda)
      npix <- nrow(df)
      lpix <- df$value
      result <- vector(mode = "list", length = nsim)
      nn <- stats::rpois(nsim, mu)
      if (!all(is.finite(nn))) 
        stop(paste("Unable to generate Poisson process with a mean of", 
                   mu, "points"))
      for (isim in seq_len(nsim)) {
        ni <- nn[isim]
        ii <- sample.int(npix, size = ni, replace = TRUE, 
                         prob = lpix)
        xx <- df$x[ii] + stats::runif(ni, -dx, dx)
        yy <- df$y[ii] + stats::runif(ni, -dy, dy)
        result[[isim]] <- spatstat.geom::ppp(xx, yy, window = win, 
                              check = FALSE)
      }
      result <- spatstat.geom::simulationresult(result, nsim, drop)
      return(result)
    }
    else {
      result <- spatstat.random::runifpoispp(lmax, win, nsim = nsim, drop = FALSE)
      for (isim in 1:nsim) {
        X <- result[[isim]]
        if (X$n > 0) {
          prob <- lambda[X]/lmax
          u <- stats::runif(X$n)
          retain <- (u <= prob)
          result[[isim]] <- X[retain]
        }
      }
      if (nsim == 1 && drop) 
        return(result[[1L]])
      return(result)
    }
  }
  stop(paste(sQuote("lambda"), "must be a constant, a function or an image"))
}
