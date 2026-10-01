test_that("collect start", {
  c(.., y) %<-% 1:5

  expect_equal(y, 5)

  c(.., y) %<-% list(x = 1:3, y = 4:6, z = 7:9)

  expect_equal(y, 7:9)

  c(..x, y) %<-% 1:5

  expect_equal(x, list(1, 2, 3, 4))
  expect_equal(y, 5)

  c(..x, y) %<-% list(x = 1:3, y = 4:6, z = 7:9)

  expect_equal(x, list(x = 1:3, y = 4:6))
  expect_equal(y, 7:9)
})

test_that("collect middle", {
  c(x, .., z) %<-% 1:5

  expect_equal(x, 1)
  expect_equal(z, 5)

  c(x, ..y, z) %<-% list(x = 1:3, y = 4:6, z = 7:9)
  expect_equal(x, 1:3)
  expect_equal(y, 4:6)
  expect_equal(z, 7:9)

  c(x, ..y, z) %<-% 5:1

  expect_equal(x, 5)
  expect_equal(y, list(4, 3, 2))
  expect_equal(z, 1)

  c(x, ..y, z) %<-% list(x = 1:3, y = 4:6, z = 7:9, a = 10:12)
  expect_equal(x, 1:3)
  expect_equal(y, list(y = 4:6, z = 7:9))
  expect_equal(z, 10:12)
})

test_that("collect end", {
  c(x, ..) %<-% 1:3

  expect_equal(x, 1)

  c(x, ..) %<-% list(x = 1:3, y = 4:6, z = 7:9)

  expect_equal(x, 1:3)

  c(x, ..y) %<-% 1:3

  expect_equal(x, 1)
  expect_equal(y, list(2, 3))

  c(x, ..y) %<-% list(x = 1:3, y = 4:6, z = 7:9)

  expect_equal(x, 1:3)
  expect_equal(y, list(y = 4:6, z = 7:9))
})

test_that("collect NULL elements", {
  c(x, ..y) %<-% list(1, NULL, 2)

  expect_equal(y, list(NULL, 2))
})

test_that("collect list elements", {
  c(..x, y) %<-% list(list(1, 2), 3, 4)

  expect_equal(x, list(list(1, 2), 3))
  expect_equal(y, 4)
})

test_that("collect classed elements", {
  f <- factor("a")

  c(x, ..y) %<-% list(f, f, f)

  expect_equal(y, list(f, f))

  d <- as.Date("2020-01-01")

  c(..x, y) %<-% list(d, 1, 2)

  expect_equal(x, list(d, 1))
  expect_equal(y, 2)
})

test_that("collect named atomic elements", {
  c(x, ..y) %<-% c(a = 1, b = 2, c = 3)

  expect_equal(y, list(b = 2, c = 3))
})

test_that("collect nested", {
  c(x, c(y, ..z)) %<-% list(1, list(a = 1:2, b = 3:4, c = 5:6))

  expect_equal(x, 1)
  expect_equal(y, 1:2)
  expect_equal(z, list(b = 3:4, c = 5:6))
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

  dep_warn_reset()

  expect_warning(list(1) %->% c(x, ...y), "collector syntax has changed")
})
