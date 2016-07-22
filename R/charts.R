# Create URL for the charts API method
pollstr_charts_url <- function(page, topic, state, showall) {
  query <- list()
  query[["topic"]] <- q_param_integer(page)
  query[["topic"]] <- q_param_character(topic)
  query[["state"]] <- q_param_character(state)
  query[["showall"]] <- q_param_logical(showall)
  make_api_url("charts", query)
}

# clean up the objects returned by the API
charts2df <- function(.data) {
  clean_charts <- function(x) {
    x[["estimates"]] <- NULL
    if (is.null(x[["topic"]])) {
      x[["topic"]] <- ""
    }
    x[["election_date"]] <- electiondate2date(x[["election_date"]])
    x <- convert_df(x)  

  }
  charts <- ldply(.data, clean_charts)
  # Convert
  charts[["last_updated"]] <-
        as.POSIXct(charts[["last_updated"]],
                   format = "%Y-%m-%dT%H:%M:%OSZ",
                   tz = "GMT")
  clean_estimates <- function(x) {
    if (length(x[["estimates"]])) {
      y <- map_df(x[["estimates"]], convert_df)
      y[["slug"]] <- x[["slug"]]
      y
    } else {
      NULL
    }
  }
  estimates <- map_df(.data, clean_estimates)
  structure(list(charts = charts, estimates = estimates),
            class = c("pollstr_charts"))
}


#' Get list of available charts
#'
#' @param page 
#' @param state Only include charts from a single state. Use 2-letter state abbreviations. "US" will return all national charts.
#' @param topic Only include charts related to a specific topic. See \url{http://elections.huffingtonpost.com/pollster/api} for examples.
#' @param showall logical Include charts for races that were once possible but didn't happen (e.g. Gingrich vs. Obama 2012)
#' @param convert Rearrange the data returned by the API into easier to use data frames.
#'
#' @references \url{http://elections.huffingtonpost.com/pollster/api}
#' @return If \code{convert=TRUE}, a \code{"pollstr_charts"} object with elements
#' \describe{
#'   \item{\code{charts}}{Data frame with data on charts.}
#'   \item{\code{estimates}}{Data frame with current estimates from each chart. The column \code{slug} matches this data frame to \code{charts}}
#' }
#' Otherwise, a \code{"list"} in the original structure of the json returned by the API.
#' @examples
#' \dontrun{
#'  # Get charts related to Washington
#'  wa <- pollstr_charts(state='WA')
#'  # Get national charts
#'  us_charts <- pollstr_charts(state='US')
#'  # Get charts in the topic '2016-president'
#'  gov <- pollstr_charts(topic='2016-president')
#'  # Get all charts
#'  allcharts <- pollstr_charts()
#' }
#' @export
pollstr_charts <- function(page = 1, topic = NULL, state = NULL, showall = NULL,
                           convert = TRUE, max_page = 1) {
  get_page <- function(page) {
    get_url(pollstr_charts_url(page = page, topic, state, showall),
            as = "parsed")
  }
  .data <- iterpages(get_page, page, max_page)
  .data
}


#' @export
print.pollstr_charts <- function(x, ...) {
  print(x[["charts"]][ , c('title', 'slug', 'state', 'poll_count', 'last_updated')])
  return(invisible(x))
}
