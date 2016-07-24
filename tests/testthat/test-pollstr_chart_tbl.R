context("pollstr_chart_tbl")

test_that("pollstr_chart_tbl works", {
  skip_on_cran()
  skip_if_offline()
  chart <- pollstr_chart_tbl("2016-general-election-trump-vs-clinton")
  expect_is(chart, "data.frame")
})
