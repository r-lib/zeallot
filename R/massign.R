#' Assign Values to a Name or Names
#'
#' Using two lists of names and values, assign values to names in the specified
#' environment, defaults to calling environment.
#'
#' @param x a list of variable name(s).
#' @param values values to be assigned, usually a list of values or an object
#'   with a \code{destructure} implementation.
#'
#' @details
#'
#' For more information about how \code{massign} and \code{\%<-\%} assign values
#' to names, refer to the introductory vignette.
#'
#' \code{browseVignettes('allotalot')}
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
