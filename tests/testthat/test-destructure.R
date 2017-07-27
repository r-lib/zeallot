context(" * testing destructure")

test_that("destructure atomics", {
  expect_equal(destructure("hello"), list("h", "e", "l", "l", "o"))
  expect_equal(destructure(complex(1, 33, -7)), list(33, -7))

  expect_error(
    destructure(1),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )
})

test_that("destructure data.frame converts data.frame to list", {
  sample_df <- head(iris)
  expect_equal(destructure(sample_df), as.list(sample_df))
  expect_equal(length(sample_df), NCOL(sample_df))
  expect_true(all(lengths(destructure(sample_df)) == NROW(sample_df)))
  for (i in seq_len(NCOL(sample_df))) {
    expect_equal(destructure(sample_df)[[i]], sample_df[[i]])
  }
})

test_that("destructure converts Date to list of year, month, day", {
  today <- Sys.Date()
  year <- as.numeric(format(today, "%Y"))
  month <- as.numeric(format(today, "%m"))
  day <- as.numeric(format(today, "%d"))
  expect_equal(destructure(today), list(year, month, day))
})

test_that("destructure summary.lm converts to list", {
  f <- lm(disp ~ mpg, data = mtcars)
  expect_equal(destructure(summary(f)), lapply(summary(f), identity))
})

test_that("destructure throws error for multi-length vectors of atomics", {
  expect_error(
    assert_destruction(character(2)),
    "invalid `destructure` argument, cannot destructure character vector of length greater than 1"
  )
  expect_error(
    destructure(c(Sys.Date(), Sys.Date())),
    "invalid `destructure` argument, cannot destructure Date vector of length greater than 1"
  )
})

test_that("destructure throws error as default", {
  random <- structure(list(), class = "random")
  expect_error(
    destructure(random),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )
})
