\name{getpolls}
\alias{getpolls}
\title{Available Pollster polls}
\description{Pull available Pollster polls}
\usage{
getpolls(chart=NULL, topic=NULL, state=NULL, 
         before=NULL, after=NULL, sort=TRUE,
         topic_check=TRUE, return_all=TRUE, page=NULL,
         fmt='json', ...)
}
\arguments{
    \item{chart}{A character string containing the \dQuote{slug} name of a chart, possibly as returned by \code{\link{chartlist}}.}
    \item{topic}{A character string containing a valid poll topic. Currently one of \dQuote{obama-job-approval}, \dQuote{2016-president}, \dQuote{2016-gop-primary}, \dQuote{2014-senate}, \dQuote{2014-house}, \dQuote{2014-governor}, \dQuote{2013-senate}, \dQuote{2013-house}, \dQuote{2013-governor}, \dQuote{2012-senate}, \dQuote{2012-president}, \dQuote{2012-house}, \dQuote{2012-governor}, \dQuote{2012-gop-primary}.}
    \item{state}{A two-letter character string specifying the name of a specific state to query. Specifying \dQuote{US} will return national charts only. If \code{NULL} (the default), return all charts.}
    \item{before}{A character string specifying a date in \code{YYYY-MM-DD} format. Only list polls that ended on or before the specified date.}
    \item{after}{A character string specifying a date in \code{YYYY-MM-DD} format. Only list polls that ended on or after the specified date.}
    \item{sort}{Sort polls by last updated time (Useful for seeing what has changed since the last time you looked).}
    \item{topic_check}{A logical specifying whether to check the supplied topic against the list of allowed topics. Provided for forward compatibility.}
    \item{return_all}{A logical specifying whether to return all polls that meet the other specified criteria. Default is \code{TRUE}. Alternatively, one can specify a specific page of results.}
    \item{page}{A single, positive numeric value specifying a page of results to return. Results are returned in pages of 10 polls.}
    \item{fmt}{A character string specifying the structure of the API response. Allowed values are \dQuote{json} (the default) and \dQuote{xml}. Though similar, the return values for different formats contain slightly varying content and produce slightly different resulting objects (mostly in the classes of returned variables).}
    \item{\dots}{Ignored.}
}
%\value{}
\author{
Thomas J. Leeper, based on an earlier function, \code{pollstR} by Drew Linzer.

Maintainer: Thomas J. Leeper <thosjleeper@gmail.com>
}
\references{\url{http://elections.huffingtonpost.com/pollster/api}}
\keyword{ package }
\seealso{
\code{\link{chartlist}}

\code{\link{getchart}}
}
\examples{
\dontrun{
a <- chartlist()
getpolls(chart=a$charts$slug[1])
getpolls(topic='2016-gop-primary')
}
}
