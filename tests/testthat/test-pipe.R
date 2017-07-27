context(' * testing %>% expressions')

test_that('%<-% and %>% caveat', {
  skip('must wrap piped expressions in parentheses')
})

test_that('%<-% assign magrittr chain vector', {
  skip_if_not_installed('magrittr')

  library(magrittr)

  expect_silent(
    c(a, b, c, d, e) %<-% (
      1:5 %>%
        vapply(`+`, numeric(1), 5) %>%
        as.character
    )
  )
  expect_equal(a, '6')
  expect_equal(b, '7')
  expect_equal(c, '8')
  expect_equal(d, '9')
  expect_equal(e, '10')
})

test_that('%<-% assign magrittr chain list', {
  skip_if_not_installed('magrittr')

  library(magrittr)

  expect_silent(
    c(a, ...b) %<-% (
      1:5 %>%
        vapply(`==`, logical(1), 1) %>%
        as.list
    )
  )

  expect_equal(a, TRUE)
  expect_equal(b, list(FALSE, FALSE, FALSE, FALSE))
})
