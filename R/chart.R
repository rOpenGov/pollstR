# Create URL for the charts API method
huffpost_chart_url <- function(slug) {
    paste(.POLLSTR_API_URL, "charts", slug[1], sep="/")
}

# clean up the objects returned by the API
huffpost_chart_parse <- function(.data) {
    # Convert
    .data[["last_updated"]] <-
        as.POSIXct(.data[["last_updated"]],
                   format = "%Y-%m-%dT%H:%M:%SZ",
                   tz = "GMT")
    if (length(.data[["estimates"]])) {
        estimates <- ldply(.data[["estimates"]],
                           function(z) {
                               for (i in names(z)) {
                                   if (is.null(z[[i]])) {
                                       z[[i]] <- NA
                                   }
                               }
                               as.data.frame(z)
                           })
        .data[["estimates"]] <- estimates
    }
    if (length(.data[["estimates_by_date"]])) {
        .data[["estimates_by_date"]] <-
            ldply(.data[["estimates_by_date"]],
                  function(x) {
                      y <- ldply(x[["estimates"]], as.data.frame)
                      y[["date"]] <- as.Date(x[["date"]])
                      y
                  })
    }
    .data
}

#' Return a single chart
#'
#' Return a single chart. This includes both current and historical estimates by date.
#'
#' @param slug The slug-name of the chart to be returned.
#' @return \code{"list"} with elements
#' \itemize{
#' \item \code{title}
#' \item \code{slug}
#' \item \code{topic}
#' \item \code{short_title}
#' \item \code{poll_count}
#' \item \code{last_updated}
#' \item \code{url}
#' \item \code{estimates} A data frame with an observation for each choice and the current estimates.
#' \item \code{estimates_by_date} A data frame with an observation for each choice at each date, with estimates.
#' }
#' @export
huffpost_chart <- function(slug) {
    url <- huffpost_chart_url(slug)
    response <- GET(url)
    .data <- content(response, as = "parsed")
    huffpost_chart_parse(.data)
}

