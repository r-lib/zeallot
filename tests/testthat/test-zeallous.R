test_that("basic usage", {
  skip_if_not_installed("codetools")

  nums <- function() {
    c(one, two) %<-% list(1, 2)
    c(one, two, three)
  }

  problems <- ""

  codetools::checkUsage(
    fun = nums,
    report = function(x) {
      problems <<- paste0(problems, x)
    }
  )

  expect_false(grepl("one", problems))
  expect_false(grepl("two", problems))
  expect_true(grepl("three", problems))
})

test_that("more variables left-side", {
  skip_if_not_installed("codetools")

  nums <- function() {
    c(one, two, three) %<-% list(1, 2, 3)
    c(one, two, three)
  }

  problems <- ""

  codetools::checkUsage(
    fun = nums,
    report = function(x) {
      problems <<- paste0(problems, x)
    }
  )

  expect_false(grepl("one", problems))
  expect_false(grepl("two", problems))
  expect_false(grepl("three", problems))
})

test_that("more complex right-side", {
  skip_if_not_installed("codetools")

  nums <- function() {
    c(one, two) %<-% {
      list(1, 2)
    }

    c(one, two)
  }

  problems <- ""

  codetools::checkUsage(
    fun = nums,
    report = function(x) {
      problems <<- paste0(problems, x)
    }
  )

  expect_false(grepl("one", problems))
  expect_false(grepl("two", problems))
})

test_that("collectors are properly recognized", {
  skip_if_not_installed("codetools")

  func <- function() {
    c(first, ...middle, last) %<-% list(1, 2, 3, 4)

    c(first, middle, last)
  }

  problems <- ""

  codetools::checkUsage(
    fun = nums,
    report = function(x) {
      problems <<- paste0(problems, x)
    }
  )

  expect_false(grepl("first", problems))
  expect_false(grepl("middle", problems))
  expect_false(grepl("last", problems))

  # func <- function() {
  #   c(first, ...) %<-% list(1, 2, 3, 4)
  #
  #   last
  #   first
  # }
  #
  # problems <- ""
  #
  # codetools::checkUsage(
  #   fun = nums,
  #   report = function(x) {
  #     problems <<- paste0(problems, x)
  #   }
  # )
  #
  # expect_false(grepl("first", problems))
  # expect_false(grepl("...", problems))
})

test_that("if statement one-liner", {
  skip_if_not_installed("codetools")

  if_one_liner <- function() {
    if (TRUE) c(x, y) %<-% list(1, 2)

    c(x, y)
  }

  problems <- ""

  codetools::checkUsage(
    fun = if_one_liner,
    report = function(x) {
      problems <<- paste0(problems, x)
    }
  )

  expect_false(grepl("x", problems))
  expect_false(grepl("y", problems))
})
