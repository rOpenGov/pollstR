context("test-charts") 

test_that("pollstr_charts works", {
  skip_on_cran()
  charts <- pollstr_charts()
  expect_is(charts, "pollstr_charts")
  expect_named(charts, c("charts", "estimates"))
  expect_is(charts[["charts"]], "data.frame")
  expect_named(charts[["charts"]],
            c("id", "slug", "title", "topic", "state",
              "short_title", "election_date", 
              "poll_count", "last_updated", "url"))
  expect_is(charts[["estimates"]], "data.frame")
  expect_named(charts[["estimates"]],
               c("slug", "choice", "value", "lead_confidence", "first_name", 
                 "last_name", "party", "incumbent"))
})

test_that("pollstr_charts arg page works", {
  skip_on_cran()
  charts <- pollstr_charts(page = 2)
  expect_is(charts, "pollstr_charts")  
})

test_that("pollstr_charts arg topic works", {
  skip_on_cran()
  charts <- pollstr_charts(topic = "2016-president")
  expect_is(charts, "pollstr_charts")  
})

test_that("pollstr_charts arg state works", {
  skip_on_cran()
  charts <- pollstr_charts(state = "WA")
  expect_is(charts, "pollstr_charts")  
})

test_that("pollstr_charts arg topic works", {
  skip_on_cran()
  charts <- pollstr_charts(topic = "2016-president-gop-primary")
  expect_is(charts, "pollstr_charts")
})

test_that("pollstr_charts arg showall works", {
  skip_on_cran()
  charts <- pollstr_charts(showall = TRUE)
  expect_is(charts, "pollstr_charts")
})

test_that("pollstr_charts arg convert works", {
  skip_on_cran()
  charts <- pollstr_charts(convert = FALSE)
  expect_is(charts, "list")
})

test_that("pollstr_charts arg max_pages works", {
  skip_on_cran()
  charts <- pollstr_charts(max_pages = 2)
  expect_is(charts, "pollstr_charts")
})