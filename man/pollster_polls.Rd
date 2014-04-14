\name{pollster_polls}
\alias{pollster_polls}
\title{Get a list of polls}
\usage{
pollster_polls(page = 1, chart = NULL, state = NULL, topic = NULL,
  before = NULL, after = NULL, sort = FALSE, max_pages = 1,
  convert = TRUE)
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

  \item{max_pages}{Maximum number of pages to get.}

  \item{convert}{Rearrange the data returned by the API
  into easier to use data frames.}
}
\value{
If \code{convert=TRUE}, a \code{list} with elements
\describe{ \item{\code{polls}}{A \code{data.frame} with
entries for each poll.} \item{\code{questions}}{A
\code{data.frame} with entries for each question asked in
the polls.} } Otherwise, a \code{"list"} in the original
structure of the json returned by the API.
}
\description{
Get a list of polls
}

