test_that("error halts assignment", {
  expect_error(c(x, y) %<-% c(1, b))

  expect_error(x, "object 'x' not found")
  expect_error(y, "object 'y' not found")
})

test_that("force non-zeallot errors early", {
  g <- function() {
    stop("stop here")
    1
  }

  f <- function() {
    g()
  }

  err <- expect_error(c(x, y) %<-% list(1, f()))

  err_trace <- lapply(rev(err$trace$call), deparse)

  expect_equal(err_trace[[1]], "g()")
  expect_equal(err_trace[[2]], "f()")
  expect_equal(err_trace[[3]], "force(value)")
  expect_equal(err_trace[[4]], "c(x, y) %<-% list(1, f())")
})

test_that("warning allows assignment", {
  f <- function() {
    warning("giving an f")
    "f"
  }

  expect_warning(c(x) %<-% list(f()), "giving an f")

  expect_equal(x, "f")
})

test_that("message allows assignment", {
  echo <- function(expr) {
    message(deparse(substitute(expr)))
    expr
  }

  expect_message(
    c(x, y) %<-% c(1, echo(1 + 1)),
    "1 + 1",
    fixed = TRUE
  )

  expect_equal(x, 1)
  expect_equal(y, 2)
})
