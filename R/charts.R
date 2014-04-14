#'@include pollster-package.R
NULL

# Create URL for the charts API method
pollster_charts_url <- function(topic, state) {
    query <- list()
    if (! is.null(topic)) {
        query[["topic"]] <- as.character(topic)[1]
    }
    if (! is.null(state)) {
        query[["state"]] <- as.character(state)[1]
    }
    if (! length(query)) {
        query <- NULL
    }
    modify_url(paste(.POLLSTR_API_URL, "charts", sep="/"), query = query)
}

# clean up the objects returned by the API
pollster_charts_parse <- function(.data) {
    charts <- ldply(.data, function(x) {
        x[["estimates"]] <- NULL
        if (is.null(x[["topic"]])) {
            x[["topic"]] <- ""
        }
        as.data.frame(x)
    })
    # Convert
    charts[["last_updated"]] <-
        as.POSIXct(charts[["last_updated"]],
                   format = "%Y-%m-%dT%H:%M:%SZ",
                   tz = "GMT")
    estimates <- ldply(.data,
                       function(x) {
                           if (length(x[["estimates"]])) {
                               y <- ldply(x[["estimates"]],
                                          function(z) {
                                              for (i in names(z)) {
                                                  if (is.null(z[[i]])) {
                                                      z[[i]] <- NA
                                                  }
                                              }
                                              as.data.frame(z)
                                          })
                               y[["slug"]] <- x[["slug"]]
                               y
                           }
                       })
    list(charts = charts, estimates = estimates)
}

#' Get list of available charts
#'
#' @param state Only include charts from a single state. Use 2-letter state abbreviations. "US" will return all national charts.
#' @param topic Only include charts related to a specific topic. See \url{http://elections.huffingtonpost.com/pollster/api} for examples.
#'
#' @return \code{"list"} with elements
#' \describe{
#'   \item{\code{charts}}{Data frame with data on charts.}
#'   \item{\code{estimates}}{Data frame with current estimates from each chart. The column \code{slug} matches this data frame to \code{charts}}
#' }
#' @export
pollster_charts <- function(topic = NULL, state = NULL) {
    .data <- get_url(pollster_charts_url(topic, state), as = "parsed")
    pollster_chart_parse(.data)
}

