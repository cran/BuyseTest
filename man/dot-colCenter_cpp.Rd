% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{.colCenter_cpp}
\alias{.colCenter_cpp}
\title{Substract a vector of values in each column}
\usage{
.colCenter_cpp(X, center)
}
\arguments{
\item{X}{A matrix.}

\item{center}{A vector with length the number of rows of X .}
}
\value{
A matrix of same size as x.
}
\description{
Fast computation of sweep(X, FUN = "-", STATS = center, MARGIN = 1)
}
\keyword{utilities}
