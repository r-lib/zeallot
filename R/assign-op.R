all_equalish <- function(lhs, rhs) {
  if (class(rhs) != 'list') {
    return(paste('expecting', length(lhs), 'values, but found 1'))
  }

  if (length(lhs) != length(rhs)) {
    return(paste('expecting', length(lhs), 'values, but found', length(rhs)))
  }

  for (i in seq_along(lhs)) {
    if (length(lhs[[i]]) > 1) {
      msg <- all_equalish(lhs[[i]], rhs[[i]])

      if (is.character(msg)) {
        return(msg)
      }
    }
  }
}

multi_assign <- function(names, values, envir, inherits = FALSE) {
  if (length(names) == 1) {
    if (names != '..') {
      assign(names[[1]], values, envir = envir, inherits = inherits)
    }
    return()
  }

  for (i in seq_along(names)) {
    multi_assign(names[[i]], values[[i]], envir, inherits = inherits)
  }
}

#' Parallel, Multiple, and Unpacking Assignment
#'
#' The \code{\%<-\%} operator performs parallel assignment by coercing the LHS
#' of an assignment expression to a name structure, see \code{\link{.}}, and
#' assigning values from the RHS to these names.
#'
#' @usage x \%<-\% value
#'
#' @param x A bare name or name structure.
#' @param value A list of values to assign.
#'
#' @return
#'
#' \code{\%<-\%} invisibly returns \code{value}.
#'
#' @rdname parallel-assign
#' @export
#' @examples
#' .(a, b) %<-% list('A', 'B')
#' a  # "A"
#' b  # "B"
#'
#' # swap the values
#' .(a, b) %<-% list(b, a)
#' a  # "B"
#' b  # "A"
#'
#' guests %<-% c('Nathan,Allison,Matt,Polly', 'Smith,Peterson,Williams,Jones')
#'
#' .(firsts, lasts) %<-% strsplit(guests, ',')
#'
#' firsts  # "Nathan", "Allison", ..
#' lasts   # "Smith", "Peterson", ..
`%<-%` <- function(x, value) {
  lhs <- eval(substitute(.(name), list(name = substitute(x))))
  rhs <- if (is.list(value)) value else list(value)
  callenv <- parent.frame()

  if (length(lhs) == 1) {
    assign(lhs[[1]], value, envir = callenv, inherits = FALSE)
    return(invisible(value))
  }

  comparison <- all_equalish(lhs, rhs)
  if (is.character(comparison)) {
    stop(comparison, call. = FALSE)
  }

  tempenv <- new.env(parent = emptyenv())

  # first assign variables to temporary environment
  multi_assign(lhs, rhs, tempenv)

  # then move variables to calling environment
  for (name in ls(tempenv, all.names = TRUE)) {
    assign(name, tempenv[[name]], envir = callenv, inherits = FALSE)
  }

  rm('tempenv', inherits = FALSE)

  invisible(value)
}
