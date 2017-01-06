context(' * testing unpack')

test_that('unpack unpacks vector', {
  expect_equal(unpack(1:5), as.list(1:5))
})

test_that('unpack unpacks S3', {
  f <- lm(mpg ~ disp, data = mtcars)
  expect_is(unpack(summary(f)), 'list')
  expect_length(unpack(summary(f)), 11)
})

test_that('1 call to unpack same result as N calls to unpack', {
  expect_equal(unpack(iris), unpack(unpack(iris)))
  expect_equal(unpack(1:5), unpack(unpack(1:5)))
})

test_that('argument `n` must be numeric', {
  expect_error(unpack(iris, n = 'Species'), 'argument `n` must be a numeric')
})

test_that('specifying `n` does partial unpack', {
  f <- lm(mpg ~ disp, data = mtcars)
  expect_length(unpack(summary(f), 2), 3)
  expect_length(unpack(summary(f), 2)[[3]], 9)
})

test_that('specifying `n` greater than length of unpack(x) has no effect', {
  f <- lm(mpg ~ disp, data = mtcars)
  expect_equal(unpack(summary(f)), unpack(summary(f), 20))
})
