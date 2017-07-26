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
#' Refer to examples in the introductory vignette to see how \code{massign} and
#' \code{\%<-\%} associate values with names.
#'
#' \code{browseVignettes('zeallot')}
#'
#' @keywords internal
#' @export
massign <- function(x, values, envir = parent.frame(), inherits = FALSE) {
  lhs <- x
  rhs <- values

  #
  # bundle values for calls like `a : ...b %<-% 1:5`
  #
  if (length(values) == 0) {
    rhs <- list(values)
  } else if (is.atomic(values)) {
    rhs <- as.list(values)
  } else if (!is_list(values)) {
    rhs <- list(values)
  }

  tuples <- pair_off(lhs, rhs)

  for (t in tuples) {
    name <- t[["name"]]
    value <- t[["value"]]

    #
    # collector variable names retain the leading "..."
    #
    if (is_collector(name)) {
      name <- sub("^\\.\\.\\.", "", name)

      #
      # if the original value was a vector make sure the assigned value is
      # also a vector
      #
      if (is.atomic(values)) {
        value <- unlist(value)
      }
    }

    assign(name, value, envir = envir, inherits = inherits)
  }

  invisible(values)
}
