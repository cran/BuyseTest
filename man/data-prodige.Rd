% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/doc-data.R
\docType{data}
\name{prodige}
\alias{prodige}
\title{RCT In Metastatic Pancreatic Cancer Comparing Two Chemoterapy.}
\format{
An object of class \code{data.table} (inherits from \code{data.frame}) with 823 rows and 8 columns.
}
\usage{
data(prodige, package = "BuyseTest")
}
\description{
Simulated data inspired from the PRODIGE trial comparing the survival of patients with metastatic pancreatic cancer
treated with FOLFIRINOX or gemcitabine . 

\itemize{
\item \code{id}: study participant.
\item \code{treatment}: treatment arm: FOLFIRINOX (T) or gemcitabine (C).
\item \code{OS}: time from inclusion (say diagnosis) to end of follow-up.
\item \code{statusOS}: event triggering the end of follow-up: death (1), drop-out (0).
\item \code{PFS}: time from inclusion (say diagnosis) to progression of the disease or end of follow-up.
\item \code{statusPFS}: progression (1) or end of follow-up (0).
\item \code{toxicity}: most serious side effect observed during the follow-up (1 mild, 6 severe).
\item \code{sex}: male (M) or female (F)
}
}
\references{
Conroy, Thierry, et al. "FOLFIRINOX versus gemcitabine for metastatic pancreatic cancer" New England Journal of Medicine (2011) 364(19):1817-25. doi: 10.1056/NEJMoa1011923.
}
\author{
Brice Ozenne
}
\keyword{datasets}
