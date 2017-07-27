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

  c(as.character(car(x)), unlist(lapply(cdr(x), calls)))
}

variables <- function(x) {
  if (!is_list(x)) {
    if (!is.symbol(x)) {
      stop("found ", class(x), call. = FALSE)
    }

    return(as.character(x))
  }

  lapply(cdr(x), variables)
}
