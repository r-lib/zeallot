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

    if (is_collector(n) || is_deprecated_collector(n)) {
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
  stopifnot(is.list(x), len >= 1L)

  x_len <- length(x)

  if (x_len <= len) {
    return(x)
  }

  c(
    list(head(x, x_len - len + 1L)),
    tail(x, len - 1L)
  )
}

list_assign <- function(x, envir = parent.frame(), simplify = FALSE) {
  if (is_empty_list(x)) {
    return()
  }

  pair <- car(x)
  name <- pair[[1]]
  value <- pair[[2]]

  if (is.list(value) && simplify) {
    value <- unlist(value)
  }

  eval(call("<-", name, bquote(quote(.(value)))), envir = envir)

  list_assign(cdr(x), envir, simplify)
}

attempt_assign <- function(expr, call = sys.call(-1)) {
  tryCatch(
    error = function(cnd) {
      stop(simpleError(conditionMessage(cnd), call))
    },
    expr
  )
}
