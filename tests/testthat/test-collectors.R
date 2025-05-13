test_that("collect start", {
  c(.., y) %<-% 1:5

  expect_equal(y, 5)

  c(..x, y) %<-% 1:5

  expect_equal(x, list(1, 2, 3, 4))
  expect_equal(y, 5)
})

test_that("collect middle", {
  c(x, .., z) %<-% 1:5

  expect_equal(x, 1)
  expect_equal(z, 5)

  c(x, ..y, z) %<-% 5:1

  expect_equal(x, 5)
  expect_equal(y, list(4, 3, 2))
  expect_equal(z, 1)
})

test_that("collect end", {
  c(x, ..) %<-% 1:3

  expect_equal(x, 1)

  c(x, ..y) %<-% 1:3

  expect_equal(x, 1)
  expect_equal(y, list(2, 3))
})

test_that("defaults to NULL", {
  c(x, ..y) %<-% list(1)

  expect_equal(x, 1)
  expect_equal(y, NULL)
})

test_that("default values", {
  c(x, ..y = NA) %<-% list(1)

  expect_equal(x, 1)
  expect_equal(y, NA)
})

test_that("trailing excess collector does nothing", {
  c(x, ..) %<-% list(1)

  expect_equal(x, 1)
  expect_error(.., "object '..' not found")
})

test_that("leading excess collector is ignored", {
  c(.., x) %<-% list(1)

  expect_equal(x, 1)
  expect_error(.., "object '..' not found")

  c(..y, x) %<-% list(2)

  expect_equal(x, 2)
  expect_equal(y, NULL)
})

test_that("old syntax is deprecated", {
  expect_warning(c(x, ...y) %<-% list(1), "collector syntax has changed")

  expect_silent(c(x, ...y) %<-% list(1))

  dep_warn_reset()

  expect_warning(c(x, ...y) %<-% list(1), "  [*] `[.]{3}y` => `[.]{2}y`")
})
