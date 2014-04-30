#'@include pollstr-package.R
NULL

# Create URL for the charts API method
pollstr_charts_url <- function(topic, state) {
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
charts2df <- function(.data) {
    charts <- ldply(.data, function(x) {
        x[["estimates"]] <- NULL
        if (is.null(x[["topic"]])) {
            x[["topic"]] <- ""
        }
        x[["election_date"]] <-
            as.Date(electiondate2date(x[["election_date"]]),
                    "%Y-%m-%d")
        as.data.frame(x)
    })
    # Convert
    charts[["last_updated"]] <-
        as.POSIXct(charts[["last_updated"]],
                   format = "%Y-%m-%dT%H:%M:%SZ",
                   tz = "GMT")
    for (i in c("url", "title", "slug", "topic",
                "short_title")) {
        charts[[i]] <- as.character(charts[[i]])
    }
    for (i in c("poll_count")) {
        charts[[i]] <- as.integer(charts[[i]])
    }
    
    estimates <- ldply(.data,
                       function(x) {
                           if (length(x[["estimates"]])) {
                               y <- ldply(x[["estimates"]], convert_df)
                               y[["slug"]] <- x[["slug"]]
                               y
                           }
                       })

    # Convert estimates
    for (i in c("choice", "first_name", "last_name", "slug")) {
        estimates[[i]] <- as.character(estimates[[i]])
    }
    for (i in c("party")) {
        estimates[[i]] <- as.factor(estimates[[i]])
    }
    structure(list(charts = charts, estimates = estimates),
              class = c("pollstr_charts"))
}

#' Get list of available charts
#'
#' @param state Only include charts from a single state. Use 2-letter state abbreviations. "US" will return all national charts.
#' @param topic Only include charts related to a specific topic. See \url{http://elections.huffingtonpost.com/pollstero/api} for examples.
#' @param convert Rearrange the data returned by the API into easier to use data frames.
#'
#' @return If \code{convert=TRUE}, a \code{"pollstr_charts"} object with elements
#' \describe{
#'   \item{\code{charts}}{Data frame with data on charts.}
#'   \item{\code{estimates}}{Data frame with current estimates from each chart. The column \code{slug} matches this data frame to \code{charts}}
#' }
#' Otherwise, a \code{"list"} in the original structure of the json returned by the API.
#' @examples
#' \dontrun{
#' # Get charts related to Minnesota
#'  mn <- pollstr_charts(state='MN')
#'  # Get charts in the topic '2013-governor'
#'  gov <- pollstr_charts(topic='2013-governor')
#'  # Get all charts
#'  allcharts <- pollstr_charts()
#' }
#' @export
pollstr_charts <- function(topic = NULL, state = NULL, convert = TRUE) {
    .data <- get_url(pollstr_charts_url(topic, state), as = "parsed")
    if (convert) .data <- charts2df(.data)
    .data
}


#' @export
print.pollstr_charts <- function(x, ...) {
    print(x$charts[,c('title','slug','state','poll_count','last_updated')])
    return(invisible(x))
}
