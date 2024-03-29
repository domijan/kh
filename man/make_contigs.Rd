% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_contigs.R
\name{make_contigs}
\alias{make_contigs}
\title{Generate neighbourhood list or matrix, accounting for the presence of discontiguities}
\usage{
make_contigs(data, unit, link_islands_k = 0, modelling.package = "mgcv")
}
\arguments{
\item{data}{A simple features dataframe}

\item{unit}{The level (e.g. region, county) at which the neighbourhood structure operates}

\item{link_islands_k}{An integer value. The closest k units to isolated units will be represented as neighbours}

\item{modelling.package}{either "mgcv" (default) or "brms"}
}
\value{
A neighbourhood list of class "nb" for "mgcv" or a neighbourhood matrix for "brms"
}
\description{
Generate neighbourhood list or matrix, accounting for the presence of discontiguities
}
