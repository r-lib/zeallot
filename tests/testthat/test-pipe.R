test_that("magrittr pipe", {
  skip_if_not_installed("magrittr")

  library(magrittr)

  1:5 %>%
    vapply(\(x) x + 5, numeric(1)) %>%
    as.character() %->%
    c(a, b, c, d, e)

  expect_equal(a, "6")
  expect_equal(b, "7")
  expect_equal(c, "8")
  expect_equal(d, "9")
  expect_equal(e, "10")
})

test_that("native pipe", {
    1:5 |>
    vapply(\(x) x <= 1, logical(1)) %->%
    c(a, ...b)

  expect_equal(a, TRUE)
  expect_equal(b, c(FALSE, FALSE, FALSE, FALSE))
})
