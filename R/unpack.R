unpack <- function(x) {
  UseMethod('unpack')
}

unpack.character <- function(x) {
  assert_length_of_1(x)
  as.list(strsplit(x, '')[[1]])
}

unpack.numeric <- function(x) {
  assert_length_of_1(x)
  x
}

unpack.logical <- function(x) {
  assert_length_of_1(x)
  x
}

unpack.complex <- function(x) {
  assert_length_of_1(x)
  list(Re(x), Im(x))
}

unpack.raw <- function(x) {
  assert_length_of_1(x)
  x
}

unpack.NULL <- function(x) {
  x
}

unpack.Date <- function(x) {
  if (length(x) > 1) {
    stop('cannot unpack Date with length greater than 1', call. = FALSE)
  }
  as.list(strsplit(format(x, '%Y-%m-%d'), '-', fixed = TRUE)[[1]])
}

unpack.data.frame <- function(x) {
  as.list(x)
}

unpack.summary.lm <- function(x) {
  lapply(x, identity)
}

unpack.default <- function(x) {
  stop('cannot unpack object of class ', class(x), call. = FALSE)
}

assert_length_of_1 <- function(x) {
  if (length(x) > 1) {
    stop('cannot unpack ', class(x), ' vector of length greater than 1',
         call. = FALSE)
  }
}
