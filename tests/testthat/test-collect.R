test_that("collect throws error if no collector variable specified", {
  expect_error(collect(list("a", "b"), list(1, 2)), "no collector variable")
})

test_that("collect names and values of equal lengths", {
  expect_equal(collect(list("a", "...b"), list(1, 2)), list(1, 2))
})

test_that("collect beginning of values", {
  expect_equal(
    collect(list("...first", "a"), list(1, 2, 3)),
    list(list(1, 2), 3)
  )

  expect_equal(
    collect(list("...first", "a", "b"), as.list(1:5)),
    list(list(1, 2, 3), 4, 5)
  )
})

test_that("collect middle of values", {
  expect_equal(
    collect(list("a", "...mid", "b"), list(1, 2, 3, 4)),
    list(1, list(2, 3), 4))

  expect_equal(
    collect(list("a", "b", "...mid", "c"), as.list(1:6)),
    list(1, 2, list(3, 4, 5), 6)
  )

  expect_equal(
    collect(list("a", "...mid", "b", "c"), as.list(1:6)),
    list(1, list(2, 3, 4), 5, 6)
  )

  expect_equal(
    collect(list("a", "b", "...mid", "c", "d"), as.list(1:6)),
    list(1, 2, list(3, 4), 5, 6)
  )
})

test_that("collect rest of values", {
  expect_equal(
    collect(list("a", "...rest"), list(1, 2, 3)),
    list(1, list(2, 3))
  )

  expect_equal(
    collect(list("a", "b", "...rest"), list(1, 2, 3, 4)),
    list(1, 2, list(3, 4))
  )
})
