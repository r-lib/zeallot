#' Enumerate an Object
#'
#' The \code{items} function unpacks a named object into a list of name, value
#' pairs. The \code{enumerate} function unpacks an object into a list of index,
#' value pairs.
#'
#' @param x An \R object.
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
#' # some food groups and choices
#' foods <- list(
#'   breads = c('rye', 'wheat'),
#'   veggies = c('peas', 'spinach', 'corn'),
#'   fruits = c('plums', 'cherries')
#' )
#'
#' # we can use `items` and `enumerate` to
#' # restructure our list of foods
#' for (pair in enumerate(items(foods))) {
#'   {i: {group: choices}}  %<-% pair
#'
#'   cat(paste0(i, '. ', group, '\n'))
#'   cat(paste0('    * ', choices, '\n'), sep = '')
#' }
#'
#' # more enumeration, this time unpacking the
#' # iris data set
#' for (col in enumerate(iris)) {
#'   {i: values} %<-% col
#'
#'   # remember, each column will be coerced
#'   # to a list, so take measures to
#'   # get the data in order
#'   values <- unlist(values)
#'
#'   if (i != 5) {
#'     cat('mean', i, 'is', mean(values), '\n')
#'   }
#' }
#'
#' # alternatively, we could use `items`
#' # to unpack the iris data set
#' for (col in items(iris)) {
#'   {nm: values} %<-% col
#'
#'   values <- unlist(values)
#'
#'   if (nm != 'Species') {
#'     cat(nm, 'mean is', mean(values), '\n')
#'   }
#' }
#'
enumerate <- function(x) {
  unpacked <- lapply(x, identity)
  lapply(seq_along(unpacked), function(i) list(i, unpacked[[i]]))
}

#' @rdname enumerate
#' @export
items <- function(x) {
  unpacked <- lapply(x, identity)
  tags <- names(x) %||% rep('', length(unpacked))
  lapply(seq_along(unpacked), function(i) list(tags[[i]], unpacked[[i]]))
}
