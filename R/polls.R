# Create URL for the charts API method
pollster_polls_url <- function(page, chart, state, topic, question,
                              before, after, sort, showall) {
  query <- list()
  query[["page"]] <- q_param_character(page)
  if (!is.null(chart)) {
    warning("The chart parameter is deprecated in the Pollster API")
    query[["chart"]] <- q_param_character(chart)
  }
  query[["state"]] <- q_param_character(state)
  query[["topic"]] <- q_param_character(topic)
  query[["question"]] <- q_param_character(question)
  query[["before"]] <- q_param_date(before)
  query[["after"]] <- q_param_date(after)
  if (sort) {
    query[["sort"]] <- "updated"
  }
  query[["showall"]] <- q_param_logical(showall)
  make_api_url("polls", query)
}

polls2df <- function(.data) {
  extract_polls <- function(x) {
    for (i in c("questions", "survey_houses", "sponsors")) {
      x[[i]] <- NULL
    }
    convert_df(x)
  }
  clean_subpop <- function(x) {
    responses <- map_df(x[["responses"]], convert_df)
    x[["responses"]] <- NULL
    one_to_many(convert_df(x), responses)
  }
  clean_questions <- function(x) {
    subpop <- map_df(x[["subpopulations"]], clean_subpop)
    x[["subpopulations"]] <- NULL
    one_to_many(convert_df(x), subpop)
  }
  extract_questions <- function(x) {
    y <- map_df(x[["questions"]], clean_questions)
    y[["id"]] <- x[["id"]]
    select_(y, ~ id, ~ everything())
  }
  extract_sponsors <- function(x) {
    if (length(x[["sponsors"]]) > 0) {
      y <- map_df(x[["sponsors"]], convert_df)
      y[["id"]] <- x[["id"]]
      select_(y, ~ id, ~ everything())
    } else NULL
  }
  extract_survey_houses <- function(x) {
    if (length(x[["survey_houses"]]) > 0) {
      y <- map_df(x[["survey_houses"]], convert_df)
      y[["id"]] <- x[["id"]]
      select_(y, ~ id, ~ everything())
    }
  }
  polls <- map_df(.data, extract_polls)
  questions <- map_df(.data, extract_questions)
  survey_houses <- map_df(.data, extract_survey_houses)
  sponsors <- map_df(.data, extract_sponsors)
  structure(list(polls = polls,
                 questions = questions,
                 survey_houses = survey_houses,
                 sponsors = sponsors),
            class = "pollster_polls")
}

#' Get a list of polls
#'
#' @param page Return page number
#' @param chart List polls related to the specified chart. Chart names are the \code{slug} returned by \code{pollster_charts}.
#' @param state Only include charts from a single state. Use 2-letter pstate abbreviations. "US" will return all national charts.
#' @param topic Only include charts related to a specific topic. See the \url{http://elections.huffingtonpost.com/pollster/api} for examples.
#' @param question Only include charts that ask the specified question.
#' @param before Only list polls that ended on or bfore the specified date.
#' @param after Only list polls that ended on or bfore the specified date.
#' @param sort If \code{TRUE}, then sort polls by the last updated time.
#' @param showall Include polls for races that were once possible but didn't happen (e.g. Gingrich vs. Obama 2012)
#' @param max_pages Maximum number of pages to get.
#' @param convert Rearrange the data returned by the API into easier to use data frames.
#'
#' @references \url{http://elections.huffingtonpost.com/pollster/api}
#' @return If \code{convert=TRUE}, a \code{"pollster_polls"} object with elements
#' \describe{
#' \item{\code{polls}}{A \code{data.frame} with entries for each poll.}
#' \item{\code{questions}}{A \code{data.frame} with entries for each question asked in the polls.}
#' \item{\code{survey_houses}}{A \code{data.frame} with the survey houses of the polls. There can be multiple survey houses for a poll.}
#' \item{\code{sponsors}}{A \code{data.frame} with the sponsors of the polls. Not all polls have sponsors.}
#' }
#' Otherwise, a \code{"list"} in the original structure of the json returned by the API.
#' @examples
#' \dontrun{
#' # Get recent polls
#' pollster_polls()
#' # Get polls in a certain date range
#' pollster_polls(before = '2017-03-01', after = '2016-01-01')
#' # By default, this only returns the first page,
#' # to get all pages use max_pages = Inf
#' pollster_polls(topic ='2016-president', max_pages = Inf)
#' # Get polls related to a state
#' pollster_polls(topic = 'WA')
#' # Lookup polls related to a specific topic
#' pollster_polls(topic = '2016-president')
#' }
#' @export
pollster_polls <- function(page = 1, chart = NULL, state = NULL,
                          topic = NULL, question = NULL,
                          before = NULL, after = NULL,
                          sort = FALSE, showall = NULL, max_pages = 1,
                          convert = TRUE) {
  get_page <- function(page) {
    get_url(pollster_polls_url(page = page,
                              chart, state, topic, question,
                              before, after, sort, showall),
            as = "parsed")
  }
  .data <- iterpages(get_page, page, max_pages)
  if (convert) {
    .data <- polls2df(.data)
  }
  .data
}

#' @rdname pollster_polls
#' @export
pollstr_polls <- pollster_polls
