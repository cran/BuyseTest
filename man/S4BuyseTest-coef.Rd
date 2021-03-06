% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/S4-BuyseTest-coef.R
\docType{methods}
\name{S4BuyseTest-coef}
\alias{S4BuyseTest-coef}
\alias{coef,S4BuyseTest-method}
\title{Coef Method for Class "S4BuyseTest"}
\usage{
\S4method{coef}{S4BuyseTest}(object, statistic = NULL, stratified = FALSE, cumulative = TRUE, ...)
}
\arguments{
\item{object}{output of \code{\link{BuyseTest}}}

\item{statistic}{[character] the type of summary statistic. See the detail section.}

\item{stratified}{[logical] should the summary statistic be strata-specific?
Otherwise a summary statistic over all strata is returned.}

\item{cumulative}{[logical] should the score be cumulated over endpoints?
Otherwise display the contribution of each endpoint.}

\item{...}{ignored.}
}
\description{
Extract summary statistics from the result of a \code{\link{BuyseTest}} function.
}
\details{
One of the following statistic can be specified:
\itemize{
\item \code{"netBenefit"}: returns the net benefit.
\item \code{"winRatio"}: returns the win ratio.
\item \code{"favorable"}: returns the proportion in favor of the treatment (also called Mann-Whitney parameter).
\item \code{"unfavorable"}: returns the proportion in favor of the control.
\item \code{"count.favorable"}: returns the number of pairs in favor of the treatment.
\item \code{"count.unfavorable"}: returns the number of pairs in favor of the control.
\item \code{"count.neutral"}: returns the number of neutral pairs.
\item \code{"count.uninf"}: returns the number of uninformative pairs.
\item \code{"pc.favorable"}: returns the percentage of pairs in favor of the treatment, i.e. \eqn{P[X \geq Y + \tau]}.
\item \code{"pc.unfavorable"}: returns the percentage of pairs in favor of the control, i.e. \eqn{P[Y \geq X + \tau]}.
\item \code{"pc.neutral"}: returns the percentage of neutral pairs.
\item \code{"pc.uninf"}: returns the percentage of uninformative pairs.
}
}
\author{
Brice Ozenne
}
\keyword{S4BuyseTest-method}
\keyword{coef}
