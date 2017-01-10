context(' * testing enumerate')

test_that('enumerate preserves length', {
  my_list <- list('cat', 'dog', 'rabbit', 'sheep')

  expect_equal(length(my_list), length(enumerate(my_list)))
  expect_equal(1:4, vapply(enumerate(my_list), `[[`, numeric(1), 1))

  {{i: animal}: ...rest} %<-% enumerate(my_list)
  expect_equal(i, 1)
  expect_equal(animal, 'cat')
})

test_that('enumerate preserves values and order of values', {
  my_list <- list('cat', 'dog', 'rabbit', 'sheep')

  expect_equal(my_list, lapply(enumerate(my_list), `[[`, 2))
})
