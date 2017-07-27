`%<-%` <- function(x, value) {
  ast <- tree(substitute(x))
  internals <- calls(ast)
  lhs <- tryCatch(
    variables(ast),
    error = function(e) {
      stop(
        "invalid `%<-%` left-hand side, expecting symbol, but ", e$message,
        call. = FALSE
      )
    }
  )
  cenv <- parent.frame()

  #
  # standard assignment
  #
  if (is.null(internals)) {
    assign(as.character(ast), value, envir = cenv)
    return(invisible(value))
  }

  if (any(internals != "c")) {
    name <- internals[which(internals != "c")][1]
    stop(
      "invalid `%<-%` left-hand side, unexpected call `", name, "`",
      call. = FALSE
    )
  }

  # if (is_list(lhs) && is_list(car(lhs))) {
  #   lhs <- car(lhs)
  # }

  massign(lhs, value, envir = cenv)

  invisible(value)
}
