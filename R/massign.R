massign <- function(x, values, envir = parent.frame(), inherits = FALSE) {
  lhs <- x
  rhs <- values

  tmp <- new.env(parent = emptyenv())
  on.exit(rm(tmp, inherits = FALSE))

  do_multi_assign(lhs, rhs, tmp)

  for (name in ls(tmp, all.names = TRUE)) {
    assign(name, tmp[[name]], envir = envir, inherits = inherits)
  }

  invisible(values)
}

do_multi_assign <- function(x, values, envir) {
  if (is_list(x) && !is_list(values)) {
    stop('expecting ', length(x), ' values, but found 1', call. = FALSE)
  }

  if (is_list(x) && is_list(values) && length(values) != length(x) &&
      (length(singletons(x)) && !any(grepl('^\\.\\.\\.', singletons(x)))) ) {

    if (length(values) > length(x)) {
      stop('too many values to unpack', call. = FALSE)
    } else {
      stop('expecting ', length(x), ' value', if (length(x) == 1) '' else 's',
           ', but found ', length(values), call. = FALSE)
    }
  }

  if (is_list(x) && length(x) == 0) {
    return()
  }

  if (is.character(car(x))) {
    if (car(x) == '.') {
      # skip
    } else if (grepl('^\\.\\.\\.', car(x))) {

      nm <- sub('^\\.\\.\\.', '', car(x))
      if (nm == '') {
        stop('invalid rest prefix', call. = FALSE)
      }

      val <- values
      if (is_list(val) && length(val) == 1) {
        val <- val[[1]]
      }

      assign(nm, val, envir = envir, inherits = FALSE)
      return()

    } else {
      assign(car(x), car(values), envir = envir, inherits = FALSE)
    }

  } else {
    do_multi_assign(car(x), car(values), envir)
  }

  do_multi_assign(cdr(x), cdr(values), envir)
}