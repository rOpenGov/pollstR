\name{pollster_polls}
\alias{pollster_polls}
\title{Get a list of polls}
\usage{
pollster_polls(page = 1, chart = NULL, state = NULL, topic = NULL,
  before = NULL, after = NULL, sort = FALSE, npages = 1)
}
\arguments{
  \item{page}{Return page number}

  \item{chart}{List polls related to the specified chart.
  Chart names are the \code{slug} returned by
  \code{pollster_charts}.}

  \item{state}{Only include charts from a single state. Use
  2-letter pstate abbreviations. "US" will return all
  national charts.}

  \item{topic}{Only include charts related to a specific
  topic. See the
  \url{http://elections.huffingtonpost.com/pollster/api}
  for examples.}

  \item{before}{Only list polls that ended on or bfore the
  specified date.}

  \item{after}{Only list polls that ended on or bfore the
  specified date.}

  \item{sort}{If \code{TRUE}, then sort polls by the last
  updated time.}

  \item{npages}{Number of pages to get. Each page contains
  10 polls.}
}
\description{
Get a list of polls
}

