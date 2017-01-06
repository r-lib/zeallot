context(' * testing items')

test_that('items preserves names', {
  itemized <- items(list(how = 'now', brown = 'cow'))
  itenames <- vapply(itemized, `[[`, character(1), 1)
  vals <- vapply(itemized, `[[`, character(1), 2)
  expect_equal(itenames, c('how', 'brown'))
  expect_equal(vals, c('now', 'cow'))
})

test_that('items uses empty string for missing name', {
  itemized <- items(list(how = 'now', 'cow'))
  itenames <- vapply(itemized, `[[`, character(1), 1)
  vals <- vapply(itemized, `[[`, character(1), 2)
  expect_equal(itenames, c('how', ''))
  expect_equal(vals, c('now', 'cow'))
})

test_that('items uses all empty strings if no name', {
  itemized <- items(list('now', 'cow'))
  itenames <- vapply(itemized, `[[`, character(1), 1)
  vals <- vapply(itemized, `[[`, character(1), 2)
  expect_equal(itenames, c('', ''))
  expect_equal(vals, c('now', 'cow'))
})

test_that('items preserves attributes', {
  el1 <- list('elephant')
  attr(el1, 'location') <- 'coming to town'
  el2 <- list('elevator')
  attr(el2, 'brand') <- 'Schindler'
  my_list <- list(el1, el2)
  itemized <- items(my_list)
  expect_equal(attr(itemized[[1]][[2]], 'location', TRUE), 'coming to town')
  expect_equal(attr(itemized[[2]][[2]], 'brand', TRUE), 'Schindler')
})

