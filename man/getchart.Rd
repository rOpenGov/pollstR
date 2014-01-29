\name{getchart}
\alias{getchart}
\alias{print.}
\title{Get a Pollster chart}
\description{Retrieve a specific pollster chart by \dQuote{slug} name}
\usage{
getchart(chart, fmt='json', \dots)
}
\arguments{
    \item{chart}{A character string containing the \dQuote{slug} name of a chart, possibly as returned by \code{\link{chartlist}}.}
    \item{fmt}{A character string specifying the structure of the API response. Allowed values are \dQuote{json} (the default) and \dQuote{xml}. Though similar, the return values for different formats contain slightly varying content and produce slightly different resulting objects (mostly in the classes of returned variables). If \dQuote{xml}, only basic information and overall estimates are retrieved about the chart. If \dQuote{json}, estimates by date are also returned.}
    \item{\dots}{Ignored.}
}
\value{A list of class \code{pollsterchart}, containing}
\author{
Thomas J. Leeper.

Maintainer: Thomas J. Leeper <thosjleeper@gmail.com>
}
\references{\url{http://elections.huffingtonpost.com/pollster/api}}
\keyword{ package }
\seealso{\code{\link{chartlist}}}
\examples{
dat <- getchart(chart='2012-virginia-senate-allen-vs-kaine')
}
