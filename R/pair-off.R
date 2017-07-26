is_collector <- function(x) {
  if (!is.character(x)) {
    return(FALSE)
  }
  grepl("^\\.\\.\\.", x)
}

has_collector <- function(x) {
  any(vapply(x, is_collector, logical(1)))
}

collect <- function(names, values) {
  if (!any(grepl("^\\.\\.\\.", names))) {
    stop("no collector variable specified", call. = FALSE)
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
    stop(
      "invalid `%<-%` left-hand side, multiple collector variables at the ",
      "same depth",
      call. = FALSE
    )
  }

  if (c_index == 1) {
    # ...firsts, a, b
    post <- rev(
      seq.int(
        from = length(values),
        length.out = length(names) - 1,
        by = -1
      )
    )

    c(list(values[-post]), values[post])
  } else if (c_index == length(names)) {
    # a, b, ...rest
    pre <- seq.int(1, c_index - 1)

    c(values[pre], list(values[-pre]))
  } else {
    # a, ...mid, b
    pre <- seq.int(1, c_index - 1)
    post <- rev(
      seq.int(
        from = length(values),
        length.out = length(names) - length(pre) - 1,
        by = -1
      )
    )

    c(values[pre], list(values[-c(pre, post)]), values[post])
  }
}

pair_off <- function(names, values) {
  if (is.character(names)) {
    if (names == ".") {
      return()
    }

    return(list(list(name = names, value = values)))
  }

  if (is_list(names) && length(names) == 0 &&
      is_list(values) && length(values) == 0) {
    return()
  }

  #
  # mismatch between variables and values
  #
  if (length(names) != length(values)) {
    #
    # mismatch could be resolved by destructuring the values, in this case
    # values must be a single element list
    #
    if (is_list(values) && length(values) == 1) {
      return(pair_off(names, destructure(car(values))))
    }

    #
    # if there is no collector the mismatch is a problem *or* if collector,
    # but still more variables than values the collector is useless and
    # mismatch is a problem
    #
    if (!has_collector(names) || length(names) > length(values)) {
      stop(
        "invalid `%<-%` right-hand side, incorrect number of values",
        call. = FALSE
      )
    }

    # if (!has_collector(names)) {
    #   if (length(names) > length(values)) {
    #     stop('expecting ', length(names), ' values, but found ', length(values),
    #          call. = FALSE)
    #   } else {
    #     stop('too many values to unpack', call. = FALSE)
    #   }
    #
    # } else {
    #   if (length(names) > length(values)) {
    #     stop('expecting at least ', length(names), ' values, but found ',
    #          length(values), call. = FALSE)
    #   }
    # }
  }

  if (is_collector(car(names))) {
    collected <- collect(names, values)
    name <- car(names)

    #
    # skip unnamed collector variable and corresponding values
    #
    if (name == "...") {
      # stop('invalid collector variable', call. = FALSE)
      return(pair_off(cdr(names), cdr(collected)))
    }

    return(
      c(pair_off(name, car(collected)), pair_off(cdr(names), cdr(collected)))
    )
  }

  #
  # multiple nested variables and nested vector of values same length, but
  # a nested vector is not unpacked, mismatch
  #
  if (is_list(names) && !is_list(values)) {
    stop(
      "invalid `%<-%` right-hand side, incorrect number of values",
      call. = FALSE
    )
  }

  if (length(names) == 1) {
    return(pair_off(car(names), car(values)))
  }

  c(pair_off(car(names), car(values)), pair_off(cdr(names), cdr(values)))
}

