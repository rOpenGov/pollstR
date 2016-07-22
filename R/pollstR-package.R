#' R client for the Huffpost Pollster API
#'
#' This pacakge provides an R interface to the Huffington Post Pollster API.
#' Pollster provides programmatic access to opinion polls collected by the Huffington Post.
#'
#' See \url{http://elections.huffingtonpost.com/pollster/api} for more details on the API.
#'
#' @name pollstR
#' @docType package
#' @import httr
#' @import tibble
#' @importFrom purrr map_df
#' @importFrom utils head
NULL

.POLLSTR_API_URL <- "http://elections.huffingtonpost.com/pollster/api"

get_url <- function(url, as = "parsed") {
    response <- GET(url)
    stop_for_status(response)
    content(response, as = as)
}

q_param_character <- function(x) {
  if (!is.null(x)) {
    as.character(x)[1]
  } else {
    NULL
  }
}
q_param_logical <- function(x) {
  if (is.null(x)) {
    NULL
  } else {
    if (x[1]) "true" else "false"
  }
}

q_param_date <- function(x) {
  if (is.null(x)) {
    NULL
  } else {
    x <- x[1]
    if (inherits(x, "Date")) {
      format(x, "%Y-%m-%d")
    } else {
      as.character(x)
    }
  }
}

q_param_integer <- function(x) {
  if (is.null(x)) {
    NULL
  } else {
    as.character(as.integer(x[1]))
  }
}

make_api_url <- function(path, query) {
  if (!length(query)) {
    query <- NULL
  }
  modify_url(paste(.POLLSTR_API_URL, path, sep = "/"), query = query)  
}

iterpages <- function(.f, page = 1, max_page = 1) {
  .data <- list()
  i <- 0L
  while (i < max_page) {
    newdata <- .f(page = i, ...)
    # Check if new results
    if (length(newdata)) {
      .data[[i]] <- newdata
    } else {
      break
    }
    i <- i + 1L
  }  
  purrr::flatten(.data)
}

convert_df <- function(x) {
    for (i in names(x)) {
      if (is.null(x[[i]])) {
        x[[i]] <- NA
      }
    }
    as_data_frame(x, stringsAsFactors = FALSE)
}

# election date entry
electiondate2date <- function(x) {
    if (is.null(x)) {
        as.Date(NA_character_)
    } else {
        as.Date(x, "%Y-%m-%d")
    }
}
