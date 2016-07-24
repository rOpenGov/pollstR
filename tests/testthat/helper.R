skip_if_offline <- function() {
  online <- tryCatch({
    r <- GET("www.google.com")
    httr::stop_for_status(r)
    TRUE
    },
  error = function(err) FALSE)
  if (!online) testthat::skip("not online")
}