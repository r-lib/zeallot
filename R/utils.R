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

# calls <- function(x, exclude = "") {
#   if (!is.character(exclude)) {
#     stop("argument `exclude` must be of class character", call. = FALSE)
#   }
#
#   if (!is.list(x)) {
#     return(NULL)
#   }
#
#   if (is.list(x) && length(x) == 2) {
#     subtree <- vector("list", 2)
#     subtree[[1]] <- as.character(car(x))
#     subtree[[2]] <- calls(cadr(x), exclude)
#     return(subtree)
#   }
#
#   subtree <- vector("list", 3)
#   subtree[[1]] <- as.character(car(x))
#   subtree[[2]] <- calls(cadr(x), exclude)
#   subtree[[length(subtree)]] <- calls(caddr(x), exclude)
#   subtree
# }

# variables <- function(x) {
#   if (!is_list(x)) {
#     return(as.character(x))
#   }
#
#   if (is_list(x) && length(x) == 2) {
#     return(list(variables(cadr(x))))
#   }
#
#   left <- variables(cadr(x))
#   right <- variables(caddr(x))
#
#   if (is.character(left) && is.character(right)) {
#     list(left, right)
#   } else if (is.character(left) || is.character(right)) {
#     append(left, right)
#   } else if (is.list(left) && length(left) == 1 ||
#              is.list(right) && length(right) == 1) {
#     append(left, right)
#   } else {
#     list(left, right)
#   }
# }
#
# variables <- function(x) {
#
# }


