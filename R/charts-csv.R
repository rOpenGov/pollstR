chart_csv_url <- function(slug) {
  slug <- as.character(slug[1])
  paste0(.POLLSTR_API_URL, "charts", paste0(slug, ".csv"), sep = "/")
}

#' Pollster Charts (table)
#' 
#' This provides a convenient table form
#' for the poll data in a Pollster Chart. 
#' 
#' @param slug The slug of the chart, e.g. "012-general-election-romney-vs-obama.csv".
#' @return A data frame with the chart data.
#' @export
pollstr_chart_tbl <- function(slug) {
  .data <- get_url(charts_csv_url(slug), as = "parsed")
  class(.data) <- c("pollstr_chart_tbl", class(.data))
  .data
}

chart_house_effects_url <- function(slug) {
  slug <- as.character(slug[1])
  paste0("http://elections.huffingtonpost.com/pollster/",
         slug, paste0(slug, '-house_effects.csv'), sep = "/")
}

#' Pollster House Effects ()
#' 
#' 
pollstr_charts_tbl <- function(slug) {
  .data <- get_url(charts_csv_url(slug), as = "parsed")
  class(.data) <- c("pollstr_chart_tbl", class(.data))
  .data
}