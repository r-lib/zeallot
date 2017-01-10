massign <- function(x, values, envir = parent.frame(), inherits = FALSE) {
  if (is_list(x) && length(x) == 0) {
    return(invisible())
  }

  if (is.character(car(x))) {
    if (car(x) == '.') {
      # skip
    } else if (grepl('^\\.\\.\\.', car(x))) {
      nm <- sub('^\\.\\.\\.', '', car(x))
      if (nm == '') {
        stop('invalid rest prefix', call. = FALSE)
      }
      assign(nm, values, envir = envir, inherits = inherits)
    } else {
      if (is_list(car(values)) && !is_flat_list(car(values))) {
        stop('too many values to unpack', call. = FALSE)
      }
      assign(car(x), car(values), envir = envir, inherits = inherits)
    }

    massign(cdr(x), cdr(values), envir = envir, inherits = inherits)

    return(invisible())
  }

  massign(car(x), car(values), envir = envir, inherits = inherits)
  massign(cdr(x), cdr(values), envir = envir, inherits = inherits)
}
