context(' * testing unpack')

test_that('unpack unpacks vector', {
  expect_equal(unpack(1:5), as.list(1:5))
})

test_that('unpack unpacks S3', {
  f <- lm(mpg ~ disp, data = mtcars)
  expect_is(unpack(summary(f)), 'list')
  expect_length(unpack(summary(f)), 11)
})

test_that('1 call to unpack equals N calls to unpack', {
  expect_equal(unpack(iris), unpack(unpack(iris)))
  expect_equal(unpack(1:5), unpack(unpack(1:5)))
})
