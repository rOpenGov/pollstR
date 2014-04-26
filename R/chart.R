#'@include pollstr-package.R
NULL

# Create URL for the charts API method
pollstr_chart_url <- function(slug) {
    paste(.POLLSTR_API_URL, "charts", slug[1], sep="/")
}

# clean up the objects returned by the API
pollstr_chart_parse <- function(.data) {
    # Convert
    .data[["election_date"]] <-
        as.Date(electiondate2date(.data[["election_date"]]),
                "%Y-%m-%d")
    .data[["last_updated"]] <-
        as.POSIXct(.data[["last_updated"]],
                   format = "%Y-%m-%dT%H:%M:%SZ",
                   tz = "GMT")
    if (length(.data[["estimates"]])) {
        estimates <- ldply(.data[["estimates"]], convert_df)
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
#' @param convert Rearrange the data returned by the API into easier to use data frames.
#' @return If \code{convert=TRUE}, then a \code{"list"} with elements
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
#' Otherwise, a \code{"list"} in the original structure of the json returned by the API.
#' @export
pollstr_chart <- function(slug, convert=TRUE) {
    .data <- get_url(pollstr_chart_url(slug), as = "parsed")
    if (convert) .data <- pollstr_chart_parse(.data)
    .data
}

