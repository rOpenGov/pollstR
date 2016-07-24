#' House Effects
#' 
#' For each chart, Pollster estimates house effects for each pollster, which is roughly the average difference
#' between the polls of a pollster and the average of all the polls. This
#' is not officially part of the Pollster API.
#' 
#' @param slug The slug of the chart
#' @return A data frame
#' @examples 
#' \dontrun{
#'   pollster_house_effects("2016-general-election-trump-vs-clinton")
#' }
#' @export
pollster_house_effects <- function(slug) {
  .data <- get_url(pollster_house_effects_url(slug), as = "parsed")
  class(.data) <- c("pollster_chart_tbl", class(.data))
  .data
}

pollster_house_effects_url <- function(slug) {
  slug <- as.character(slug[1])
  paste("http://elections.huffingtonpost.com/pollster/",
        slug, paste0(slug, "-house-effects.csv"), sep = "/")
}
