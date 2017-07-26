context(" * testing assignment operator")

test_that("%<-% can perform standard assignment", {
  a %<-% "foo"
  expect_equal(a, "foo")
  b %<-% list(1, 2, 3)
  expect_equal(b, list(1, 2, 3))
})

test_that("%<-% handles list of 1 name and list of 1 value", {
  {a} %<-% list("foo")
  expect_equal(a, "foo")

  expect_error(
    {a} %<-% "foo",
    "expecting list of values, but found vector"
  )
})

test_that("%<-% throws error if value is list, but no braces on lhs", {
  expect_error(a: b %<-% list(1, 2), "expecting vector of values, but found list")
})

test_that("%<-% throws error if value is vector, but lhs has braces", {
  expect_error({a: b} %<-% c(1, 2), "expecting list of values, but found vector")
})

test_that("%<-% preserves class when collecting atomic vectors", {
  a : ...b %<-% 1:5
  expect_equal(a, 1)
  expect_equal(b, 2:5)

  ...c : d %<-% c(TRUE, FALSE, FALSE)
  expect_equal(c, c(TRUE, FALSE))
  expect_equal(d, FALSE)
})

test_that("%<-% requires braces when destructuring single object", {
  {a : b} %<-% faithful
  expect_equal(a, faithful[[1]])
  expect_equal(b, faithful[[2]])

  expect_error(c : d %<-% faithful, "expecting vector of values, but found data.frame")
})

test_that("%<-% destructures vector", {
  a : b %<-% c("hello", "world")
  expect_equal(a, "hello")
  expect_equal(b, "world")
})

test_that("%<-% cannot destructure nested vectors", {
  expect_error(
    {{a : b} : {c : d}} %<-% list(c(1, 2), c(3, 4)),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )
})

test_that("%<-% destructure list", {
  {a : b} %<-% list("hello", 3030)
  expect_equal(a, "hello")
  expect_equal(b, 3030)
})

test_that("%<-% destructure list of lists", {
  {a: b} %<-% list(list("hello", "world"), list("goodnight", "moon"))
  expect_equal(a, list("hello", "world"))
  expect_equal(b, list("goodnight", "moon"))
})

test_that("%<-% destructure internal vector to list", {
  {a: b} %<-% list(list("hello", "world"), 1:5)
  expect_equal(a, list("hello", "world"))
  expect_equal(b, 1:5)
})

test_that("%<-% assigns nested names", {
  {a: {b: c}} %<-% list("hello", list("moon", list("world", "!")))
  expect_equal(a, "hello")
  expect_equal(b, "moon")
  expect_equal(c, list("world", "!"))
})

test_that("%<-% handles S3 objects with underlying list structure", {
  shape <- function(sides = 4, color = "red") {
    structure(
      list(
        sides = sides,
        color = color
      ),
      class = "shape"
    )
  }

  expect_error(
    {a : b} %<-% shape(),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )
})

test_that("%<-% skips values using .", {
  {a: .: c} %<-% list(1, 2, 3)
  expect_equal(a, 1)
  expect_false(exists(".", inherits = FALSE))
  expect_equal(c, 3)


  {d: {e: .: f}: g} %<-% list(4, list(5, 6, 7), 8)
  expect_equal(d, 4)
  expect_equal(e, 5)
  expect_false(exists(".", inherits = FALSE))
  expect_equal(f, 7)
  expect_equal(g, 8)
})

test_that("%<-% skips multiple values using ...", {
  { a : ... } %<-% list(1, 2, 3, 4)
  expect_equal(a, 1)
  { ... : b } %<-% list(1, 2, 3, 4)
  expect_equal(b, 4)
})

test_that("%<-% throws error if unequal nesting", {
  expect_error(
    {a : b} %<-% list(1),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )
  expect_error(
    {a : b : c} %<-% list(1),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )
  expect_error(
    {a : b : c} %<-% list(1, 2),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )

  expect_error(
    {{a : b} : {c : d : e}} %<-% list(list(1, 2), list(3, 4)),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )
})

test_that("%<-% throws error if invalid calls used on LHS", {
  expect_error(
    {a + b} %<-% list(1),
    "invalid `%<-%` left-hand side, unexpected call `+`",
    fixed = TRUE
  )
  expect_error(
    {a : {quote(d) : c}} %<-% list(1, list(2, 3)),
    "invalid `%<-%` left-hand side, unexpected call `quote`"
  )
  expect_error(
    {mean(1, 2) : a} %<-% list(1, 2),
    "invalid `%<-%` left-hand side, unexpected call `mean`"
  )
})
