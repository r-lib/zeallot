context(" * testing massign")

test_that("massign handles flat lists", {
  massign(list("a"), list(1))
  expect_equal(a, 1)

  massign(list("b", "c"), list(3, "foo"))
  expect_equal(b, 3)
  expect_equal(c, "foo")
})

test_that("massign handles nested lists", {
  massign(list("a", list("b")), list(1, list(2)))
  expect_equal(a, 1)
  expect_equal(b, 2)

  massign(list("c", list("d", "e"), "f"), list(5, list(6, 7), 8))
  expect_equal(c, 5)
  expect_equal(d, 6)
  expect_equal(e, 7)
  expect_equal(f, 8)

  massign(list(list("g", "h"), list("i", "j")), list(list("gee", "ech"), list("ay", "jey")))
  expect_equal(g, "gee")
  expect_equal(h, "ech")
  expect_equal(i, "ay")
  expect_equal(j, "jey")
})

test_that("massign will not destructure flat list", {
  massign(list("a", "b"), list(1, list(2, 3)))
  expect_equal(a, 1)
  expect_equal(b, list(2, 3))
  massign(list(list("c", "d"), "e"), list(list("foo", list("bar", "baz")), "buzz"))
  expect_equal(c, "foo")
  expect_equal(d, list("bar", "baz"))
  expect_equal(e, "buzz")
})

test_that("massign does not assign .", {
  massign(list("."), list("pick me, pick me"))
  expect_false(exists(".", inherits = FALSE))

  massign(list("a", ".", "b"), list(1, 2, 3))
  expect_equal(a, 1)
  expect_false(exists(".", inherits = FALSE))
  expect_equal(b, 3)
})

test_that("massign does not destructure when using rest prefix", {
  massign(list("...rest"), list(1, list(2, 3)))
  expect_equal(rest, list(1, list(2, 3)))

  massign(list("a", "...all"), list(1, list("a", "b")))
  expect_equal(a, 1)
  expect_equal(all, list("a", "b"))

  massign(list("f", "...rest"), list("foo", "bar", "baz"))
  expect_equal(f, "foo")
  expect_equal(rest, list("bar", "baz"))
})

test_that("massign throws error for invalid rest prefix", {
  skip("skipped for now per issue #18")
  expect_error(massign(list("a", "..."), list(1, 2)),
               "invalid collector variable")
})
