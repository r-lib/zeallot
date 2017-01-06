context(' * testing name structure')

test_that('. produces expected structure', {
  expect_equal(.(a), list('a'))
  expect_equal(.(`a`), list('a'))
  expect_equal(.(a, b), list('a', 'b'))
  expect_equal(.(a, .(b, c)), list('a', list('b', 'c')), .(a, .(b, c)))
  expect_equal(.(.(a, b), c, .(d)), list(list('a', 'b'), 'c', list('d')))
})

test_that('. does not complain about skipping with ..', {
  expect_equal(.(a, .., b), list('a', '..', 'b'))
})

test_that('. throws error for calls other than .', {
  expect_error(.(mean(a), b), 'unexpected call mean')
  expect_error(.(quote(a)), 'unexpected call quote')
})

test_that('. throws error for non-name arguments', {
  expect_error(.('a', b), 'unexpected character')
  expect_error(.(b, 1), 'unexpected numeric')
})
