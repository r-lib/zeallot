context(' * testing assignment operator')

test_that('%<-% acts like <- if bare variable on lhs', {
  a %<-% 1
  expect_equal(a, 1)
})

test_that('%<-% assigns NULL', {
  a %<-% NULL
  expect_null(a)
})

test_that('%<-% throws error if value is list, but no braces on lhs', {
  expect_error(a: b %<-% list(1, 2), 'expecting vector of values, but found list')
})

test_that('%<-% throws error if value is vector, but lhs has braces', {
  expect_error({a: b} %<-% c(1, 2), 'expecting list of values, but found vector')
})

test_that('%<-% unpacks vector', {
  a: b %<-% c('hello', 'world')
  expect_equal(a, 'hello')
  expect_equal(b, 'world')
})

test_that('%<-% cannot unpack nested vectors', {
  expect_error({{a: b}: {c: d}} %<-% list(c(1, 2), c(3, 4)), 'expecting 2 values, but found 1')
})

test_that('%<-% unpacks list', {
  {a: b} %<-% list('hello', 3030)
  expect_equal(a, 'hello')
  expect_equal(b, 3030)
})

test_that('%<-% unpacks list of lists', {
  {a: b} %<-% list(list('hello', 'world'), list('goodnight', 'moon'))
  expect_equal(a, list('hello', 'world'))
  expect_equal(b, list('goodnight', 'moon'))
})

test_that('%<-% unpacks internal vector to list', {
  {a: b} %<-% list(list('hello', 'world'), 1:5)
  expect_equal(a, list('hello', 'world'))
  expect_equal(b, 1:5)
})

test_that('%<-% assigns nested names', {
  {a: {b: c}} %<-% list('hello', list('moon', list('world', '!')))
  expect_equal(a, 'hello')
  expect_equal(b, 'moon')
  expect_equal(c, list('world', '!'))
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

  expect_error(a %<-% shape(), 'too many values to unpack')

  {a: b} %<-% shape()
  expect_equal(a, 4)
  expect_equal(b, 'red')

  {c: d} %<-% list(shape(3, 'green'), shape(1, 'blue'))
  expect_equal(c$sides, 3)
  expect_equal(c$color, 'green')
  expect_equal(d$sides, 1)
  expect_equal(d$color, 'blue')
})

test_that('%<-% skips values using .', {
  {a: .: c} %<-% list(1, 2, 3)
  expect_equal(a, 1)
  expect_false(exists('.', inherits = FALSE))
  expect_equal(c, 3)


  {d: {e: .: f}: g} %<-% list(4, list(5, 6, 7), 8)
  expect_equal(d, 4)
  expect_equal(e, 5)
  expect_false(exists('.', inherits = FALSE))
  expect_equal(f, 7)
  expect_equal(g, 8)
})

test_that('%<-% throws error if unequal nesting', {
  expect_error({a: b} %<-% list(1), 'expecting 2 values, but found 1')
  expect_error({a: b: c} %<-% list(1), 'expecting 3 values, but found 1')
  expect_error({a: b: c} %<-% list(1, 2), 'expecting 3 values, but found 2')

  expect_error({{a: b}: {c: d: e}} %<-% list(list(1, 2), list(3, 4)),
               'expecting 3 values, but found 2')
})
