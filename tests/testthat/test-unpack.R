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
})

test_that('unpack throws error for multi-length vector of atomics', {

})