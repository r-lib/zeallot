var_name <- function(var) {
  n <-
    if (is_named(var)) {
      names(var)
    } else {
      car(var)
    }

  if (is_deprecated_collector(n)) {
    deprecated_collector_warn()
    deprecated_collector_name(n)
  } else if (is_collector(n)) {
    collector_name(n)
  } else {
    as.character(n)
  }
}

var_symbol <- function(var) {
  as.symbol(var_name(var))
}

var_has_default <- function(var) {
  is_named(var)
}

var_default <- function(var) {
  if (!var_has_default(var)) {
    return()
  }

  car(var)
}

var_value <- function(var, val, lookup) {
  if (var_is_empty(var)) {
    lookup[[var_name(var)]]
  } else if (val_is_null(val) && var_has_default(var)) {
    var_default(var)
  } else {
    car(val)
  }
}

val_is_null <- function(val) {
  is.null(car(val))
}

var_is_empty <- function(var) {
  isTRUE(car(var) == quote(""))
}

var_is_skip <- function(var) {
  identical(car(var), quote(.))
}

var_is_anonymous_collector <- function(var) {
  if (identical(car(var), quote(...))) {
    deprecated_collector_warn()
    return(TRUE)
  }

  identical(car(var), quote(..))
}


var_is_collector <- function(var) {
  length(var) == 1 &&
    (is_collector(car(var)) || is_deprecated_collector(car(var)))
}

var_search <- function(expr) {
  switch(
    typeof(expr),
    language = var_search_language(as.list(expr)),
    symbol = var_search_symbol(list(expr))
  )
}

var_search_next <- function(vars) {
  if (is_empty_list(vars)) {
    return()
  }

  c(
    switch(
      peek_type(vars),
      language  = var_search_language(as.list(car(vars))),
      collector = var_search_collector(first(vars)),
      symbol    = var_search_symbol(first(vars))
    ),
    var_search_next(cdr(vars))
  )
}

var_search_language <- function(vars) {
  switch(
    as.character(car(vars)),
    c = var_search_next(cdr(vars))
  )
}

var_search_symbol <- function(var) {
  var_name(var)
}

var_search_collector <- function(var) {
  c(paste0("..", var_name(var)), var_name(var))
}
