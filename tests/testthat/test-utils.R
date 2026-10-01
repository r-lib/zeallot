test_that("list_compress", {
  x <- list(a = 1, b = 2, c = 3)

  expect_length(list_compress(x, 1), 1)
  expect_equal(list_compress(x, 1)[[1]], x)
  expect_equal(list_compress(x, 2), list(list(a = 1, b = 2), c = 3))
  expect_equal(list_compress(x, 3), x)
  expect_equal(list_compress(x, 4), x)

  expect_error(list_compress(x, 0))
})
