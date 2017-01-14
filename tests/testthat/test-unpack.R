context(' * testing unpack')

test_that('unpack atomics', {
  expect_equal(unpack(1), 1)
  expect_equal(unpack('hello'), list('h', 'e', 'l', 'l', 'o'))
  expect_equal(unpack(raw(1)), raw(1))
  expect_equal(unpack(complex(1, 33, -7)), list(33, -7))
  expect_equal(unpack(TRUE), TRUE)
})

test_that('unpack NULL is NULL', {
  expect_null(unpack(NULL))
})

test_that('unpack data.frame converts data.frame to list', {
  sample_df <- head(iris)
  expect_equal(unpack(sample_df), as.list(sample_df))
  expect_equal(length(sample_df), NCOL(sample_df))
  expect_true(all(lengths(unpack(sample_df)) == NROW(sample_df)))
  for (i in seq_len(NCOL(sample_df))) {
    expect_equal(unpack(sample_df)[[i]], sample_df[[i]])
  }
})

test_that('unpack converts Date to list of year, month, day', {
  today <- Sys.Date()
  year <- as.numeric(format(today, '%Y'))
  month <- as.numeric(format(today, '%m'))
  day <- as.numeric(format(today, '%d'))
  expect_equal(unpack(today), list(year, month, day))
})

test_that('unpack summary.lm converts to list', {
  f <- lm(disp ~ mpg, data = mtcars)
  expect_equal(unpack(summary(f)), lapply(summary(f), identity))
})

test_that('unpack throws error for multi-length vectors of atomics', {
  expect_error(assert_unpackable(character(2)), 'cannot unpack character vector')
  expect_error(unpack(numeric(2)), 'cannot unpack numeric vector')
  expect_error(unpack(logical(2)), 'cannot unpack logical vector')
  expect_error(unpack(raw(2)), 'cannot unpack raw vector')
  expect_error(unpack(complex(2)), 'cannot unpack complex vector')
  expect_error(unpack(c(Sys.Date(), Sys.Date())), 'cannot unpack Date vector')
})

test_that('unpack throws error as default', {
  random <- structure(list(), class = 'random')
  expect_error(unpack(random), 'cannot unpack object of class random')
})
