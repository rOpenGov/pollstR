\name{huffpost_charts}
\alias{huffpost_charts}
\title{Get list of available charts}
\usage{
huffpost_charts(topic = NULL, state = NULL)
}
\arguments{
  \item{state}{Only include charts from a single state. Use
  2-letter state abbreviations. "US" will return all
  national charts.}

  \item{topic}{Only include charts related to a specific
  topic. See
  \url{http://elections.huffingtonpost.com/pollster/api}
  for examples.}
}
\value{
\code{"list"} with elements \describe{
\item{\code{charts}}{Data frame with data on charts.}
\item{\code{estimates}}{Data frame with current estimates
from each chart. The column \code{slug} matches this data
frame to \code{charts}} }
}
\description{
Get list of available charts
}

