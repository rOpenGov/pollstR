# Create URL for the charts API method
pollster_charts_url <- function(page, topic, state, showall) {
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
    x <- convert_df(x)
  }
  charts <- map_df(.data, clean_charts)
  # Convert
  for (i in "last_updated") {
    charts[[i]] <- as.POSIXct(charts[[i]], tz = "UCT")
  }
  for (i in c("election_date")) {
    charts[[i]] <- as.Date(charts[[i]], "%Y-%m-%d")
  }
  charts <- select_(charts, ~ id, ~ slug, ~ everything())
  clean_estimates <- function(x) {
    if (length(x[["estimates"]]) > 0) {
      y <- map_df(x[["estimates"]], function(.) {
        ret <- convert_df(.)
        ret
      })
      y[["slug"]] <- x[["slug"]]
      select_(y, ~slug, ~everything())
    } else {
      NULL
    }
  }
  estimates <- map_df(.data, clean_estimates)

  structure(list(charts = charts,
                 estimates = estimates),
            class = c("pollster_charts"))
}

get_charts_page <- function(page, topic, state, showall, as = "parsed") {
  url <- pollster_charts_url(page, topic, state, showall)
  get_url(url, as = as)
}

#' Get list of available charts
#'
#' @param page Page to get. The API returns results in pages of 100.
#' @param state Only include charts from a single state. Use 2-letter state abbreviations. "US" will return all national charts.
#' @param topic Only include charts related to a specific topic. See \url{http://elections.huffingtonpost.com/pollster/api} for examples.
#' @param showall logical Include charts for races that were once possible but didn't happen (e.g. Gingrich vs. Obama 2012)
#' @param convert Rearrange the data returned by the API into easier to use data frames.
#' @param max_pages Maximum number of pages to get.
#'
#' @references \url{http://elections.huffingtonpost.com/pollster/api}
#' @return If \code{convert=TRUE}, a \code{"pollster_charts"} object with elements
#' \describe{
#'   \item{\code{charts}}{Data frame with data on charts.}
#'   \item{\code{estimates}}{Data frame with current estimates from each chart. The column \code{slug} matches this data frame to \code{charts}}
#' }
#' Otherwise, a \code{"list"} in the original structure of the json returned by the API.
#' @examples
#' \dontrun{
#'  # Get charts related to Washington
#'  pollster_charts(state = 'WA')
#'  # Get national charts
#'  pollster_charts(state='US')
#'  # Get charts for the topic '2016-president'
#'  pollster_charts(topic = '2016-president')
#'  # Get all charts
#'  pollster_charts()
#'  # By default, this only returns the first 100 charts, to get more
#'  # set max_pages higher. Use Inf, to ensure you get all.
#'  pollster_charts(topic = '2016-president', max_pages = Inf)
#' }
#' @export
pollster_charts <- function(page = 1, topic = NULL, state = NULL, showall = NULL,
                           convert = TRUE, max_pages = 1) {
  get_page <- function(page) {
    get_url(pollster_charts_url(page = page, topic, state, showall),
            as = "parsed")
  }
  .data <- iterpages(get_page, page, max_pages)
  if (convert) {
    .data <- charts2df(.data)
  }
  .data
}

#' @rdname pollster_charts
#' @export
pollstr_charts <- pollster_charts

#' @export
print.pollster_charts <- function(x, ...) {
  # set to NULL to avoid global variable not in scope warning
  one_of <- NULL
  select(x[["charts"]],
         one_of(c("title", "slug", "state",
                  "poll_count", "last_updated")))
  return(invisible(x))
}
