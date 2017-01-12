can_unpack <- function(object) {
  class(object) %in% vapply(utils::methods('unpack'), sub, character(1),
                            pattern = '^unpack\\.', replacement = '')
}

is_collector <- function(x) {
  if (!is.character(x)) {
    return(FALSE)
  }
  grepl('^\\.\\.\\.', x)
}

collect <- function(names, values) {
  if (length(names) == length(values)) {
    return(as.list(values))
  }

  values[[1]] <- c(values[[1]], values[[2]])
  values[[2]] <- NULL

  collect(names, values)
}

pair_off <- function(names, values) {
  if (is.character(names)) {
    return(list(list(name = names, value = values)))
  }

  # if (!is_list(values)) {
  #   return(pair_off(names, unpack(values)))
  # }

  if (is_list(names) && length(names) == 0) {
    if (is_list(values) && length(values) != 0 || !is_list(values)) {
      stop('too many values to unpack', call. = FALSE)
    }

    if (is_list(values) && length(values) == 0) {
      return()
    }
  }

  if (is_list(names) && length(names) == 0 &&
      (is_list(values) && length(values) > 0 || !is_list(values))) {
    stop('too many values to unpack', call. = FALSE)
  }

  if (length(names) != length(values)) {

    if (is_list(values) && length(values) == 1 &&
        can_unpack(car(values))) {
      return(pair_off(names, unpack(car(values))))
    }

    if (!any(vapply(names, is_collector, logical(1)))) {
      stop('expecting ', length(names), ' values, but found ', length(values),
           call. = FALSE)
    }
  }

  if (is_collector(car(names))) {
    if (length(names) > length(values)) {
      stop('expecting ', length(names), ' values, but found ', length(values),
           call. = FALSE)
    }

    collected <- collect(names, values)
    name <- sub('...', '', car(names))
    return(c(pair_off(name, car(collected)), pair_off(cdr(names), cdr(collected))))
  }

  if (length(names) == 1) {
    return(pair_off(car(names), car(values)))
  }

  c(pair_off(car(names), car(values)), pair_off(cdr(names), cdr(values)))
}

