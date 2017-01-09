context(' * testing assignment operator')

test_that('%<-% can behave like <-', {
  a %<-% 1
  expect_equal(a, 1)

  {b} %<-% 2
  expect_equal(b, 2)
})

test_that('%<-% assigns NULL', {
  a %<-% NULL
  expect_null(a)
})

test_that('%<-% does not unpack vector', {
  expect_error(a: b %<-% c('hello', 'world'), 'expecting 2 values, but found 1')
  a %<-% c('hello', 'world')
  expect_equal(a, c('hello', 'world'))
})

test_that('%<-% unpacks list', {
  a: b %<-% list('hello', 3030)
  expect_equal(a, 'hello')
  expect_equal(b, 3030)
})

test_that('%<-% unpacks list of vectors', {
  a: b %<-% list(c('red', 'fish'), c(TRUE, FALSE))
  expect_equal(a, c('red', 'fish'))
  expect_equal(b, c(TRUE, FALSE))
})

test_that('%<-% unpacks list of lists', {
  a: b %<-% list(list('hello', 'world'), list('goodnight', 'moon'))
  expect_equal(a, list('hello', 'world'))
  expect_equal(b, list('goodnight', 'moon'))
})

test_that('%<-% will not force unpacking', {
  a %<-% list(list('hello', 'world'), 1:5)
  expect_equal(a[[1]], list('hello', 'world'))
  expect_equal(a[[2]], 1:5)

  b %<-% list(list('hello', 'world'), 1:5)
  expect_equal(b[[1]], list('hello', 'world'))
  expect_equal(b[[2]], 1:5)
})

test_that('%<-% assigns nested names', {
  a: {b: c} %<-% list('hello', list('moon', c('world', '!')))
  expect_equal(a, 'hello')
  expect_equal(b, 'moon')
  expect_equal(c, c('world', '!'))
})

test_that('%<-% handles S3 objects with underlying list structure', {
  shape <- function(sides = 4, color = 'red') {
    structure(
      list(
        sides = sides,
        color = color
      ),
      class = 'shape'
    )
  }

  a %<-% shape()
  expect_s3_class(a, 'shape')

  expect_error(b: c %<-% shape(), 'expecting 2 values, but found 1')

  b: c %<-% list(shape(3, 'green'), shape(1, 'blue'))
  expect_equal(b$sides, 3)
  expect_equal(b$color, 'green')
  expect_equal(c$sides, 1)
  expect_equal(c$color, 'blue')
})

test_that('%<-% skips values using .', {
  a: .: c %<-% list(1, 2, 3)
  expect_equal(a, 1)
  expect_false(exists('.', inherits = FALSE))
  expect_equal(c, 3)


  d: {e: .: f}: g %<-% list(4, list(5, 6, 7), 8)
  expect_equal(d, 4)
  expect_equal(e, 5)
  expect_false(exists('.', inherits = FALSE))
  expect_equal(f, 7)
  expect_equal(g, 8)
})

test_that('%<-% throws error if unequal nesting', {
  expect_error(a: b %<-% list(1), 'expecting 2 values, but found 1')
  expect_error(a: b: c %<-% list(1), 'expecting 3 values, but found 1')
  expect_error(a: b: c %<-% list(1, 2), 'expecting 3 values, but found 2')

  expect_error({a: b}: {c: d: e} %<-% list(list(1, 2), list(3, 4)),
               'expecting 3 values, but found 2')
})
