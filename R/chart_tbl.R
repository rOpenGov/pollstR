chart_tbl_url <- function(slug) {
  slug <- as.character(slug[1])
  paste(.POLLSTR_API_URL, "charts", paste0(slug, ".csv"), sep = "/")
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
#' chart <- pollstr_chart_tbl()
#' chart
#' }
pollstr_chart_tbl <- function(slug) {
  .data <- get_url(chart_tbl_url(slug), as = "parsed")
  class(.data) <- c("pollstr_chart_tbl", class(.data))
  .data
}

chart_house_effects_url <- function(slug) {
  slug <- as.character(slug[1])
  paste0("http://elections.huffingtonpost.com/pollster/",
         slug, paste0(slug, "-house_effects.csv"), sep = "/")
}

# This is not officially part of the API
pollstr_chart_house_effects <- function(slug) {
  .data <- get_url(chart_house_effects_url(slug), as = "parsed")
  class(.data) <- c("pollstr_chart_tbl", class(.data))
  .data
}