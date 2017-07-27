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
