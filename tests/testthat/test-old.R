context(" * test old operator")

test_that("non-`c()` syntax triggers old operator", {
  expect_warning(a : b %<-% c(1, 2))
  expect_equal(a, 1)
  expect_equal(b, 2)
})
