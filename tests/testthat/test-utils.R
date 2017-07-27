context(" * testing utils")

test_that("is_Date returns TRUE for date objects", {
  expect_true(is_Date(Sys.Date()))
})

test_that("is_list returns TRUE for list object", {
  expect_true(is_list(list(1, 2, 3)))
})

test_that("is_list returns FALSE for S3 objects", {
  sumry <- summary(lm(mpg ~ disp, data = mtcars))
  expect_false(is_list(sumry))
})

test_that("is_list returns FALSE for data frames", {
  expect_false(is_list(mtcars))
})

test_that("car throws error for non-list or 0 length list", {
  expect_error(car(1), "cons")
  expect_error(car(list()), "length")
})

test_that("car returns first element of list", {
  expect_equal(car(list(1, 2)), 1)
  expect_equal(car(list(list(1, 2), 3)), list(1, 2))
})
