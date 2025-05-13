is_assignment <- function(x) {
  x == "%<-%" || x == "%->%"
}

usage_handler_empty <- function(expr, walker) {

}

usage_handler_default <- function(expr, walker) {
  exprs_list <- as.list(expr)
  exprs_lengths <- lengths(exprs_list)
  exprs_possible <- exprs_list[exprs_lengths == 3]

  for (e in exprs_possible) {
    if (is_assignment(e[[1]])) {
      var_names <- var_search(e[[2]])

      if (length(var_names) > 0) {
        walker$startCollectLocals(var_names, character(), walker)
      }
    }
  }
}

add_usage_handler <- function(handlers, nm, f) {
  stopifnot(
    is.character(nm),
    is.function(f)
  )

  prev_handler <- handlers[[nm]]

  if (is.null(prev_handler)) {
    prev_handler <- usage_handler_empty
  }

  handlers[[nm]] <-
    function(expr, walker) {
      f(expr, walker)
      prev_handler(expr, walker)
    }

  invisible(handlers)
}

#' Allow zeallous assignment
#'
#' Using zeallot within an R package may cause `R CMD check` to raise NOTEs
#' concerning variables with `"no visible binding"`. To avoid these NOTEs,
#' include a call to `zeallous()` in a package's `.onLoad()` function.
#'
#' The `R CMD check` process uses a package `{codetools}` to check for assigned
#' variables. However, due to the non-standard nature of zeallot assignment the
#' codetools package does not identify these variables. To work around this, the
#' `zeallous()` function modifies the variables found by codetools to avoid
#' the NOTEs raised by `R CMD check`.
#'
#' @export
#'
#' @examples
#'
#' .onLoad <- function(libname, pkgname) {
#'   zeallous()
#' }
#'
zeallous <- function() {
  if (!requireNamespace("codetools", quietly = TRUE)) {
    return()
  }

  codetools <- asNamespace("codetools")
  usage_handlers <- codetools$collectUsageHandlers

  if (!is.environment(usage_handlers)) {
    return()
  }

  add_usage_handler(usage_handlers, "{", usage_handler_default)
  add_usage_handler(usage_handlers, "if", usage_handler_default)
}
