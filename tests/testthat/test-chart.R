context("test-charts") 

test_that("pollstr_charts works", {
  skip_on_cran()
  charts <- pollstr_charts()
  expect_is(charts, "pollstr_charts")
})

test_that("pollstr_charts arg page works", {
  skip_on_cran()
  charts <- pollstr_charts(page = 2)
  expect_is(charts, "pollstr_charts")  
})

test_that("pollstr_charts arg topic works", {
  skip_on_cran()
  charts <- pollstr_charts(topic = 2)
  expect_is(charts, "pollstr_charts")  
})

test_that("pollstr_charts arg state works", {
  skip_on_cran()
  charts <- pollstr_charts(state = "WA")
  expect_is(charts, "pollstr_charts")  
})

test_that("pollstr_charts arg topic works", {
  skip_on_cran()
  charts <- pollstr_charts(topic = "2012-gop-primary")
  expect_is(charts, "pollstr_charts")
})

test_that("pollstr_charts arg topic showall works", {
  skip_on_cran()
  charts <- pollstr_charts(showall = TRUE)
  expect_is(charts, "pollstr_charts")
})

test_that("pollstr_charts arg topic convert works", {
  skip_on_cran()
  charts <- pollstr_charts(convert = FALSE)
  expect_is(charts, "list")
})

test_that("pollstr_charts arg max_pages works", {
  skip_on_cran()
  charts <- pollstr_charts(max_pages = 2)
  expect_is(charts, "pollstr_charts")
})