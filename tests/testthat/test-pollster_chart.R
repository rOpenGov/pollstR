context("pollster_chart")

test_that("pollster_chart works with no args", {
  skip_on_cran()
  skip_if_offline()
  charts <- pollster_chart("2016-general-election-trump-vs-clinton")
  expect_is(charts, "pollster_chart")
  expect_named(charts,
               c("id", "title", "slug", "topic", "state",
                 "short_title", "election_date",
                 "poll_count", "last_updated", "url",
                 "estimates", "estimates_by_date"))
  expect_is(charts[["estimates"]], "data.frame")
  expect_named(charts[["estimates"]],
            c("choice", "value", "lead_confidence",
              "first_name", "last_name",
              "party", "incumbent"))
  expect_is(charts[["estimates_by_date"]], "data.frame")
  expect_named(charts[["estimates_by_date"]],
               c("date", "choice", "value"))
})

test_that("pollster_chart arg convert works", {
  skip_on_cran()
  skip_if_offline()
  charts <- pollster_chart("2016-general-election-trump-vs-clinton",
                          convert = FALSE)
  expect_is(charts, "list")
})