#' De-structure an Object
#'
#' \code{destructure} is used during unpacking assignment to coerce an object
#' into a list. Individual elements of the list are assigned to names on the
#' left-hand side of the unpacking assignment expression.
#'
#' @param x An \R object.
#'
#' @details
#'
#' When de-structuring a vector, \code{destructure} expects \code{x} is a single
#' values. If a vector of length greater than 1 is passed to \code{destructure}
#' an error is raised.
#'
#' New implementations of \code{destructure} can be very simple. A new
#' \code{destructure} function might only strip away the class of a custom
#' object and return the underlying list structure. Alternatively, an object
#' might de-structure into a nested set of values and may require a more
#' complicated implementation. In either case, new implementations must return a
#' list object so \code{\%<-\%} can handle the returned value(s).
#'
#' @seealso \code{\link{\%<-\%}}
#'
#' @export
#' @examples
#' # data frames become a list of columns
#' df <- data.frame(x = 0:4, y = 5:9)
#'
#' destructure(df)
#'
#' # strings are split into a list of
#' # individual characters
#' destructure('abcdef')
#'
#' # dates are destructureed into a list of year,
#' # month, and day
#' destructure(Sys.Date())
#'
#' # create a new destructure implementation
#' shape <- function(sides = 4, color = 'red') {
#'   structure(
#'     list(sides = sides, color = color),
#'     class = 'shape'
#'   )
#' }
#'
#' \dontrun{
#' # cannot destructure the shape object yet
#' {sides: color} %<-% shape()
#' }
#'
#' # implement a new destructure function
#' destructure.shape <- function(x) {
#'   list(x$sides, x$color)
#' }
#'
#' # now we can destructure shape objects
#' {sides: color} %<-% destructure(shape())
#' sides  # 4
#' color  # 'red'
#'
#' {sides: color} %<-% destructure(shape(3, 'green'))
#' sides  # 3
#' color  # 'green'
#'
destructure <- function(x) {
  UseMethod('destructure')
}

#' Included Implementations of \code{destructure}
#'
#' \code{zorcher} includes \code{destructure} methods for the following
#' classes: \code{character}, \code{complex}, \code{Date}, \code{data.frame},
#' and \code{summary.lm}. See details for how each object is transformed into a
#' list.
#'
#' @inheritParams destructure
#'
#' @details
#'
#' \code{character} values are split into a list of individual characters.
#'
#' \code{complex} values are split into a list of two values, the real and the
#' imaginary part.
#'
#' \code{Date} values are split into a list of three numeric values, the year,
#' month, and day.
#'
#' \code{data.frame} values are coerced into a list using \code{as.list}.
#'
#' \code{summary.lm} values are coerced into a list of values, one element for
#' each of the eleven values returned by \code{summary.lm}.
#'
#' @return
#'
#' A list of elements from \code{x}.
#'
#' @seealso \code{\link{destructure}}
#'
#' @keywords internal
#'
#' @name destructure-methods
#' @export
destructure.character <- function(x) {
  assert_destruction(x)
  as.list(strsplit(x, '')[[1]])
}

#' @rdname destructure-methods
#' @export
destructure.complex <- function(x) {
  assert_destruction(x)
  list(Re(x), Im(x))
}

#' @rdname destructure-methods
#' @export
destructure.Date <- function(x) {
  assert_destruction(x)
  as.list(as.numeric(strsplit(format(x, '%Y-%m-%d'), '-', fixed = TRUE)[[1]]))
}

#' @rdname destructure-methods
#' @export
destructure.data.frame <- function(x) {
  as.list(x)
}

#' @rdname destructure-methods
#' @export
destructure.summary.lm <- function(x) {
  lapply(x, identity)
}

#' @rdname destructure-methods
#' @export
destructure.default <- function(x) {
  stop('cannot de-structure ', class(x), call. = FALSE)
}

assert_destruction <- function(x) {
  if (length(x) > 1) {
    stop('cannot de-structure ', class(x), ' vector of length greater than 1',
         call. = FALSE)
  }
}
