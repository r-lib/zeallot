test_that("native pipe", {
    1:5 |>
    vapply(\(x) x <= 1, logical(1)) %->%
    c(x, ..y)

  expect_equal(x, TRUE)
  expect_equal(y, list(FALSE, FALSE, FALSE, FALSE))
})
