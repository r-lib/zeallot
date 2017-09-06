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

names2 <- function(x) {
  if (is.null(names(x))) rep.int("", length(x)) else names(x)
}

set_default <- function(x, value) {
  attr(x, "default") <- value
  x
}

get_default <- function(x) {
  attr(x, "default", exact = TRUE)
}

has_default <- function(x) {
  vapply(x, function(i) !is.null(get_default(i)), logical(1))
}

add_defaults <- function(names, values, env) {
  where <- which(has_default(names))
  defaults <- lapply(names[where], get_default)[where > length(values)]
  evaled <- lapply(defaults, eval, envir = env)

  append(values, evaled)
}

is_extract_op <- function(x) {
  if (length(x) < 1) {
    return(FALSE)
  }

  (as.character(x) %in% c("[", "[[", "$"))
}

is_valid_call <- function(x) {
  if (length(x) < 1) {
    return(FALSE)
  }

  (x == "c" || x == "=" || is_extract_op(x))
}

replace_assign <- function(call, value, envir = parent.frame()) {
  replacee <- call("<-", call, value)
  eval(replacee, envir = envir)
  invisible(value)
}

tree <- function(x) {
  if (length(x) == 1) {
    return(x)
  }

  if (is_extract_op(x[[1]])) {
    return(x)
  }

  lapply(
    seq_along(as.list(x)),
    function(i) {
      if (names2(x[i]) != "") {
        return(list(as.symbol("="), names2(x[i]), x[[i]]))
      } else {
        tree(x[[i]])
      }
    }
  )
}

calls <- function(x) {
  if (!is_list(x)) {
    return(NULL)
  }

  this <- car(x)

  if (!is_valid_call(this)) {
    stop_invalid_lhs(unexpected_call(this))
  }

  c(as.character(this), unlist(lapply(cdr(x), calls)))
}

variables <- function(x) {
  if (!is_list(x)) {
    if (x == "") {
      stop_invalid_lhs(empty_variable(x))
    }

    if (is.language(x) && length(x) > 1 && is_extract_op(x[[1]])) {
      return(x)
    }

    if (!is.symbol(x)) {
      stop_invalid_lhs(unexpected_variable(x))
    }

    return(as.character(x))
  }

  if (car(x) == "=") {
    var <- as.character(car(cdr(x)))
    default <- car(cdr(cdr(x)))

    if (is.null(default)) {
      default <- quote(pairlist())
    }

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

empty_variable <- function(obj) {
  paste("found empty variable, check for extraneous commas")
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

is_invalid_side_error <- function(e) {
  inherits(e, c("invalid_lhs", "invalid_rhs"))
}
