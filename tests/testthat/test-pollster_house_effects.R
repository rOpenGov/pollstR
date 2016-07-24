context("pollster_house_effects") 

test_that("pollster_house_effects works", {
  slug <- "2016-general-election-trump-vs-clinton"
  house_fx <- pollster_house_effects(slug)
  expect_is(house_fx, "data.frame")
  cols <- c(pollster = "character", subpop = "character",
            value = "numeric", hi = "numeric", lo = "numeric")
  for (i in seq_along(cols)) {
    expect_is(house_fx[[names(cols)[i]]], cols[i])
  }
})
