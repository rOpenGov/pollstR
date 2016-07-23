# Create URL for the charts API method
pollstr_chart_url <- function(slug) {
  paste(.POLLSTR_API_URL, "charts", as.character(slug)[1], sep = "/")
}

simplify_chart <- function(.data) {
  convert_df(.data)
}

# clean up the objects returned by the API
pollstr_chart_parse <- function(.data) {
    # Convert
    if (!is.null(.data[["election_date"]])) {
      .data[["election_date"]] <-
        as.Date(.data[["election_date"]], "%Y-%m-%d")
    }
    .data[["last_updated"]] <-
        as.POSIXct(.data[["last_updated"]],
                   format = "%Y-%m-%dT%H:%M:%OSZ",
                   tz = "GMT")

    estimates <- map_df(.data[["estimates"]], convert_df)
    .data[["estimates"]] <- estimates
    .data[["estimates_by_date"]] <-
        map_df(.data[["estimates_by_date"]],
               function(x) {
                  y <- map_df(x[["estimates"]], convert_df)
                  y[["date"]] <- as.Date(x[["date"]])
                  select_(y, ~ date, ~ everything())
               })
    structure(.data, class = "pollstr_chart")
}

#' Return a single chart
#'
#' Return a single chart. This includes both current and historical estimates by date.
#'
#' @param slug The slug-name of the chart to be returned.
#' @param convert Rearrange the data returned by the API into easier to use data frames.
#' @references \url{http://elections.huffingtonpost.com/pollster/api}
#' @return If \code{convert=TRUE}, then a \code{"pollstr_chart"} object with elements
#' \itemize{
#' \item \code{title} Title of the chart.
#' \item \code{slug} Slug (URL-friendly title) of the chart.
#' \item \code{topic} Topic of the chart.
#' \item \code{short_title} Short title of the chart.
#' \item \code{poll_count} Number of polls in the chart.
#' \item \code{last_updated} Time the chart was last updated.
#' \item \code{url} URL of the chart.
#' \item \code{estimates} A data frame with an observation for each choice and the current estimates.
#' \item \code{estimates_by_date} A data frame with an observation for each choice at each date, with estimates.
#' }
#' Otherwise, a \code{"list"} in the original structure of the json returned by the API.
#' @examples
#' \dontrun{
#' chart1 <- pollstr_chart('2012-general-election-romney-vs-obama')
#' }
#' @export
pollstr_chart <- function(slug, convert = TRUE) {
    .data <- get_url(pollstr_chart_url(slug), as = "parsed")
    if (convert) {
      .data <- pollstr_chart_parse(.data)
    }
    .data
}

#' @export
print.pollstr_chart <- function(x, ..., n = 6) {
    cat('Title:      ',x$title,'\n')
    cat('Chart Slug: ',x$slug,'\n')
    cat('Topic:      ',x$topic,'\n')
    cat('State:      ',x$state,'\n')
    cat('Polls:      ',x$poll_count,'\n')
    cat('Updated:    ',x$last_updated,'\n')
    cat('URL:        ',x$url,'\n')
    if('estimates' %in% names(x)){
        cat('Estimates:\n')
        print(x$estimates)
        cat('\n')
    }
    if('estimates_by_date' %in% names(x)){
        if(nrow(x[["estimates_by_date"]]) > n){
            cat('First 6 (of ',
                nrow(x$estimates_by_date),
                ') daily estimates:\n', sep = '')
            print(head(x$estimates_by_date))
        } else {
            cat('All daily estimates:\n')
            print(x[["estimates_by_date"]])
        }
    }
    cat('\n')
    return(invisible(x))
}
