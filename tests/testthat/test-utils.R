context(" * testing utils")

test_that("is_list returns TRUE for list object", {
  expect_true(is_list(list(1, 2, 3)))
})

test_that("is_list returns FALSE for objects with multiple classes", {
  expect_false(is_list(summary(x ~ y)))
  expect_silent(is_list(summary(x ~ y)))
})

test_that("is_list returns FALSE for S3 objects", {
  sumry <- summary(lm(mpg ~ disp, data = mtcars))
  expect_false(is_list(sumry))
})

test_that("is_list returns FALSE for data frames", {
  expect_false(is_list(mtcars))
})

test_that("is_extract_op returns TRUE for valid operators", {
  expect_true(is_extract_op("$"))
  expect_true(is_extract_op("["))
  expect_true(is_extract_op("[["))
})

test_that("is_extract_op returns FALSE for 0 length argument", {
  expect_false(is_extract_op(character(0)))
  expect_false(is_extract_op(NULL))
})

test_that("is_valid_call returns TRUE for all valid calls", {
  expect_true(is_valid_call("c"))
  expect_true(is_valid_call("="))
  expect_true(is_valid_call("$"))

  expect_false(is_valid_call(2))
  expect_false(is_valid_call("mean"))
})

test_that("is_valid_call returns FALSE for 0 length argument", {
  expect_false(is_valid_call(NULL))
  expect_false(is_valid_call(integer(0)))
})

test_that("car throws error for non-list or 0 length list", {
  expect_error(car(1), "cons")
  expect_error(car(list()), "length")
})

test_that("car returns first element of list", {
  expect_equal(car(list(1, 2)), 1)
  expect_equal(car(list(list(1, 2), 3)), list(1, 2))
})

test_that("traverse_to_extractee gets flat and nested extractees", {
  s1 <- substitute(x[[1]])
  expect_equal(as.character(traverse_to_extractee(s1)), "x")

  s2 <- substitute(y[[1]][[3030]])
  expect_equal(as.character(traverse_to_extractee(s2)), "y")
})
