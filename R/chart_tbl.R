chart_data_url <- function(slug) {
  slug <- as.character(slug[1])
  paste(.POLLSTER_API_URL, "charts", paste0(slug, ".csv"), sep = "/")
}

#' Pollster Charts (table)
#' 
#' This function returns the poll data from a Pollster chart in
#' a convenient tabular form.
#' 
#' @param slug The slug of the chart, e.g. "012-general-election-romney-vs-obama.csv".
#' @return A data frame with the chart data.
#' @export
#' @examples 
#' \dontrun{
#' chart <- pollster_chart_data()
#' chart
#' }
pollster_chart_data <- function(slug) {
  .data <- get_url(chart_data_url(slug), as = "parsed")
  class(.data) <- c("pollster_chart_data", class(.data))
  .data
}
