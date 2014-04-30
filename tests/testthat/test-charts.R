context("charts")

chartsu <- pollstr_charts(convert=FALSE)

test_that("charts is in expected format if not converted", {
    expect_is(chartsu, "list")
    expect_true(length(chartsu) > 0)
    expect_equal(names(chartsu[[1]]),
                 c("title", "slug", "topic", "state",
                   "short_title", "election_date", "poll_count",
                   "last_updated", "url", "estimates"))

})

charts <- pollstr_charts()

test_that("charts is in expected format", {
    expect_is(charts, "pollstr_charts")
    expect_equal(length(charts), 2)
    expect_equal(names(charts), c("charts", "estimates"))
    expect_equal(unname(sapply(charts, class)), rep("data.frame", 2))
})

test_that("query returns data", {
    expect_true(nrow(charts[["charts"]]) > 0)
    expect_true(nrow(charts[["estimates"]]) > 0)
})

test_that("charts$charts is in expected format", {
    expect_equal(names(charts$charts),
                 c("title", "slug", "topic", "state", "short_title", "election_date", "poll_count", "last_updated", "url"))
                   
    expect_equal(unname(sapply(charts$charts, class)),
                 list("character", "character", "character", "factor", "character", 
                      "Date", "integer", c("POSIXct", "POSIXt"), "character"))
    
})

test_that("charts$charts is in expected format", {
    expect_equal(names(charts$estimates),
                 c("choice", "value", "lead_confidence", "first_name", "last_name", 
                   "party", "incumbent", "slug"))
    expect_equal(unname(sapply(charts$estimates, class)),
                 c("character", "numeric", "numeric", "character", "character", 
                   "factor", "logical", "character"))
})
