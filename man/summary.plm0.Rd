% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plm_methods.R
\name{summary.plm0}
\alias{summary.plm0}
\alias{summary.plm}
\alias{summary.gplm0}
\alias{summary.gplm}
\title{Summary method for discharge rating curves}
\usage{
\method{summary}{plm0}(object, ...)

\method{summary}{plm}(object, ...)

\method{summary}{gplm0}(object, ...)

\method{summary}{gplm}(object, ...)
}
\arguments{
\item{object}{an object of class "plm0", "plm", "gplm0" or "gplm".}

\item{...}{Not used for this function}
}
\description{
Summarize a discharge rating curve model object
}
\section{Functions}{
\itemize{
\item \code{summary.plm0}: Summary method for plm0

\item \code{summary.plm}: Summary method for plm

\item \code{summary.gplm0}: Summary method for gplm0

\item \code{summary.gplm}: Summary method for gplm
}}

\examples{
\dontrun{
data(krokfors)
set.seed(1)
plm0.fit <- plm0(formula=Q~W,data=krokfors)
summary(plm0.fit)

# Formula:
# Q ~ W
# Latent parameters:
#   lower-2.5\% median-50\% upper-97.5\%
# a 1.16       1.64       2.12
# b 2.47       2.82       3.21
#
# Hyperparameters:
#           lower-2.5\% median-50\% upper-97.5\%
# c         7.58       7.676      7.750
# sigma_eps 0.15       0.191      0.251
#
# DIC: 23.37559
}
}
\seealso{
\code{\link{plm0}}, \code{\link{plm}}, \code{\link{gplm0}} and \code{\link{gplm}} for fitting a discharge rating curve. It is also useful to look at \code{\link{plot.plm0}}, \code{\link{plot.plm}}, \code{\link{plot.gplm0}} and \code{\link{plot.gplm}} to help visualize all aspects of the fitted discharge rating curve. Additionally, \code{\link{spread_draws}} and \code{\link{spread_draws}} help working directly with the MCMC samples.
}
