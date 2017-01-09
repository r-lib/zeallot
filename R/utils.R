`%||%` <- function(a, b) if (is.null(a)) b else a

is.formula <- function(x) {
  inherits(x, 'formula')
}

as_lang <- function(x) {
  if (is.formula(x)) {
    x[[2]]
  } else if (is.call(x) || is.name(x)) {
    x
  } else {
    stop('cannot coerce ', class(x), ' to language', call. = FALSE)
  }
}

as_function <- function(f) {
  if (is.function(f)) {
    f
  } else if (is.formula(f)) {
    fn <- eval(call('function', as.pairlist(alist(. = )), f[[2]]))
    environment(fn) <- environment(f)
    fn
  } else {
    stop('cannot coerce ', class(f), ' to function', call. = FALSE)
  }
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

calls <- function(x, exclude) {
  if (!is.character(exclude)) {
    stop('argument `exclude` must be of class character', call. = FALSE)
  }

  do_search <- function(.x) {
    if (!is.list(.x)) {
      return(NA_character_)
    }

    this <- as.character(car(.x))
    if (this %in% exclude) {
      this <- NA_character_
    }

    if (is.list(.x) && length(.x) == 2) {
      return(c(this, do_search(cadr(.x))))
    }

    left <- do_search(cadr(.x))

    right <- do_search(caddr(.x))

    c(this, left, right)
  }

  do_search(x)
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
  lyst
}
