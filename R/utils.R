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

cadr <- function(cons) {
  car(cdr(cons))
}

caddr <- function(cons) {
  car(cdr(cdr(cons)))
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

  #
  # unpack immediately nested `c` calls
  #
  if (is_list(x) && length(x) == 2) {
    return(c(as.character(car(x)), calls(cadr(x))))
  }

  c(as.character(car(x)), calls(cadr(x)), calls(caddr(x)))
}

variables <- function(x) {
  if (!is_list(x)) {
    if (!is.symbol(x)) {
      stop("found ", class(x), call. = FALSE)
    }

    return(as.character(x))
  }

  #
  # unpack immediately nested `c` calls
  #
  if (is_list(x) && length(x) == 2) {
    return(list(variables(cadr(x))))
  }

  return(list(variables(cadr(x)), variables(caddr(x))))
}
