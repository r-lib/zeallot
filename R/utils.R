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

default <- function(x) {
  attr(x, "default", exact = TRUE)
}

has_default <- function(x) {
  vapply(x, function(i) !is.null(attr(i, "default")), logical(1))
}

add_defaults <- function(names, values, env) {
  where <- which(has_default(names))
  defaults <- lapply(names[where], default)[where > length(values)]
  evaled <- lapply(defaults, eval, envir = env)

  append(values, evaled)
}

tree <- function(x) {
  if (length(x) == 1) {
    return(x)
  }

  if (x[[1]] == "<-") {
    return(as.list(x))
  }

  append(tree(x[[1]]), lapply(x[-1], tree))
}

calls <- function(x) {
  if (!is_list(x)) {
    return(NULL)
  }

  this <- car(x)

  if (this != "c" && this != "<-") {
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

  if (car(x) == "<-") {
    var <- as.character(car(cdr(x)))
    default <- car(cdr(cdr(x)))
    attr(var, "default") <- default

    return(var)
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

# thank you Advanced R
condition <- function(subclass, message, call = sys.call(-1), ...) {
  structure(
    class = c(subclass, "condition"),
    list(message = message, call = call),
    ...
  )
}

stop_invalid_lhs <- function(message, call = sys.call(-1), ...) {
  cond <- condition(c("invalid_lhs", "error"), message, call, ...)
  stop(cond)
}

stop_invalid_rhs <- function(message, call = sys.call(-1), ...) {
  cond <- condition(c("invalid_rhs", "error"), message, call, ...)
  stop(cond)
}
