# Create URL for the charts API method
pollstr_polls_url <- function(page, chart, state, topic, before, after,
                              sort, showall) {
  query <- list()
  query[["page"]] <- q_param_character(page)
  query[["chart"]] <- q_param_character(chart)
  query[["state"]] <- q_param_character(state)
  query[["topic"]] <- q_param_character(topic)
  query[["before"]] <- q_param_date(before)
  query[["after"]] <- q_param_date(after)
  if (sort) {
    query[["sort"]] <- "updated"
  }
  query[["showall"]] <- q_param_logical(showall)
  make_api_url("polls", query)
}


polls2df <- function(.data) {
  clean_polls <- function(x) {
    y <- convert_df(x[setdiff(names(x),
                              c("questions", "survey_houses",
                                "sponsors"))])
    y[["start_date"]] <- as.Date(y[["start_date"]])
    y[["end_date"]] <- as.Date(y[["end_date"]])
    y[["last_updated"]] <- as.POSIXct(y[["last_updated"]],
                                      "%Y-%m-%dT%H:%M:%OSZ",
                                      tz = "GMT")
    y    
  }
  polls <- map_df(.data, clean_polls)
  # Convert polls
  for (i in c("id")) {
    polls[[i]] <- as.integer(polls[[i]])
  }
  
  clean_subpopulations <- function(x) {
    merge(convert_df(x[c("name", "observations", "margin_of_error")]),
          map_df(x[["responses"]], convert_df))
  }
  
  clean_questions <- function(x) {
    subpops <- map_df(x[["subpopulations"]], clean_subpopulations)
    subpops <- rename(subpops, c(name = "subpopulation"))
    merge(convert_df(x[c("name", "chart", "topic", "state")]),
          subpops)
  }
  
  questions <-
    map_df(.data,
          function(x) {
            ques <- rename(map_df(x[["questions"]], clean_questions),
                           c(name = "question"))
            ques[["id"]] <- x[["id"]]
            ques
          })
  # convert
  for (i in c("observations", "id")) {
    questions[[i]] <- as.integer(questions[[i]])
  }
  
  clean_sponsors <- function(x) {
    sponsors <- x[["sponsors"]]
    if (length(sponsors)) {
      sponsors <- map_df(sponsors, convert_df)
      sponsors[["id"]] <- x[["id"]]
      sponsors
    } else {
      NULL
    }
  }   
  sponsors <- map_df(.data, clean_sponsors)
  
  clean_survey_houses <- function(x) {
    survey_houses <- x[["survey_houses"]]
    if (length(survey_houses)) {
      survey_houses <- map_df(survey_houses, convert_df)
      survey_houses[["id"]] <- x[["id"]]
      survey_houses
    } else {
      NULL
    }
  }
  survey_houses <- map_df(.data, clean_survey_houses)
  
  
  structure(list(polls = polls,
                 questions = questions,
                 survey_houses = survey_houses,
                 sponsors = sponsors),
            class = "pollstr_polls")
}




#' Get a list of polls
#'
#' @param page Return page number
#' @param chart List polls related to the specified chart. Chart names are the \code{slug} returned by \code{pollstr_charts}.
#' @param state Only include charts from a single state. Use 2-letter pstate abbreviations. "US" will return all national charts.
#' @param topic Only include charts related to a specific topic. See the \url{http://elections.huffingtonpost.com/pollster/api} for examples.
#' @param before Only list polls that ended on or bfore the specified date.
#' @param after Only list polls that ended on or bfore the specified date.
#' @param sort If \code{TRUE}, then sort polls by the last updated time.
#' @param showall Include polls for races that were once possible but didn't happen (e.g. Gingrich vs. Obama 2012)
#' @param max_pages Maximum number of pages to get.
#' @param convert Rearrange the data returned by the API into easier to use data frames.
#'
#' @references \url{http://elections.huffingtonpost.com/pollster/api}
#' @return If \code{convert=TRUE}, a \code{"pollstr_polls"} object with elements
#' \describe{
#' \item{\code{polls}}{A \code{data.frame} with entries for each poll.}
#' \item{\code{questions}}{A \code{data.frame} with entries for each question asked in the polls.}
#' \item{\code{survey_houses}}{A \code{data.frame} with the survey houses of the polls. There can be multiple survey houses for a poll.}
#' \item{\code{sponsors}}{A \code{data.frame} with the sponsors of the polls. Not all polls have sponsors.}
#' }
#' Otherwise, a \code{"list"} in the original structure of the json returned by the API.
#' @examples
#' \dontrun{
#' # Get polls related to a chart pulled programmatically with
#' # pollstr_charts()
#' all_charts <- pollstr_charts()
#' pollstr_polls(chart=all_charts$slug[1])
#' # Lookup polls related to a specific topic
#' pollstr_polls(topic='2016-president')
#' }
#' @export
pollstr_polls <- function(page = 1, chart = NULL, state = NULL,
                          topic = NULL, before = NULL, after = NULL,
                          sort = FALSE, showall = NULL, max_pages = 1,
                          convert = TRUE) {
  get_page <- function(page) {
    get_url(pollstr_polls_url(page = page, chart, state, topic, before,
                             after, sort, showall),
            as = "parsed")
  }
  .data <- iterpages(get_page, page, max_pages)
  .data
}
