\name{pollstr_chart}
\alias{pollstr_chart}
\title{Return a single chart}
\usage{
pollstr_chart(slug, convert = TRUE)
}
\arguments{
  \item{slug}{The slug-name of the chart to be returned.}

  \item{convert}{Rearrange the data returned by the API
  into easier to use data frames.}
}
\value{
If \code{convert=TRUE}, then a \code{"pollstr_chart"}
object with elements \itemize{ \item \code{title} \item
\code{slug} \item \code{topic} \item \code{short_title}
\item \code{poll_count} \item \code{last_updated} \item
\code{url} \item \code{estimates} A data frame with an
observation for each choice and the current estimates.
\item \code{estimates_by_date} A data frame with an
observation for each choice at each date, with estimates. }
Otherwise, a \code{"list"} in the original structure of the
json returned by the API.
}
\description{
Return a single chart. This includes both current and
historical estimates by date.
}
\examples{
\dontrun{
chart1 <- pollstr_chart('2012-virginia-senate-allen-vs-kaine')
}
}

