is_Date <- function(x) {
  inherits(x, 'Date')
}

is_list <- function(x) {
  class(x) == 'list'
}

car <- function(cons) {
  stopifnot(is.list(cons), length(cons) > 0)
  cons[[1]]
}

cdr <- function(cons) {
  stopifnot(is.list(cons), length(cons) > 0)
  cons[-1]
}

tree <- function(x) {
  if (length(x) == 1) {
    return(x)
  }

  append(tree(x[[1]]), lapply(x[-1], tree))
}

calls <- function(x) {
  if (!is_list(x)) {
    return(NULL)
  }

  this <- car(x)

  if (this != "c") {
    stop_invalid_lhs(unexpected_call(this))
  }

  c(as.character(this), unlist(lapply(cdr(x), calls)))
}

variables <- function(x) {
  if (!is_list(x)) {
    if (!is.symbol(x)) {
      stop_invalid_lhs(unexpected_variable(x))
    }

    return(as.character(x))
  }

  lapply(cdr(x), variables)
}

#
# error helpers below
#

incorrect_number_of_values <- function() {
  "incorrect number of values"
}

unexpected_variable <- function(obj) {
  paste("expected symbol, but found", class(obj))
}

unexpected_call <- function(obj) {
  paste0("unexpected call `", as.character(obj), "`")
}

stop_invalid_lhs <- function(message) {
  stop(
    paste("invalid `%<-%` left-hand side,", message),
    call. = FALSE
  )
}

stop_invalid_rhs <- function(message) {
  stop(
    paste("invalid `%<-%` right-hand side,", message),
    call. = FALSE
  )
}
