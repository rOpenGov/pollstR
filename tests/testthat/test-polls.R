context("pollstr_polls")

test_that("pollstr_polls works", {
  skip_on_cran()
  polls <- pollstr_polls()
  expect_is("pollstr_polls")
})

test_that("pollstr_polls arg page works", {
  skip_on_cran()
  polls <- pollstr_polls(page = 2)
  expect_is("pollstr_polls")
})

test_that("pollstr_polls arg chart works", {
  skip_on_cran()
  polls <- pollstr_polls(chart = "obama-job-approval")
  expect_is("pollstr_polls")
})
test_that("pollstr_polls arg state works", {
  skip_on_cran()
  polls <- pollstr_polls(state = "WA")
  expect_is("pollstr_polls")
})
test_that("pollstr_polls arg topic works", {
  skip_on_cran()
  polls <- pollstr_polls(topic = "obama-job-approval")
  expect_is("pollstr_polls")
})

test_that("pollstr_polls arg question works", {
  skip_on_cran()
  polls <- pollstr_polls(question = "16-CO-Pres-GE TrumpvClinton")
  expect_is("pollstr_polls")  
})

test_that("pollstr_polls arg before works", {
  skip_on_cran()
  polls <- pollstr_polls(before = "2016-06-01")
  expect_is("pollstr_polls")  
})

test_that("pollstr_polls arg question works", {
  skip_on_cran()
  polls <- pollstr_polls(after = "2016-06-01")
  expect_is("pollstr_polls")  
})

test_that("pollstr_polls arg sort works", {
  skip_on_cran()
  polls <- pollstr_polls(sort = TRUE)
  expect_is("pollstr_polls")  
})

test_that("pollstr_polls arg showall works", {
  skip_on_cran()
  polls <- pollstr_polls(showall = TRUE)
  expect_is("pollstr_polls")  
})

