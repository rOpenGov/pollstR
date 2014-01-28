\name{pollstR}
\alias{pollstR}
\alias{pollstR}
\title{Pull data from PollstR}
\description{Initial function by Drew Linzer}
\usage{
pollstR(chart="2012-general-election-romney-vs-obama", pages=1)
}
\arguments{
    \item{chart}{A character string naming a Pollster chart.}
    \item{pages}{Number of pages of poll results to read. 10 polls per page, default is 1 most recent page. If pages="all", reads in all polls for specified chart.}
}
\author{
Thomas J. Leeper, based on some initial work by Drew Linzer.

Maintainer: Thomas J. Leeper <thosjleeper@gmail.com>
}
\references{\url{http://elections.huffingtonpost.com/pollster/api}}
\keyword{ package }
%\seealso{}
\examples{
dat <- pollstR()

dat <- pollstR(chart="2012-virginia-senate-allen-vs-kaine",pages=5)

dat <- pollstR(chart="2012-california-president-romney-vs-obama",pages="all")
}
