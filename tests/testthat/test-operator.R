test_that("standard assignment", {
  x %<-% 1

  expect_equal(x, 1)

  y %<-% list(1, 2, 3)

  expect_equal(y, list(1, 2, 3))

  1 %->% z

  expect_equal(z, 1)
})

test_that("multiple assignment", {
  c(x, y) %<-% list(1, 2)

  expect_equal(x, 1)
  expect_equal(y, 2)
})

test_that("in-place assignment", {
  l <- list()

  c(l[[1]], l[[2]]) %<-% list(3, 4)

  expect_equal(l[[1]], 3)
  expect_equal(l[[2]], 4)

  e <- new.env(parent = emptyenv())

  c(e$hello) %<-% list("world")

  expect_equal(e$hello, "world")
})

test_that("nested assignment", {
  c(c(x, y), z) %<-% list(list(1, 2), 3)

  expect_equal(x, 1)
  expect_equal(y, 2)
  expect_equal(z, 3)
})

test_that("skip value using .", {
  c(x, ., z) %<-% list(1, 2, 3)

  expect_equal(x, 1)
  expect_equal(z, 3)
  expect_false(exists(".", inherits = FALSE))
})

test_that("default values", {
  c(x, y = 2) %<-% list(1)

  expect_equal(x, 1)
  expect_equal(y, 2)

  c(x, y = 3, z = 4) %<-% list(2)

  expect_equal(x, 2)
  expect_equal(y, 3)
  expect_equal(z, 4)

  c(x, y = NULL) %<-% list(3)

  expect_equal(x, 3)
  expect_equal(y, NULL)
})

test_that("default values get ignored", {
  c(x = 3, y = 4) %<-% list(1, 2)

  expect_equal(x, 1)
  expect_equal(y, 2)
})

test_that("assignment by name", {
  c(y=) %<-% list(x = 1, y = 2)

  expect_equal(y, 2)

  c(y=, z=) %<-% list(x = 3, y = 4, z = 5)

  expect_equal(y, 4)
  expect_equal(z, 5)
})

test_that("assignment by name affects positional assignments", {
  c(x=, y) %<-% list(y = 4, x = 2)

  expect_equal(x, 2)
  expect_equal(y, 2)
})
