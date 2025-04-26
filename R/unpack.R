unpack <- function(
    vars,
    vals
) {
  switch(
    typeof(vars),
    language = unpack_language(list(vars), list(vals), vals),
    symbol = list(list(vars, vals))
  )
}

unpack_next <- function(
    vars,
    vals,
    lookup = list()
) {
  if (is_empty_list(vars)) {
    return()
  }

  switch(
    peek_type(vars),
    language = unpack_language(vars, vals, lookup),
    symbol = unpack_symbol(vars, vals, lookup),
    collector = unpack_collector(vars, vals, lookup)
  )
}

unpack_language <- function(
    vars,
    vals,
    lookup = list()
) {
  lang <- as.list(car(vars))

  switch(
    peek_symbol(lang),
    `[[` = ,
    `[`  = ,
    `$`  = unpack_extract(vars, vals),
    `c`  = c(
      unpack_next(cdr(lang), destructure(car(vals)), car(vals)),
      unpack_next(cdr(vars), cdr(vals), lookup)
    ),
    stop(
      "unexpected call ", deparse(lang[[1]], backtick = TRUE)
    )
  )
}

unpack_symbol <- function(vars, vals, lookup = list()) {
  var <- first(vars)
  val <- first(vals)

  if (var_is_skip(var)) {
    return(unpack_next(cdr(vars), cdr(vals), lookup))
  }

  prepend(
    list(var_symbol(var), var_value(var, val, lookup)),
    unpack_next(cdr(vars), cdr(vals), lookup)
  )
}

unpack_extract <- function(
    vars,
    vals,
    lookup = list()
) {
  prepend(
    list(car(vars), car(vals)),
    unpack_next(cdr(vars), cdr(vals), lookup)
  )
}

unpack_collector <- function(vars, vals, lookup = list()) {
  if (length(vars) == length(vals)) {
    unpack_symbol(vars, vals, lookup)
  } else if (length(vars) > length(vals)) {
    c(
      unpack_symbol(first(vars), list(NULL)),
      unpack_next(cdr(vars), cdr(vals), lookup)
    )
  } else if (length(vars) < length(vals)) {
    unpack_collector(vars, list_compress(vals, length(vars)), lookup)
  }
}

