context("pollster_polls")

test_that("pollster_polls works", {
  skip_on_cran()
  skip_if_offline()
  polls <- pollster_polls()
  expect_is(polls, "pollster_polls")
  expect_named(polls, c("polls", "questions", "survey_houses", "sponsors"))
  for (i in names(polls)) {
    expect_is(polls[[i]], "data.frame")
  }
  expect_named(polls[["polls"]],
               c("id", "pollster", "start_date", "end_date",
                 "method", "source",
                 "last_updated", "partisan", "affiliation"))
  expect_named(polls[["questions"]],
               c("id", "code", "name", "chart", "topic",
                 "state", "observations",
                 "margin_of_error", "choice", "value",
                 "first_name", "last_name",
                 "party", "incumbent"))
  expect_named(polls[["survey_houses"]],
               c("id", "name", "party"))
  expect_named(polls[["sponsors"]],
               c("id", "name", "party"))
})

test_that("pollster_polls arg page works", {
  skip_on_cran()
  skip_if_offline()

  polls <- pollster_polls(page = 2)
  expect_is(polls, "pollster_polls")
})

test_that("pollster_polls arg chart works", {
  skip_on_cran()
  skip_if_offline()

  expect_warning(polls <- pollster_polls(chart = "obama-job-approval"))
  expect_is(polls, "pollster_polls")
})
test_that("pollster_polls arg state works", {
  skip_on_cran()
  skip_if_offline()

  polls <- pollster_polls(state = "WA")
  expect_is(polls, "pollster_polls")
})

test_that("pollster_polls arg topic works", {
  skip_on_cran()
  skip_if_offline()

  polls <- pollster_polls(topic = "obama-job-approval")
  expect_is(polls, "pollster_polls")
})

test_that("pollster_polls arg question works", {
  skip_on_cran()
  skip_if_offline()

  polls <- pollster_polls(question = "16-CO-Pres-GETrumpvClinton")
  expect_is(polls, "pollster_polls")
})

test_that("pollster_polls arg before works", {
  skip_on_cran()
  skip_if_offline()
  .date <- as.Date("2016-06-01", format = "%Y-%m-%d")
  polls <- pollster_polls(before = .date)
  expect_is(polls, "pollster_polls")
  expect_true(all(polls[["polls"]][["date"]] <= .date))
})

test_that("pollster_polls arg question works", {
  skip_on_cran()
  skip_if_offline()
  .date <- as.Date("2016-06-01")
  polls <- pollster_polls(after = .date)
  expect_is(polls, "pollster_polls")
  expect_true(all(polls[["polls"]][["date"]] >= .date))
})

test_that("pollster_polls arg sort works", {
  skip_on_cran()
  skip_if_offline()
  polls <- pollster_polls(sort = TRUE)
  expect_is(polls, "pollster_polls")
})

test_that("pollster_polls arg showall works", {
  skip_on_cran()
  skip_if_offline()
  polls <- pollster_polls(showall = TRUE)
  expect_is(polls, "pollster_polls")
})
