\name{huffpost_chart}
\alias{huffpost_chart}
\title{Return a single chart}
\usage{
huffpost_chart(slug)
}
\arguments{
  \item{slug}{}
}
\value{
\code{"list"} with elements \itemize{ \item \code{title}
\item \code{slug} \item \code{topic} \item
\code{short_title} \item \code{poll_count} \item
\code{last_updated} \item \code{url} \item \code{estimates}
A data frame with an observation for each choice and the
current estimates. \item \code{estimates_by_date} A data
frame with an observation for each choice at each date,
with estimates. }
}
\description{
Return a single chart
}

