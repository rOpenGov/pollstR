context("pollster_chart_data")

test_that("pollster_chart_data works", {
  skip_on_cran()
  skip_if_offline()
  chart <- pollster_chart_data("2016-general-election-trump-vs-clinton")
  expect_is(chart, "data.frame")
})
