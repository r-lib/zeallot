test_that("collecting from bare atomics simplifies", {
	v <- c(a = 1, b = 2, c = 3, d = 4)

	c(x, ..y) %<-% v

	expect_identical(x, v[[1]])
	expect_identical(y, v[2:4])
	expect_identical(names(y), names(v)[2:4])

	c(..x, y) %<-% v

	expect_identical(x, v[1:3])
	expect_identical(names(x), names(v)[1:3])
	expect_identical(y, v[[4]])

	c(x, ..y, z) %<-% v

	expect_identical(x, v[[1]])
	expect_identical(z, v[[4]])
	expect_identical(y, v[2:3])
	expect_identical(names(y), names(v)[2:3])
})

test_that("collecting from S3 atomics returns list", {
	v <- structure(
		1:4,
		class = "test_atomic",
		names = letters[1:4]
	)

	c(x, ..y) %<-% v

	expect_identical(x, v[[1]])
	expect_null(attributes(x))
	expect_identical(y, list(b = v[[2]], c = v[[3]], d = v[[4]]))
	expect_identical(names(y), letters[2:4])

	c(..x, y) %<-% v

	expect_identical(x, list(a = v[[1]], b = v[[2]], c = v[[3]]))
	expect_identical(names(x), letters[1:3])
	expect_identical(y, v[[4]])

	c(x, ..y, z) %<-% v

	expect_identical(x, v[[1]])
	expect_identical(z, v[[4]])
	expect_identical(y, list(b = v[[2]], c = v[[3]]))
})
