`%||%` <- function(a, b) if (is.null(a)) b else a

all_equal <- function(x, y) {
  isTRUE(all.equal(x, y))
}

is_vector <- function(x) {
  attributes(x) <- NULL
  is.vector(x) && !is_list(x)
}

is_list <- function(x) {
  class(x) == 'list'
}

is_flat_list <- function(x) {
  is_list(x) && all(vapply(x, Negate(is_list), logical(1)))
}

singletons <- function(x) {
  Filter(Negate(is_list), x)
}

non_list_indices <- function(x) {
  if (!length(x)) {
    return(NULL)
  }

  indices <- which(!vapply(x, is_list, logical(1)))
  if (!length(indices)) {
    return(NULL)
  }

  indices
}

list_indices <- function(x) {
  if (!length(x)) {
    return(NULL)
  }

  indices <- which(vapply(x, is_list, logical(1)))
  if (!length(indices)) {
    return(NULL)
  }

  indices
}

as_list <- function(x) {
  if (is.null(x)) {
    return(list(NULL))
  }
  lapply(x, identity)
}

as_lang <- function(x) {
  if (class(x) == 'formula') {
    x[[2]]
  } else if (is.call(x) || is.name(x)) {
    x
  } else if (is.expression(x)) {
    x[[1]]
  } else {
    stop('cannot coerce ', class(x), ' to language', call. = FALSE)
  }
}

tree <- function(x) {
  make_tree <- function(.x) {
    if (length(.x) == 1) {
      return(.x)
    }

    append(make_tree(.x[[1]]), lapply(.x[-1], make_tree))
  }
  make_tree(as_lang(x))
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

cddr <- function(cons) {
  cdr(cdr(cons))
}

caddr <- function(cons) {
  car(cdr(cdr(cons)))
}

calls <- function(x, exclude = '') {
  if (!is.character(exclude)) {
    stop('argument `exclude` must be of class character', call. = FALSE)
  }

  get_calls <- function(.x) {
    if (!is.list(.x)) {
      return(NULL)
    }

    if (is.list(.x) && length(.x) == 2) {
      subtree <- vector('list', 2)
      subtree[[1]] <- as.character(car(.x))
      subtree[[2]] <- get_calls(cadr(.x))
      return(subtree)
    }

    subtree <- vector('list', 3)
    subtree[[1]] <- as.character(car(.x))
    subtree[[2]] <- get_calls(cadr(.x))
    subtree[[length(subtree)]] <- get_calls(caddr(.x))
    subtree
  }

  get_calls(x)
}

variables <- function(x) {
  if (!is_list(x)) {
    return(as.character(x))
  }

  if (is_list(x) && length(x) == 2) {
    return(list(variables(cadr(x))))
  }

  left <- variables(cadr(x))
  right <- variables(caddr(x))

  if (is.character(left) && is.character(right)) {
    list(left, right)
  } else if (is.character(left) || is.character(right)) {
    append(left, right)
  } else if (is.list(left) && length(left) == 1 ||
             is.list(right) && length(right) == 1) {
    append(left, right)
  } else {
    list(left, right)
  }
}

values <- function(x) {
  vals <- vector('list', 16)
  cursor <- 0

  get_values <- function(.x) {
    if (!is_list(.x)) {
      if (cursor == length(vals)) {
        vals <<- c(vals, vector('list', cursor))
      }

      cursor <<- cursor + 1
      vals[[cursor]] <<- .x
      return()
    }

    if (!length(.x)) {
      return()
    }

    get_values(car(.x))
    get_values(cdr(.x))
  }

  get_values(x)

  if (cursor == 0) {
    list()
  } else {
    vals[1:cursor]
  }
}

form <- function(x) {
  parse_form <- function(.x, depth) {
    if (!is_list(.x)) {
      return(depth)
    }

    if (all(lengths(.x) == 1)) {
      return(rep(depth, length(.x)))
    }

    if (is.list(.x) && length(.x) == 2) {
      return(c(depth, parse_form(cadr(.x), depth + 1)))
    }

    if (!is.list(cadr(.x))) {
      left <- depth
    } else {
      left <- parse_form(cadr(.x), depth + 1)
    }

    if (!is.list(caddr(.x))) {
      right <- depth
    } else {
      right <- parse_form(caddr(.x), depth + 1)
    }

    c(depth, left, right)
  }

  parse_form(x, 1)
}
