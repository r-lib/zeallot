#' Unpack an Object
#'
#' \code{unpack} is used during parallel assignment to de-structure an object
#' and assign individual elements of a value to multiple names.
#'
#' @param x An \R object.
#'
#' @details
#'
#' New implementations of \code{unpack} can be very simple. If an object does
#' not have elements to de-structure then simply return the object. Be sure
#' to return an object of length 1 or a list object so \code{\%<-\%} can handle
#' the returned value(s).
#'
#' The default implementation of \code{unpack} raises an informative error.
#'
#' @seealso \code{\link{\%<-\%}}
#'
#' @keywords internal
#' @export
#' @examples
#' # data frames become a list of columns
#' unpack(head(iris))
#'
#' # strings become a list of individual
#' # characters
#' unpack('abcdef')
#'
#' # creating a new unpack implementation
#' shape <- function(sides = 4, color = 'red') {
#'   structure(
#'     list(sides = sides, color = color),
#'     class = 'shape'
#'   )
#' }
#'
#' \dontrun{
#' {sides: color} %<-% shape()
#' }
#'
#' unpack.shape <- function(x) {
#'   list(x$sides, x$color)
#' }
#'
#' {sides: color} %<-% unpack(shape())
#' {sides: color} %<-% unpack(shape(3, 'green'))
#'
unpack <- function(x) {
  UseMethod('unpack')
}

#' @rdname unpack
#' @export
unpack.character <- function(x) {
  assert_unpackable(x)
  as.list(strsplit(x, '')[[1]])
}

#' @rdname unpack
#' @export
unpack.numeric <- function(x) {
  assert_unpackable(x)
  x
}

#' @rdname unpack
#' @export
unpack.logical <- function(x) {
  assert_unpackable(x)
  x
}

#' @rdname unpack
#' @export
unpack.complex <- function(x) {
  assert_unpackable(x)
  list(Re(x), Im(x))
}

#' @rdname unpack
#' @export
unpack.raw <- function(x) {
  assert_unpackable(x)
  x
}

#' @rdname unpack
#' @export
unpack.NULL <- function(x) {
  x
}

#' @rdname unpack
#' @export
unpack.Date <- function(x) {
  assert_unpackable(x)
  as.list(strsplit(format(x, '%Y-%m-%d'), '-', fixed = TRUE)[[1]])
}

#' @rdname unpack
#' @export
unpack.data.frame <- function(x) {
  as.list(x)
}

#' @rdname unpack
#' @export
unpack.summary.lm <- function(x) {
  lapply(x, identity)
}

#' @rdname unpack
#' @export
unpack.default <- function(x) {
  stop('cannot unpack object of class ', class(x), call. = FALSE)
}

assert_unpackable <- function(x) {
  if (length(x) > 1) {
    stop('cannot unpack ', class(x), ' vector of length greater than 1',
         call. = FALSE)
  }
}
