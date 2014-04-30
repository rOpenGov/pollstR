context("chart")

slug <- "obama-job-approval"
chartu <- pollstr_chart(slug, convert = FALSE)

test_that("API returns data", {
    expect_true(length(chartu) > 0)    
})

chart <- pollstr_chart(slug)

test_that("chart data is in the correct format", {
    expect_is(chart, "pollstr_chart")
    expect_equal(length(chart), 11)
    expect_equal(names(chart),
                 c("title", "slug", "topic", "state", "short_title", "election_date", "poll_count", 
                   "last_updated", "url", "estimates", "estimates_by_date"))
    expect_equal(unname(sapply(chart, class)),
                 list("character", "character", "character", "factor", "character", 
                      "Date", "integer", c("POSIXct", "POSIXt"), "character", "data.frame", 
                      "data.frame"))
})

test_that("chart$esimates is in expected format", {
    expect_equal(names(chart$estimates),
                 c("choice", "value", "lead_confidence", "first_name", "last_name", 
                   "party", "incumbent"))
    expect_equal(unname(sapply(chart$estimates, class)),
                 c("character", "numeric", "logical", "character", "character", 
                   "character", "logical"))
    
})

test_that("chart$esimates is in expected format", {
    expect_equal(names(chart$estimates_by_date),
                 c("choice", "value", "date"))
    expect_equal(unname(sapply(chart$estimates_by_date, class)),
                 c("character", "numeric", "Date"))

})
