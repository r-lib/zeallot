`%||%` <- function(a, b) if (is.null(a)) b else a

is.formula <- function(x) {
  inherits(x, 'formula')
}

is_list <- function(x) {
  class(x) == 'list'
}

is_flat_list <- function(x) {
  is_list(x) && all(vapply(x, Negate(is_list), logical(1)))
}

as_lang <- function(x) {
  if (is.formula(x)) {
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
  get_variables <- function(.x) {
    if (!is.list(.x)) {
      return(as.character(.x))
    }

    if (is.list(.x) && length(.x) == 2) {
      return(get_variables(cadr(.x)))
    }

    list(get_variables(cadr(.x)), get_variables(caddr(.x)))
  }

  get_variables(x)
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

lystified <- function(x) {
  do_lystify <- function(.x) {
    if (!is.list(.x)) {
      return(paste0("'", as.character(.x), "'"))
    }

    if (is.list(car(.x))) {
      do_lystify(car(.x))
    } else if (car(.x) == ':') {
      paste0(do_lystify(cadr(.x)), ', ', do_lystify(cddr(.x)))
    } else if (car(.x) == '{') {
      paste0('list(', do_lystify(cadr(.x)), ')')
    } else if (length(list(.x)) == 1) {
      return(paste0("'", as.character(.x), "'"))
    } else {
      stop('cannot lystify ', .x, call. = FALSE)
    }
  }
  lyst <- do_lystify(x)
  if (length(x) > 1 && as.character(x[[1]]) == ':') {
    lyst <- paste0('list(', lyst, ')')
  }
  eval(parse(text = lyst))
}
