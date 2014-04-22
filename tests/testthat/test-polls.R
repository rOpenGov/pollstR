context("polls")

pollsu <- pollster_polls(max_pages = 1, convert = FALSE)

test_that("polls is in expected format if not converted", {
    expect_is(pollsu, "list")
    expect_true(length(pollsu) > 0)
    expect_equal(names(pollsu[[1]]),
                 c("id", "pollster", "start_date", "end_date", "method", "source", 
                   "last_updated", "survey_houses", "sponsors", "questions"))
})

polls <- pollster_polls(max_pages = 1)

test_that("polls data is in the correct format", {
    expect_is(polls, "list")
    expect_equal(length(polls), 2)
    expect_equal(names(polls), c("polls", "questions"))
    expect_equal(unname(sapply(polls, class)), rep("data.frame", 2))
})

test_that("query returns data", {
    expect_true(nrow(polls[["polls"]]) > 0)
    expect_true(nrow(polls[["questions"]]) > 0)
})

test_that("polls$polls is in expected format", {
    expect_equal(names(polls$polls),
                c("id", "pollster", "start_date", "end_date", "method", "source", 
                  "last_updated", "survey_houses", "sponsors"))
    expect_equal(unname(sapply(polls$polls, class)),
                list("numeric", "factor", "Date", "Date", "factor", "factor", 
                     c("POSIXct", "POSIXt"), "character", "character"))
})
    
test_that("polls$questions is in expected format", {
    expect_equal(names(polls$questions),
                c("question", "chart", "topic", "state", "subpopulation", "observations", 
                  "margin_of_error", "choice", "value", "first_name", "last_name", 
                  "party", "incumbent", "id"))
    expect_equal(unname(sapply(polls$questions, class)),
                 c("factor", "factor",  "factor", "factor", "factor",
                   "numeric", "numeric", "factor", "numeric", "character", "character", 
                   "character", "logical", "numeric"))
})

