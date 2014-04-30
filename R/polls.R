#'@include pollstr-package.R
NULL

# Create URL for the charts API method
pollstr_polls_url <- function(page, chart, state, topic, before, after, sort) {
    query <- list()
    if (! is.null(page)) {
        query[["page"]] <- as.character(page)[1]
    }
    if (! is.null(chart)) {
        query[["chart"]] <- as.character(chart)[1]
    }
    if (! is.null(state)) {
        query[["state"]] <- as.character(state)[1]
    }
    if (! is.null(topic)) {
        query[["topic"]] <- as.character(topic)[1]
    }
    if (! is.null(before)) {
        before <- before[1]
        if (inherits(before, "Date")) before <- format(before, "%Y-%m-%d")
        query[["before"]] <- as.character(before)[1]
    }
    if (! is.null(after)) {
        after <- after[1]
        if (inherits(after, "Date")) after <- format(after, "%Y-%m-%d")
        query[["after"]] <- as.character(after)[1]
    }
    if (sort) {
        query[["sort"]] <- "updated"
    }
    if (! length(query)) {
        query <- NULL
    }
    modify_url(paste(.POLLSTR_API_URL, "polls", sep="/"), query = query)
}

polls2df <- function(.data) {
    polls <- ldply(.data,
                   function(x) {
                       y <- convert_df(x[c("id", "pollster", "start_date", "end_date",
                                           "method", "source", "last_updated")])
                       y[["start_date"]] <- as.Date(y[["start_date"]])
                       y[["end_date"]] <- as.Date(y[["end_date"]])
                       y[["last_updated"]] <- as.POSIXct(y[["last_updated"]], "%Y-%m-%dT%H:%M:%SZ",
                                                         tz = "GMT")
                       if (length(y[["survey_houses"]])) {
                           y[["survey_houses"]] <-
                               paste(sapply(x[["survey_houses"]], `[[`, i = "name"),
                                     sep = ";")
                       } else {
                           y[["survey_houses"]] <- ""
                       }
                       if (length(y[["sponsors"]])) {
                           y[["sponsors"]] <-
                               paste(sapply(y[["sponsors"]], `[[`, i = "name"),
                                     sep = ";")
                       } else {
                           y[["sponsors"]] <- ""
                       }
                       y
                   })

    clean_subpopulations <- function(x) {
        merge(convert_df(x[c("name", "observations", "margin_of_error")]),
              ldply(x[["responses"]], convert_df))
    }

    clean_questions <- function(x) {
        subpops <- ldply(x[["subpopulations"]], clean_subpopulations)
        subpops <- rename(subpops, c(name = "subpopulation"))
        merge(convert_df(x[c("name", "chart", "topic", "state")]),
              subpops)
    }

    questions <-
        ldply(.data,
              function(x) {
                  ques <- rename(ldply(x[["questions"]], clean_questions),
                                 c(name = "question"))
                  ques[["id"]] <- x[["id"]]
                  ques
              })
    
    # convert
    for (i in c("question", "chart", "topic", "state",
                "party")) {
        questions[[i]] <- as.factor(questions[[i]])
    }
    for (i in c("choice", "first_name", "last_name")) {
        questions[[i]] <- as.character(questions[[i]])
    }
    for (i in c("observations", "id")) {
        questions[[i]] <- as.integer(questions[[i]])
    }
    # Convert polls
    for (i in c("id")) {
        polls[[i]] <- as.integer(polls[[i]])
    }
    for (i in c("source", "survey_houses", "sponsors")) {
        polls[[i]] <- as.character(polls[[i]])
    }
    for (i in c("method", "pollster")) {
        polls[[i]] <- as.factor(polls[[i]])
    }
    
    structure(list(polls = polls, questions = questions),
              class = "pollstr_polls")
}

get_poll <- function(page, chart, state, topic, before, after, sort, as = "parsed") {
    url <- pollstr_polls_url(page, chart, state, topic, before, after, sort)
    get_url(url, as = as)
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
#' @param max_pages Maximum number of pages to get.
#' @param convert Rearrange the data returned by the API into easier to use data frames.
#'
#' @return If \code{convert=TRUE}, a \code{"pollstr_polls"} object with elements
#' \describe{
#' \item{\code{polls}}{A \code{data.frame} with entries for each poll.}
#' \item{\code{questions}}{A \code{data.frame} with entries for each question asked in the polls.}
#' }
#' Otherwise, a \code{"list"} in the original structure of the json returned by the API.
#' @examples
#' \dontrun{
#' # Get polls related to a chart pulled programmatically with
#' # pollstr_charts()
#' a <- pollstr_charts()
#' pollstr_polls(chart=a$slug[1])
#' # Lookup polls related to a specific topic
#' pollstr_polls(topic='2013-house')
#' }
#' @export
pollstr_polls <- function(page = 1, chart = NULL, state = NULL,
                           topic = NULL, before = NULL, after = NULL,
                           sort = FALSE, max_pages = 1, convert = TRUE) {
    .data <- list()
    i <- 0L
    while (i < max_pages) {
        newdata <- get_poll(page + i, chart, state, topic, before, after, sort)
        if (length(newdata)) {
            .data <- append(.data, newdata)
        } else {
            break
        }
        i <- i + 1L
    }
    if (convert) .data <- polls2df(.data)
    .data
}
