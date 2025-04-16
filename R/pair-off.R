pair_off <- function(names, values, env) {
  if (is.character(names) || is.language(names)) {
    if (names == ".") {
      return()
    }

    if (is_extract(names)) {
      attributes(names) <- NULL

      p <- list(name = names, value = names)
      attr(p, "extract") <- TRUE

      return(
        list(p)
      )
    }

    attributes(names) <- NULL

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
    if (any(has_default(names))) {
      values <- add_defaults(names, values, env)
      names <- lapply(names, `attributes<-`, value = NULL)

      return(pair_off(names, values))
    }

    #
    # Allow empty collectors if there are more names than values
    #
    if (has_collector(names)) {
      if (length(names) > length(values)) {
        coll_index <- which(vapply(names, is_collector, logical(1)))
        coll_name <- collector_name(names[[coll_index]])

        if (coll_name == "") {
          return(
            pair_off(names[-coll_index], values)
          )
        }

        return(c(
          list(list(name = coll_name, value = NULL)),
          pair_off(names[-coll_index], values)
        ))
      }
    }

    #
    # mismatch could be resolved by destructuring the values, in this case
    # values must be a single element list
    #
    if (is_list(values) && length(values) == 1) {
      return(pair_off(names, destructure(car(values))))
    }

    #
    # if there is no collector the mismatch is a problem *or* if collector,
    # and still more variables than values the collector is useless and
    # mismatch is a problem
    #
    if (!has_collector(names)) { # || length(names) > length(values)) {
      stop_invalid_rhs(incorrect_number_of_values())
    }
  }

  if (is_collector(car(names))) {
    collected <- collect(names, values)
    name <- sub("^\\.\\.\\.", "", car(names))

    #
    # skip unnamed collector variable and corresponding values
    #
    if (name == "") {
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
    stop_invalid_rhs(incorrect_number_of_values())
  }

  if (length(names) == 1) {
    return(pair_off(car(names), car(values)))
  }

  c(pair_off(car(names), car(values)), pair_off(cdr(names), cdr(values)))
}
