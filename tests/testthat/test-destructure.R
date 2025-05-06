test_that("included data.frame implementation", {
  c(mpg, cyl, .., carb) %<-% mtcars

  expect_equal(mpg, mtcars$mpg)
  expect_equal(cyl, mtcars$cyl)
  expect_equal(carb, mtcars$carb)
})

test_that("included summary implementation", {
  summ <- summary(lm(mpg ~ cyl, mtcars))

  c(., terms) %<-% summ

  expect_equal(terms, summ$terms)
})

test_that("custom implementation", {
  registerS3method("destructure", "Date", function(x) {
    ymd <- strftime(x, "%Y-%m-%d")
    pieces <- strsplit(ymd, "-", fixed = TRUE)
    as.numeric(pieces[[1]])
  })

  c(year, month, day) %<-% as.Date("2000-01-10")

  expect_equal(year, 2000)
  expect_equal(month, 1)
  expect_equal(day, 10)
})
