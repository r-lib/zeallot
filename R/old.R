old_operator <- function(ast, value, env) {
  warning(
    "`%<-%` left-hand side { and : syntax is deprecated as of ",
    "zeallot 0.0.4 and will be removed in future versions.\n",
    "Please use the new c() left-hand side syntax.\n",
    'See help("%<-%")',
    call. = FALSE,
    domain = NA
  )

  internals <- unlist(calls(ast))
  cenv <- env

  #
  # standard assignment
  #
  if (is.null(internals)) {
    if (class(ast) != "name") {
      stop(
        "invalid `%<-%` left-hand side, expecting name, but found ",
        class(ast),
        call. = FALSE
      )
    }
    assign(as.character(ast), value, envir = cenv)
    return(invisible(value))
  }

  if (!all(internals == ":" | internals == "{")) {
    name <- internals[which(!(internals == ":" | internals == "{"))][1]
    stop(
      "invalid `%<-%` left-hand side, unexpected call `", name, "`",
      call. = FALSE
    )
  }

  #
  # only when unpacking an atomic or date are `{` and `}` not required
  #
  if (internals[1] == ":" && !(is.atomic(value) || is_Date(value))) {
    stop(
      "invalid `%<-%` right-hand side, expecting vector of values, ",
      "but found ", class(value),
      call. = FALSE
    )
  }

  #
  # use `{`s only for non-vector values
  #
  if (internals[1] == "{" && is.vector(value) && !is_list(value)) {
    stop(
      "invalid `%<-%` right-hand side, expecting list of values, ",
      "but found vector",
      call. = FALSE
    )
  }

  lhs <- variables(ast)
  if (is_list(lhs) && is_list(car(lhs))) {
    lhs <- car(lhs)
  }

  massign(lhs, value, envir = cenv)

  invisible(value)
}
