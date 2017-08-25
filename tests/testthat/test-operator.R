context(" * testing assignment operator")

test_that("%<-% can perform standard assignment", {
  a %<-% "foo"
  expect_equal(a, "foo")
  b %<-% list(1, 2, 3)
  expect_equal(b, list(1, 2, 3))
})

test_that("%<-% handles single name assigned single value", {
  c(a) %<-% list("foo")
  expect_equal(a, "foo")

  c(b) %<-% c("bar")
  expect_equal(b, "bar")
})

test_that("%<-% assigns collected vector as vector", {
  c(a, ...b) %<-% 1:5
  expect_equal(a, 1)
  expect_equal(b, 2:5)

  c(...c, d) %<-% c(TRUE, FALSE, FALSE)
  expect_equal(c, c(TRUE, FALSE))
  expect_equal(d, FALSE)
})

test_that("%<-% unpacks vector", {
  c(a, b) %<-% c("hello", "world")
  expect_equal(a, "hello")
  expect_equal(b, "world")
})

test_that("%<-% does not unpack nested vectors", {
  expect_error(
    c(c(a, b), c(d, e)) %<-% list(c(1, 2), c(3, 4)),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )
})

test_that("%<-% unpacks list", {
  c(a, b) %<-% list("hello", 3030)
  expect_equal(a, "hello")
  expect_equal(b, 3030)
})

test_that("%<-% unpack only top-level", {
  c(a, b) %<-% list(list("hello", "world"), list("goodnight", "moon"))
  expect_equal(a, list("hello", "world"))
  expect_equal(b, list("goodnight", "moon"))

  c(d, e) %<-% list(list("hello", "world"), 1:5)
  expect_equal(d, list("hello", "world"))
  expect_equal(e, 1:5)
})

test_that("%<-% unpacks nested values using nested names", {
  c(a, c(b, d)) %<-% list("hello", list("moon", list("world", "!")))
  expect_equal(a, "hello")
  expect_equal(b, "moon")
  expect_equal(d, list("world", "!"))
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
    c(a, b) %<-% shape(),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )
})

test_that("%<-% skips values using .", {
  c(a, ., c) %<-% list(1, 2, 3)
  expect_equal(a, 1)
  expect_false(exists(".", inherits = FALSE))
  expect_equal(c, 3)


  c(d, c(e, ., f), g) %<-% list(4, list(5, 6, 7), 8)
  expect_equal(d, 4)
  expect_equal(e, 5)
  expect_false(exists(".", inherits = FALSE))
  expect_equal(f, 7)
  expect_equal(g, 8)
})

test_that("%<-% skips multiple values using ...", {
  c(a, ...) %<-% list(1, 2, 3, 4)
  expect_equal(a, 1)

  c(..., b) %<-% list(1, 2, 3, 4)
  expect_equal(b, 4)
})

test_that("%<-% assigns default values", {
  c(a, b = 1) %<-% c(3)
  expect_equal(a, 3)
  expect_equal(b, 1)

  c(d, e = iris, f = 3030) %<-% 5
  expect_equal(d, 5)
  expect_equal(e, iris)
  expect_equal(f, 3030)
})

test_that("%<-% assign default value of NULL", {
  c(a, b = NULL) %<-% c(3)
  expect_equal(a, 3)
  expect_equal(b, NULL)
})

test_that("%<-% default values do not override specified values", {
  c(a = 1, b = 4) %<-% 2
  expect_equal(a, 2)
  expect_equal(b, 4)

  c(d = 5, e = 6) %<-% c(8, 9)
  expect_equal(d, 8)
  expect_equal(e, 9)
})

test_that("%<-% throws error on unequal number of variables and values", {
  expect_error(
    c(a, b) %<-% list(1),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )

  expect_error(
    c(a, b, c) %<-% list(1),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )

  expect_error(
    c(a, b, c) %<-% list(1, 2),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )

  expect_error(
    c(c(a, b), c(d, e, f)) %<-% list(list(1, 2), list(3, 4)),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )
})

test_that("%<-% throws error when invalid calls on LHS", {
  expect_error(
    c(a + b) %<-% list(1),
    "invalid `%<-%` left-hand side, unexpected call `+`",
    fixed = TRUE
  )

  expect_error(
    c(a, c(quote(d), c)) %<-% list(1, list(2, 3)),
    "invalid `%<-%` left-hand side, unexpected call `quote`"
  )
})

test_that("%<-% throws error when blank variable names", {
  expect_error(
    c(, a) %<-% c(1, 2),
    "invalid `%<-%` left-hand side, found empty variable, check for extraneous commas"
  )
})

test_that('%<-% throws error when invalid "variables" on LHS', {
  expect_error(
    c(mean(1, 2), a) %<-% list(1, 2),
    "invalid `%<-%` left-hand side, unexpected call `mean`"
  )

  expect_error(
    c(a, f()) %<-% list(1, 2),
    "invalid `%<-%` left-hand side, expected symbol, but found call"
  )

  expect_error(
    f() %<-% list(1),
    "invalid `%<-%` left-hand side, expected symbol, but found call"
  )
})

test_that("%<-% throws error when assigning empty list", {
  expect_error(
    c(a, b) %<-% list(),
    "invalid `%<-%` right-hand side, incorrect number of values"
  )
})

test_that("%->% properly calls `multi_assign`", {
  c(1, 2) %->% c(x, y)
  expect_equal(x, 1)
  expect_equal(y, 2)
})

test_that("%->% errors include %->% in message, flips lhs and rhs", {
  expect_error(
    c(1, 2) %->% {x:y},
    "invalid `%->%` right-hand side, unexpected call `{`",
    fixed = TRUE
  )

  expect_error(
    1 %->% c(x, y),
    "invalid `%->%` left-hand side, incorrect number of values",
    fixed = TRUE
  )
})
