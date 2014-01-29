\name{chartlist}
\alias{chartlist}
\alias{print.pollsterchartlist}
\title{Available Pollster charts}
\description{Pull list of available Pollster Charts}
\usage{
chartlist(topic=NULL, state=NULL, topic_check=TRUE, fmt='json', \dots)
}
\arguments{
    \item{topic}{A character string containing a valid poll topic. Currently one of \dQuote{obama-job-approval}, \dQuote{2016-president}, \dQuote{2016-gop-primary}, \dQuote{2014-senate}, \dQuote{2014-house}, \dQuote{2014-governor}, \dQuote{2013-senate}, \dQuote{2013-house}, \dQuote{2013-governor}, \dQuote{2012-senate}, \dQuote{2012-president}, \dQuote{2012-house}, \dQuote{2012-governor}, \dQuote{2012-gop-primary}.}
    \item{state}{A two-letter character string specifying the name of a specific state to query. Specifying \dQuote{US} will return national charts only. If \code{NULL} (the default), return all charts.}
    \item{topic_check}{A logical specifying whether to check the supplied topic against the list of allowed topics. Provided for forward compatibility.}
    \item{fmt}{A character string specifying the structure of the API response. Allowed values are \dQuote{json} (the default) and \dQuote{xml}. Though similar, the return values for different formats contain slightly varying content and produce slightly different resulting objects (mostly in the classes of returned variables).}
    \item{\dots}{Ignored.}
}
\value{A dataframe of class \code{pollsterchartlist}, describing all available charts. One column of the dataframe is, a possibly empty, \code{estimates} variable, which is itself a list of named dataframes, each of which (possibly) contains aggregated poll estimates for each charts.}
\author{
Thomas J. Leeper.

Maintainer: Thomas J. Leeper <thosjleeper@gmail.com>
}
\references{\url{http://elections.huffingtonpost.com/pollster/api}}
\keyword{ package }
\seealso{\code{\link{getchart}}}
\examples{
mn <- chartlist(state='MN')

gov <- chartlist(topic='2013-governor')

\dontrun{
allcharts <- chartlist()
}
}
