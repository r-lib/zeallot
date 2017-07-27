#' Destructure an object
#'
#' `destructure` is used during unpacking assignment to coerce an object
#' into a list. Individual elements of the list are assigned to names on the
#' left-hand side of the unpacking assignment expression.
#'
#' @param x An \R object.
#'
#' @details
#'
#' If `x` is atomic `destructure` expects `length(x)` to be 1. If a vector with
#' length greater than 1 is passed to `destructure` an error is raised.
#'
#' New implementations of `destructure` can be very simple. A new
#' `destructure` implementation might only strip away the class of a custom
#' object and return the underlying list structure. Alternatively, an object
#' might destructure into a nested set of values and may require a more
#' complicated implementation. In either case, new implementations must return a
#' list object so \code{\%<-\%} can handle the returned value(s).
#'
#' @seealso \code{\link{\%<-\%}}
#'
#' @export
#' @examples
#' # data frames become a list of columns
#' destructure(
#'   data.frame(x = 0:4, y = 5:9)
#' )
#'
#' # strings are split into list of characters
#' destructure("abcdef")
#'
#' # dates become list of year, month, and day
#' destructure(Sys.Date())
#'
#' # create a new destructure implementation
#' shape <- function(sides = 4, color = "red") {
#'   structure(
#'     list(sides = sides, color = color),
#'     class = "shape"
#'   )
#' }
#'
#' \dontrun{
#' # cannot destructure the shape object yet
#' c(sides, color) %<-% shape()
#' }
#'
#' # implement `destructure` for shapes
#' destructure.shape <- function(x) {
#'   list(x$sides, x$color)
#' }
#'
#' # now we can destructure shape objects
#' c(sides, color) %<-% destructure(shape())
#'
#' sides  # 4
#' color  # "red"
#'
#' c(sides, color) %<-% destructure(shape(3, "green"))
#'
#' sides  # 3
#' color  # 'green'
#'
destructure <- function(x) {
  UseMethod("destructure")
}

#' Included Implementations of `destructure`
#'
#' zeallot includes `destructure` methods for the following classes:
#' `character`, `complex`, `Date`, `data.frame`, and
#' `summary.lm`. See details for how each object is transformed into a
#' list.
#'
#' @inheritParams destructure
#'
#' @details
#'
#' `character` values are split into a list of individual characters.
#'
#' `complex` values are split into a list of two values, the real and the
#' imaginary part.
#'
#' `Date` values are split into a list of three numeric values, the year,
#' month, and day.
#'
#' `data.frame` values are coerced into a list using `as.list`.
#'
#' `summary.lm` values are coerced into a list of values, one element for
#' each of the eleven values returned by `summary.lm`.
#'
#' @return
#'
#' A list of elements from `x`.
#'
#' @seealso [destructure]
#'
#' @keywords internal
#'
#' @name destructure-methods
#' @export
destructure.character <- function(x) {
  assert_destruction(x)
  as.list(strsplit(x, "")[[1]])
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
  as.list(as.numeric(strsplit(format(x, "%Y-%m-%d"), "-", fixed = TRUE)[[1]]))
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
  stop(
    "invalid `%<-%` right-hand side, incorrect number of values",
    call. = FALSE
  )
}

assert_destruction <- function(x) {
  if (length(x) > 1) {
    stop(
      "invalid `destructure` argument, cannot destructure ", class(x),
      " vector of length greater than 1",
      call. = FALSE
    )
  }
}
