#' R client for the Huffpost Pollster API
#'
#' This pacakge provides an R interface to the Huffpost Pollster API v2.
#' \href{http://elections.huffingtonpost.com/}{Huffpost Pollster} tracks and aggregates thousands of public polls on US elections and political opinions.
#' The \href{http://elections.huffingtonpost.com/pollster/api/v2}{Huffpost Pollster API} provides programmatric access to that data.
#' See \href{https://app.swaggerhub.com/api/huffpostdata/pollster-api/}{API Documentation} for the complete documentation of the API.
#'
#' @name pollstR
#' @docType package
#' 
#' @import httr
#' @importFrom utils str
#' @importFrom purrr discard flatten
#' @importFrom lubridate is.Date
#' @importFrom stringr str_detect str_c str_split
NULL

BASE_URL <- "https://elections.huffingtonpost.com/"

USER_AGENT <- user_agent("http://github.com/rOpenGov/pollstR")


process_tags <- function(x) {
  if (!is.null(x)) {
    str_c(x, collapse = ",")
  }  else {
    x
  }
}


process_date <- function(x) {
  if (is.null(x)) {
    NULL
  } else if (is.Date(x)) {
    format(x, "%Y-%m-%d")
  } else {
    as.character(x)
  }
}

  
pollster_api_url <- function(path, query = NULL, version = "v2") {
  path <- str_c(c("pollster", "api", version, path), collapse = "/")
  modify_url(BASE_URL, path = path, query = query)
}


#' Make Huffpost Poster API request
#' 
#' The function \code{pollster_api} is the lower-level function for making a request to the Huffpost Pollster API.
#' There is also a function for each methods provided by the API.
#' 
#' @param path The API endpoint, as a character vector. If the length is greater than one, the elements will be collapsed and separated by \code{"/"}.
#' @param query Query parameters as a \code{list}.
#' @param version The API version.
#' @param response_type Response content type. One of \code{"json"}, \code{"tsv"}, or \code{"xml"}. Some endpoints are json/xml, and some are tsv.
#' @param as Passed to \code{\link[httr]{content}}.
#' @param ... Arguments passed to \code{\link[httr]{GET}}.
#' @param cursor Special string used to handle pagination.
#' @param tags Character vector of tag names.
#' @param question Question slug.
#' @param sort Sort order of polls.
#' @param slug Unique identifier for the poll or question or chart.
#' @param election_date A date object or a string in "YYYY-MM-DD" format for the election date.
#' 
#' @return A \code{pollster_api} object which is a list with elements
#' \itemize{
#' \item{\code{content}:}{The parsed content of the response},
#' \item{\code{url}:}{The URL of the request},
#' \item{\code{response}:}{The request object returned by \code{\link{GET}}.}
#' }
#' @export
pollster_api <- function(path, query = NULL, version = "v2", response_type = NULL, as = "parsed", ...) {
  url <- pollster_api_url(path, query = query, version = version)
  # Handle different content types
  if (is.null(response_type)) {
    if (str_detect(parse_url(url)$path, "\\.tsv$")) {
      response_type <- "tsv"
    } else {
      response_type <- "json"
    }
  }
  accept_header <- switch(
    response_type,
    # tsv header not needed, but makes the code cleaner
    tsv = accept("text/tab-separated-values"),
    json = accept_json(),
    xml = accept_json()
  )
  content_type_ <- switch(
    response_type,
    tsv = "text/tab-separated-values",
    json = "application/json",
    xml = "application/xml"
  )
  resp <- GET(url, accept_header, USER_AGENT, ...)
  if (http_type(resp) != content_type_) {
    stop("API did not return ", response_type, ".", call. = FALSE)
  }
  if (http_error(resp)) {
    stop(
      sprintf(
        "GET %s failed wtith status code %s",
        resp$request$url,
        status_code(resp)
      ),
      call. = FALSE
    )
  }
  structure(
    list(
      content = content(resp, as = as),
      url = resp$request$url,
      response = resp
    ),
    class = "pollster_api"
  )
}


print.pollster_api <- function(x, ...) {
  path <- parse_url(x$url)$path
  cat("<Pollster ", "/", str_c(path[3:length(path)], collapse = "/"), ">\n", sep = "")
  str(x$content, max.level = 1)
  invisible(x)
}


#' @describeIn pollster_api Get polls. See \href{https://app.swaggerhub.com/swagger-ui/#!/default/get_polls}{API docs}.
#' @export
pollster_polls <- function(cursor = NULL, tags = NULL, question = NULL,    sort = c("created_at", "updated_at"), ...) {
  sort <- match.arg(sort)
  path <- c("polls")
  query <- list(cursor = cursor,
                tags = process_tags(tags),
                question = question,
                sort = sort)
  pollster_api(path, query = query, ...)
}


#' @describeIn pollster_api Get a single poll. See \href{https://app.swaggerhub.com/swagger-ui/#!/default/get_polls_slug}{API docs}.
#' @export
pollster_polls_slug <- function(slug, ...) {
  path <- c("polls", slug)
  pollster_api(path, ...)
}


#' @describeIn pollster_api Get questions. See \href{https://app.swaggerhub.com/swagger-ui/#!/default/get_questions}{API docs}.
#' @export
pollster_questions <- function(cursor = NULL, tags = NULL, election_date = NULL, ...) {
  path <- c("questions")
  query <- list(cursor = cursor,
                tags = process_tags(tags),
                election_date = process_date(election_date))
  pollster_api(path, query = query, ...)
}


#' @describeIn pollster_api Get a poll question. See \href{https://app.swaggerhub.com/swagger-ui/#!/default/get_questions_slug}{API Docs}.
#' @export
pollster_questions_slug <- function(slug, ...) {
  path <- c("questions", slug)
  pollster_api(path, ...)
}


#' @describeIn pollster_api Get a table where each row where each row is a single poll question + subpopulation and columns are response labels. See \href{https://app.swaggerhub.com/swagger-ui/#!/default/get_questions_slug_poll_responses_clean_tsv}{API Docs}.
#' @export
pollster_questions_responses_clean <- function(slug, ...) {
  path <- c("questions", slug, "poll-responses-clean.tsv")
  pollster_api(path, ...)
}


#' @describeIn pollster_api Get a table where each row is single poll question + subpopulation + response. See \href{https://app.swaggerhub.com/swagger-ui/#!/default/get_questions_slug_poll_responses_raw_tsv}{API Docs}.
#' @export
pollster_questions_responses_raw <- function(slug, ...) {
  path <- c("questions", slug, "poll-responses-raw.tsv")
  pollster_api(path, ...)
}


#' @describeIn pollster_api Return a list of charts. See href{https://app.swaggerhub.com/swagger-ui/#!/default/get_charts}{API Docs}.
#' @export
pollster_charts <- function(cursor = NULL, tags = NULL, election_date = NULL, ...) {
  path <- c("charts")
  pollster_api(path, query = list(
    cursor = cursor,
    tags = process_tags(tags),
    election_date = process_date(election_date)
  ), ...)
}


#' @describeIn pollster_api Get a chart. See href{https://app.swaggerhub.com/swagger-ui/#!/default/get_charts_slug}{API Docs}.
#' @export
pollster_charts_slug <- function(slug, ...) {
  path <- c("charts", slug)
  pollster_api(path, ...)
}


#' @describeIn pollster_api Get table with one row per poll used in a chart. See \href{https://app.swaggerhub.com/swagger-ui/#!/default/get_charts_slug_pollster_chart_poll_questions_tsv}{API Docs}.
#' @export
pollster_charts_polls <- function(slug, ...) {
  path <- c("charts", slug, "pollster-chart-poll-questions.tsv")
  pollster_api(path, ...)
}


#' @describeIn pollster_api Get table with the trendline estimates used in a chart. See \href{https://app.swaggerhub.com/swagger-ui/#!/default/get_charts_slug_pollster_trendlines_tsv}{API Docs}.
#' @export
pollster_charts_trendlines <- function(slug, ...) {
  path <- c("charts", slug, "pollster-trendlines.tsv")
  pollster_api(path, ...)
}


#' @describeIn pollster_api Return the list of tags used in polls, questions, and charts. See \href{https://app.swaggerhub.com/swagger-ui/#!/default/get_tags}{API Docs}.
#' @export
pollster_tags <- function(...) {
  path <- "tags"
  pollster_api(path, ...)
}


#' Fetch multiple pages
#' 
#' For Pollster methods that return results in pages (those with a \code{cursor} argument), iterate over multiple pages.
#' 
#' @param .f A pollster function for an endpoint that uses a \code{cursor}.
#' @param ... Arguments for \code{.f}
#' @param .max_pages The maximum number of pages to fetch.
#' @param .debug If \code{TRUE} prints the url and cursor number while fetching the pages.
#' @inheritParams pollster_api
#' @return A list of the results.
#' @export
pollster_iter <- function(.f, ..., cursor = NULL, .max_pages = 1, .debug = FALSE) {
  ret <- vector("list", .max_pages)
  page <- 1
  cursor = NULL
  while (page <= .max_pages) {
    current <- .f(..., cursor = cursor)
    ret[[page]] <- current[["content"]][["items"]]
    cursor <- current[["content"]][["next_cursor"]]
    if (.debug) {
      cat("page = ", page, ", cursor = ", cursor, "\n")  
    }
    if (current[["content"]][["next_cursor"]] == "") {
      break
    } else {
      page <- page + 1
    }
  }
  flatten(discard(ret, is.null))
}


#' @describeIn pollster_iter Return a list of charts. See href{https://app.swaggerhub.com/swagger-ui/#!/default/get_charts}{API Docs}. This is the paginated version of \code{pollster_charts}.
#' @export
pollster_charts_iter <- function(cursor = NULL, tags = NULL, election_date = NULL, .max_pages = 1, ...) {
  pollster_iter(pollster_charts,
                cursor = cursor, tags = tags, election_date = election_date,
                .max_pages = .max_pages, ...)
}


#' @describeIn pollster_iter Get a question. This is the paginated form of \code{\link{pollster_questions}}.
#' @export
pollster_questions_iter <- function(cursor = NULL, tags = NULL, election_date = NULL, .max_pages = 1, ...) {
  pollster_iter(pollster_questions, 
                cursor = cursor, tags = tags, 
                election_date = election_date, .max_pages = .max_pages, ...)
}


#' @describeIn pollster_iter Get polls. This function is the paginated version of \code{\link{pollster_polls}}.
#' @export
pollster_polls_iter <- function(cursor = NULL, tags = NULL, question = NULL, sort = c("created_at", "updated_at"), .max_pages = 1, ...) {
  pollster_iter(pollster_polls, 
                cursor = cursor, tags = tags,
                question = question, .max_pages = .max_pages, ...) 
}
