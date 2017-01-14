#' Unpack an Object
#'
#' \code{unpack} is used during parallel assignment to de-structure an object
#' into a list. Individual elements of this list are then assigned to names on
#' the left-hand side of an expression.
#'
#' @param x An \R object.
#'
#' @details
#'
#' When unpacking an atomic vector, \code{unpack} expects \code{x} is a length 1
#' vector. If an atomic vector of length greater than 1 is passed to
#' \code{unpack} an error is raised.
#'
#' New implementations of \code{unpack} can be very simple. A new \code{unpack}
#' function might simply strip away the class of a custom object and return the
#' underlying list structure. Alternatively, an object might unpack into a
#' nested set of values and may require a more complicated implementation. In
#' either case, new implementations must return an object of length 1 or a list
#' object so \code{\%<-\%} can handle the returned value(s).
#'
#' The default implementation of \code{unpack} raises an informative error.
#'
#' @seealso \code{\link{\%<-\%}}
#'
#' @export
#' @examples
#' # data frames become a list of columns
#' unpack(head(iris))
#'
#' # strings are split into a list of
#' # individual characters
#' unpack('abcdef')
#'
#' # dates are unpacked into a list of year,
#' # month, and day
#' unpack(Sys.Date())
#'
#' # create a new unpack implementation
#' shape <- function(sides = 4, color = 'red') {
#'   structure(
#'     list(sides = sides, color = color),
#'     class = 'shape'
#'   )
#' }
#'
#' \dontrun{
#' # cannot unpack the shape object yet
#' {sides: color} %<-% shape()
#' }
#'
#' # implement a new unpack function
#' unpack.shape <- function(x) {
#'   list(x$sides, x$color)
#' }
#'
#' # now we can unpack shape objects
#' {sides: color} %<-% unpack(shape())
#' sides  # 4
#' color  # 'red'
#'
#' {sides: color} %<-% unpack(shape(3, 'green'))
#' sides  # 3
#' color  # 'green'
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
  as.list(as.numeric(strsplit(format(x, '%Y-%m-%d'), '-', fixed = TRUE)[[1]]))
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
