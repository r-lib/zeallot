#' Destructure an object
#'
#' `destructure` is used during unpacking assignment to coerce an object into a
#' list. Individual elements of the list are assigned to names on the left-hand
#' side of the unpacking assignment expression.
#'
#' @param x An \R object.
#'
#' @details
#'
#' New implementations of `destructure` can be very simple. A new `destructure`
#' implementation might only strip away the class of a custom object and return
#' the underlying list structure. Alternatively, an object might destructure
#' into a nested set of values and may require a more complicated
#' implementation. In either case, new implementations must return a list object
#' so \code{\%<-\%} can handle the returned value(s).
#'
#' @seealso \code{\link{\%<-\%}}
#'
#' @export
#'
#' @examples
#'
#' # Data frames become a list of columns
#' destructure(faithful)
#'
#' # A simple shape class
#' shape <- function(sides = 4, color = "red") {
#'   structure(
#'     list(sides = sides, color = color),
#'     class = "shape"
#'   )
#' }
#'
#' \dontrun{
#' # Cannot destructure the shape object _yet_
#' c(sides, color) %<-% shape()
#' }
#'
#' # Implement a new destructure method for the shape class
#' destructure.shape <- function(x) {
#'   unclass(x)
#' }
#'
#' # Now we can destructure shape objects
#' c(sides, color) %<-% shape()
#'
#' c(sides, color) %<-% shape(3, "green")
#'
destructure <- function(x) {
  UseMethod("destructure")
}

#' @rdname destructure
#' @export
destructure.data.frame <- function(x) {
  as.list(x)
}

#' @rdname destructure
#' @export
destructure.summary.lm <- function(x) {
  unclass(x)
}

#' @rdname destructure
#' @export
destructure.default <- function(x) {
  as.list(x)
}
