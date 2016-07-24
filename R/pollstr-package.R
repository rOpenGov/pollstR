#' R client for the Huffpost Pollster API
#'
#' This pacakge provides an R interface to the Huffington Post Pollster API.
#' Pollster provides programmatic access to opinion polls collected by the Huffington Post.
#'
#' See \url{http://elections.huffingtonpost.com/pollster/api} for more details on the API.
#'
#' @name pollstR
#' @docType package
#' 
#' @importFrom utils head
#' @importFrom dplyr bind_rows bind_cols select_ select everything
#' @import httr
#' @importFrom purrr map_df rerun
#' @import tibble
#' @importFrom stringr str_detect
NULL

.POLLSTER_API_URL <- "http://elections.huffingtonpost.com/pollster/api"

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
  modify_url(paste(.POLLSTER_API_URL, path, sep = "/"), query = query)
}

iterpages <- function(.f, page = 1, max_pages = 1) {
  .data <- list()
  i <- 0L
  while (i < max_pages) {
    newdata <- .f(page = page + i)
    # Check if new results
    if (length(newdata)) {
      .data[[i + 1L]] <- newdata
    } else {
      break
    }
    i <- i + 1L
  }
  purrr::flatten(.data)
}

clean_list <- function(x) {
  regex_dt <- "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z"
  regex_date <- "^\\d{4}-\\d{2}-\\d{2}$"
  regex_num <- "^(\\d*\\.\\d+|\\d+\\.?)$"
  for (i in names(x)) {
    if (is.null(x[[i]])) {
      x[[i]] <- NA
    } else if (is.character(x[[i]])) {
      if (all(str_detect(x[[i]], regex_date))) {
        x[[i]] <- as.Date(x[[i]], "%Y-%m-%d")
      } else if (all(str_detect(x[[i]], regex_dt))) {
        x[[i]] <- as.POSIXct(x[[i]], format = "%Y-%m-%dT%H:%M:%OSZ",
                             tz = "UTC")
      } else if (all(str_detect(x[[i]], regex_num))) {
        x[[i]] <- as.numeric(x[[i]])
      }
    }
  }
  x
}

convert_df <- function(x) {
  # need to drop NULL columns before as_data_frame
  as_tibble(clean_list(x))
}

# election date entry
electiondate2date <- function(x) {
  if (is.null(x)) {
    as.Date(NA_character_)
  } else {
    as.Date(x, "%Y-%m-%d")
  }
}

one_to_many <- function(x, y) {
  bind_cols(bind_rows(rerun(nrow(y), x)), y)
}