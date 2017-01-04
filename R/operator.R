. <- function(...) {
  args <- eval(substitute(alist(...)))

  if (length(args) == 1 && is.call(args[[1]])) {
    if (args[[1]][[1]] == '.') {
      return(eval(args[[1]]))
    }
  }

  lapply(
    args,
    function(a) {
      if (is.name(a)) {
        as.character(a)
      } else {
        if (a[[1]] != '.') {
          stop('unexpected symbol ', a[[1]], call. = FALSE)
        }
        eval(a)
      }
    }
  )
}

check_names_to_values <- function(names, values) {
  if (length(names) != length(values)) {
    stop('expecting ', length(names), ' values, but found ',
         length(values), call. = FALSE)
  }

  for (i in seq_along(names)) {
    if (length(names[[i]]) > 1) {
      check_names_to_values(names[[i]], values[[i]])
    }
  }
}

do_assignment <- function(names, values, envir) {
  if (length(names) == 1) {
    assign(names[[1]], values, envir = envir)
    return()
  }

  for (i in seq_along(names)) {
    do_assignment(names[[i]], values[[i]], envir)
  }
}

#' Parallel, Multiple, and Unpacking Assignment
#'
#' ~ missing ~
#'
#' @param names A bare name or name structure generated using \code{\link{.}}.
#' @param values A list of values to assign to names.
#'
#' @rdname parallel-assignment
#' @export
#' @examples
#' .(a, b) %<-% list('A', 'B')
#'
#' print(a)
#'
#' # swap values
#' .(a, b) %<-% list(b, a)
#'
#' print(a)
`%<-%` <- function(names, values) {
  names <- substitute(names)
  callingenv <- parent.frame()

  if (is.name(names)) {
    names <- list(as.character(names))
  } else if (is.call(names)) {
    names <- eval(names)
  } else {
    stop('unexpected left-hand side of assignment', call. = FALSE)
  }

  if (length(names) == 1) {
    if (is.character(names[[1]])) {
      assign(names[[1]], values, envir = callingenv)
      return(invisible(values))
    } else {
      stop('unexpected left-hand side of assignment', call. = FALSE)
    }
  }

  if (class(values) != 'list') {
    values <- list(values)
  }

  check_names_to_values(names, values)

  tempenv <- new.env(parent = emptyenv())

  # first assign variables to temporary environment
  do_assignment(names, values, tempenv)

  # then move variables to calling environment
  for (nm in ls(tempenv, all.names = TRUE)) {
    assign(nm, tempenv[[nm]], envir = callingenv, inherits = FALSE)
  }

  rm('tempenv', inherits = FALSE)

  invisible(values)
}

