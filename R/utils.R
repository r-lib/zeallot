is_named <- function(x) {
  any(names(x) != "")
}

is_empty_list <- function(x) {
  length(x) == 0 && identical(class(x), "list")
}

peek_symbol <- function(x) {
  as.character(car(x))
}

peek_type <- function(x) {
  if (is_named(first(x))) {
    n <- names(first(x))

    if (is_collector(n)) {
      return("collector")
    } else {
      return("symbol")
    }
  }

  if (var_is_collector(first(x))) {
    return("collector")
  }

  typeof(car(x))
}

first <- function(x) {
  x[1]
}

car <- function(cons) {
  cons[[1]]
}

cdr <- function(cons) {
  cons[-1]
}

prepend <- function(x, y) {
  if (is.null(x)) {
    y
  } else {
    c(list(x), y)
  }
}

list_compress <- function(x, len) {
  stopifnot(
    is.list(x)
  )

  if (length(x) <= len) {
    return(x)
  }

  list_compress(c(list(c(x[[1]], x[2])), x[c(-1, -2)]), len)
}

list_assign <- function(x, envir = parent.frame()) {
  if (is_empty_list(x)) {
    return()
  }

  pair <- car(x)
  name <- pair[[1]]
  value <- pair[[2]]

  eval(call("<-", name, bquote(quote(.(value)))), envir = envir)

  list_assign(cdr(x), envir)
}

