% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/randomdir.R
\name{randomdist}
\alias{randomdist}
\title{Return random step lengths}
\usage{
randomdist(n, shape, rate)
}
\arguments{
\item{n}{number of observations. If \code{length(n) > 1}, the length
    is taken to be the number required.}

\item{shape}{numeric, must be positive}

\item{rate}{an alternative way to specify the scale.}
}
\value{
n random step lengths
}
\description{
Return random step lengths
}
\seealso{
Other individual movement functions: 
\code{\link{potential_position_func}()},
\code{\link{randomdir}()},
\code{\link{simulate_trajectory_CPF}()},
\code{\link{simulate_trajectory_FR}()}
}
\concept{individual movement functions}
