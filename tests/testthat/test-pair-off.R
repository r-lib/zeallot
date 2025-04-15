expect_equalish <- function(object, expected) {
  eval(bquote(expect_equal(.(object), .(expected), check.attributes = FALSE)))
}

test_that("pair_off single item lists", {
  expect_equalish(
    pair_off(list("a"), list(1)),
    list(list("a", 1))
  )
})

test_that("pair_off multi-item lists", {
  expect_equalish(
    pair_off(list("a", "b", "c"), list(1, 2, 3)),
    list(list("a", 1), list("b", 2), list("c", 3))
  )
})

test_that("pair_off list with one nested element", {
  expect_equalish(
    pair_off(list("a", list("b")), list(1, list(2))),
    list(list("a", 1), list("b", 2))
  )

  expect_equalish(
    pair_off(list("a", list("b"), "c"), list(1, list(2), 3)),
    list(list("a", 1), list("b", 2), list("c", 3))
  )

  expect_equalish(
    pair_off(list("a", "b", list("c")), list(1, 2, list(3))),
    list(list("a", 1), list("b", 2), list("c", 3))
  )
})

test_that("pair_off list with multiple nested elements", {
  expect_equalish(
    pair_off(list(list("a"), list("b"), "c"), list(list(1), list(2), 3)),
    list(list("a", 1), list("b", 2), list("c", 3))
  )
})

test_that("pair_off heavily nested list", {
  expect_equalish(
    pair_off(list("a", list("b", list("c", list("d")))), list(1, list(2, list(3, list(4))))),
    list(list("a", 1), list("b", 2), list("c", 3), list("d", 4))
  )
})

test_that("pair_off collects values when ... specified", {
  expect_equalish(
    pair_off(list("a", "...mid", "d"), list(1, 2, 3, 4)),
    list(list("a", 1), list("mid", list(2, 3)), list("d", 4))
  )

  expect_equalish(
    pair_off(list("a", "b", "...rest"), list(1, 2, 3, 4)),
    list(list("a", 1), list("b", 2), list("rest", list(3, 4)))
  )

  expect_equalish(
    pair_off(list("a", "...rest"), list(1, 2, 3, 4)),
    list(list("a", 1), list("rest", list(2, 3, 4)))
  )
})

test_that("pair_off list of multi length items", {
  expect_equalish(
    pair_off(list("a", "b"), list(head(iris), 1:5)),
    list(list("a", head(iris)), list("b", 1:5))
  )
})

test_that("pair_off unpacks strings and data frames", {
  expect_equalish(
    pair_off(list("a", "b", "c"), list("foo")),
    list(list("a", "f"), list("b", "o"), list("c", "o"))
  )
})

test_that("pair_off throws error for atomic vector of length > 1", {
  expect_error(
    pair_off(list("a", "b"), list(character(2))),
    "invalid `destructure` argument, cannot destructure character vector of length greater than 1"
  )
})

test_that("pair_off throws error for flat lists of different lengths", {
  expect_error(
    pair_off(list("a", "b"), list(1)),
    "incorrect number of values"
  )
  expect_error(
    pair_off(list("a", "b"), list(1, 2, 3)),
    "incorrect number of values"
  )
})

test_that("pair_off throws error for nested lists of different lengths, depths", {
  expect_error(
    pair_off(list(list("a"), list("b", "c")), list(list(1), list(2), list(3))),
    "incorrect number of values"
  )
})

test_that("pair_off throws error for extra names, including a collector", {
  expect_error(
    pair_off(list("a", "...mid", "b"), list(1, 2)),
    "incorrect number of values"
  )
})

test_that("pair_off throws error for multiple collectors at one depth", {
  expect_error(
    pair_off(list("a", "...b", "...c"), list(1, 2, 3, 4)),
    "multiple collector variables at the same depth"
  )
})
