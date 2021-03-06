% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/auc.R
\name{confint.BuyseTestAuc}
\alias{confint.BuyseTestAuc}
\title{Extract the AUC value with its Confidence Interval}
\usage{
\method{confint}{BuyseTestAuc}(object, ...)
}
\arguments{
\item{object}{object of class \code{BuyseTestAUC} (output of the \code{auc} function).}

\item{...}{not used. For compatibility with the generic function.}
}
\value{
Estimated value for the AUC, its standard error, the lower and upper bound of the confidence interval and the p-value.
}
\description{
Extract the AUC value with its Confidence Interval and p-value testing whether the AUC equals 0.5.
}
