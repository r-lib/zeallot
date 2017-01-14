#' Assign Values to a Name or Names
#'
#' Using two lists of names and values, assign values to names in an
#' environment.
#'
#' @param x a list of variable name(s), see details.
#' @param values values to be assigned, see details.
#'
#' @details
#'
#' \code{massign} expects \code{x} and \code{values}
#'
#' @keywords internal
#' @export
massign <- function(x, values, envir = parent.frame(), inherits = FALSE) {
  lhs <- x
  rhs <- values

  tuples <- pair_off(lhs, rhs)

  for (t in tuples) {
    name <- t[['name']]
    value <- t[['value']]
    assign(name, value, envir = envir, inherits = inherits)
  }

  invisible(values)
}
