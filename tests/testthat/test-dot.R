context(' * testing name structure')

test_that('. produces expected structure', {
  expect_equal(.(a, b), list('a', 'b'))
  expect_equal(.(a, .(b, c)), list('a', list('b', 'c')), .(a, .(b, c)))
  expect_equal(.(.(a, b), c, .(d)), list(list('a', 'b'), 'c', list('d')))
})

test_that('. does not complain about skipping with ..', {
  expect_equal(.(a, .., b), list('a', '..', 'b'))
})