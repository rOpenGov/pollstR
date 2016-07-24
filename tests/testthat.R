library("testthat")
library("httr")
library("pollstR")

skip_if_offline <- function() {
  online <- tryCatch({
    r <- GET("www.google.com") 
    httr::stop_for_status()
    TRUE}, error = function(err) FALSE)
  if (!online) testthat::skip("not online")
}

test_check("pollstR")
