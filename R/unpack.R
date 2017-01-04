#' Force Unpacking of an Object
#'
#' The \code{unpack} function is used to force R objects like vectors and S3
#' objects to unpack during parallel assignment. Because \code{\link{\%<-\%}}
#' can perform standard assignment, vectors are not automatically unpacked.
#' Furthermore, to allow for parallel assingment of lists of custom objects with
#' underlying list structures, objects with custom classes are not automatically
#' unpacked either. The default behavior of \code{unpack} is to create a copy of
#' \code{x} coerced to a list.
#'
#' @param x An \R object.
#'
#' @details
#'
#' Because \code{unpack} is a generic further methods may be defined for custom
#' classes. When implementing a new \code{unpack} method the return value must
#' be a list structure in order for \code{\%<-\%} to understand how to unpack
#' the values.
#'
#' @export
unpack <- function(x) {
  UseMethod('unpack')
}

unpack.default <- function(x) {
  lapply(x, identity)
}
