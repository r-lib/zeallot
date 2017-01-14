is_collector <- function(x) {
  if (!is.character(x)) {
    return(FALSE)
  }
  grepl('^\\.\\.\\.', x)
}

collect <- function(names, values) {
  if (!any(grepl('^\\.\\.\\.', names))) {
    stop('no collector variable specified', call. = FALSE)
  }

  if (length(names) == length(values)) {
    return(values)
  }

  if (length(names) == 1) {
    # ...alone
    return(list(values))
  }

  c_index <- which(grepl('^\\.\\.\\.', names))

  if (length(c_index) != 1) {
    stop(length(c_index), ' collector variables specified, use 1 per depth',
         call. = FALSE)
  }

  if (c_index == 1) {
    # ...firsts, a, b
    post <- rev(seq.int(from = length(values), length.out = length(names) - 1,
                        by = -1))

    c(list(values[-post]), values[post])
  } else if (c_index == length(names)) {
    # a, b, ...rest
    pre <- seq.int(1, c_index - 1)

    c(values[pre], list(values[-pre]))
  } else {
    # a, ...mid, b
    pre <- seq.int(1, c_index - 1)
    post <- rev(seq.int(from = length(values),
                        length.out = length(names) - length(pre) - 1, by = -1))

    c(values[pre], list(values[-c(pre, post)]), values[post])
  }
}

pair_off <- function(names, values) {
  if (is.character(names)) {
    if (names == '.') {
      return()
    }

    return(list(list(name = names, value = values)))
  }

  if (is_list(names) && length(names) == 0 &&
      is_list(values) && length(values) == 0) {
    return()
  }

  if (length(names) != length(values)) {

    if (is_list(values) && length(values) == 1) {
      return(pair_off(names, unpack(car(values))))
    }

    if (!any(vapply(names, is_collector, logical(1)))) {
      if (length(names) > length(values)) {
        stop('expecting ', length(names), ' values, but found ', length(values),
             call. = FALSE)
      } else {
        stop('too many values to unpack', call. = FALSE)
      }
    }
  }

  if (is_collector(car(names))) {
    if (length(names) > length(values)) {
      stop('after collecting ', car(names), ', expecting ', length(names) - 1,
           ' values, but found ', length(values) - 1,
           call. = FALSE)
    }

    collected <- collect(names, values)
    name <- sub('...', '', car(names))

    if (name == '') {
      stop('invalid collector variable', call. = FALSE)
    }

    return(c(pair_off(name, car(collected)), pair_off(cdr(names), cdr(collected))))
  }

  if (is_list(names) && !is_list(values)) {
    stop('expecting ', length(names), ' values, but found 1', call. = FALSE)
  }

  if (length(names) == 1) {
    return(pair_off(car(names), car(values)))
  }

  c(pair_off(car(names), car(values)), pair_off(cdr(names), cdr(values)))
}

