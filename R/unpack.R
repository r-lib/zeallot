#' Unpack an Object
#'
#' The \code{unpack} function coerces an object to a list and is used to force
#' vectors and S3 objects to unpack during parallel assignment. The \code{items}
#' function unpacks a named object into a list of name, value pairs. The
#' \code{enumerate} function unpacks an object into a list of index, value
#' pairs.
#'
#' @param x An \R object.
#' @param n A numeric specifying the number of elements to unpack from \code{x},
#'   defaults to \code{NULL} in which case all elements are unpacked.
#'
#' @details
#'
#' If \code{n} is less than the number of elements in \code{x} than the first
#' \code{n} elements are unpacked as well as an additional value. This final
#' value is a list of the remaining unpacked elements of \code{x}. If \code{n}
#' is greater than the number of elements in \code{x} all elements are unpacked.
#' See below for examples.
#'
#' @return
#'
#' For \code{unpack} a list created by \code{\link{lapply}}-ing
#' \code{\link{identity}} to \code{x}. If \code{n} is specified and is less than
#' the number of elements in \code{x}, a list of length \code{n + 1} is returned
#' where the first \code{n} elements are unpacked and the last list value is a
#' list containing the remaining unpacked values of \code{x}.
#'
#' For \code{items} a list of name, value pairs, one pair for each element of
#' \code{x}. The name in each pair is the original name of the value in
#' \code{x}. If element is unnamed, \code{''} is used. See below for examples.
#'
#' For \code{enumerate} a list of index, value pairs, one pair for each element
#' of \code{x}. The indices range from 1 to the number of elements in the
#' unpacked list of \code{x}.
#'
#' @seealso \code{\link{\%<-\%}}
#'
#' @export
#' @examples
#' # %<-% expects two values to assign to `x` and `y`
#' # and the vector does not automatically unpack
#' \dontrun{
#' x: y %<-% c(0, 1)
#' }
#'
#' # instead we can force the vector to unpack
#' x: y %<-% unpack(c(0, 1))
#'
#' # we can use unpack and specify argument `n`
#' # to only unpack a select number of elements
#'
#' f <- lm(mpg ~ cyl, data = mtcars)
#'
#' fcall: rest %<-% unpack(summary(f), n = 1)
#'
#' # this is especially useful as unpacking
#' # `summary.lm` returns 11 values
#'
#' # the first element
#' fcall
#'
#' # the rest of the elements bundled into
#' # a list
#' rest
#'
#' # some food groups and choices
#' foods <- list(
#'   breads = c('rye', 'wheat'),
#'   veggies = c('peas', 'spinach', 'corn'),
#'   fruits = c('plums', 'cherries')
#' )
#'
#' # we can use `items` and `enumerate` to
#' # unpack our list of foods
#' for (pair in enumerate(items(foods))) {
#'   {i: {group: choices}}  %<-% pair
#'   cat(
#'     sprintf(
#'       '%d. %s - %s\n',
#'       i, group, paste(choices, collapse = ', ')
#'     )
#'   )
#' }
#'
#' # more enumeration, this time unpacking the
#' # iris data set
#' for (col in enumerate(iris)) {
#'   i: values %<-% col
#'
#'   if (i != 5) {
#'     cat('mean', i, 'is', mean(values), '\n')
#'   }
#' }
#'
#' # alternatively, we could use `items`
#' # to unpack the iris data set
#' for (col in items(iris)) {
#'   nm: values %<-% col
#'
#'   if (nm != 'Species') {
#'     cat(nm, 'mean is', mean(values), '\n')
#'   }
#' }
#'
unpack <- function(x, n = NULL) {
  if (!is.null(n) && !is.numeric(n)) {
    stop('argument `n` must be a numeric', call. = FALSE)
  }

  unpacked <- lapply(x, identity)

  if (!is.null(n) && n < length(unpacked)) {
    bundled <- unpacked[seq.int(n + 1, length(unpacked))]
    unpacked <- unpacked[seq_len(n + 1)]
    unpacked[[n + 1]] <- bundled
  }

  unpacked
}

#' @rdname unpack
#' @export
items <- function(x) {
  unpacked <- unpack(x)
  tags <- names(x) %||% rep('', length(unpacked))
  lapply(seq_along(unpacked), function(i) list(tags[[i]], unpacked[[i]]))
}

#' @rdname unpack
#' @export
enumerate <- function(x) {
  unpacked <- unpack(x)
  lapply(seq_along(unpacked), function(i) list(i, unpacked[[i]]))
}
