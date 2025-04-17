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

  orig_handler <- usage_handlers$`{`

  if (is.null(orig_handler)) {
    orig_handler <- function(e, w) NULL
  }

  usage_handlers$`{` <- function(e, w) {

    exprs_list <- as.list(e)
    exprs_lengths <- lengths(exprs_list)

    exprs_possible <- exprs_list[exprs_lengths == 3]

    for (expr in exprs_possible) {
      if (expr[[1]] == "%<-%") {
        expr_vars <- variables(as.list(expr[[2]]))

        vars_names <- unlist(lapply(expr_vars, function(x) {
          if (is_collector(x) && x != "...") {
            c(collector_name(x), x)
          } else {
            x
          }
        }))

        if (length(vars_names) > 0) {
          w$startCollectLocals(vars_names, character(), w)
        }
      }
    }

    orig_handler(e, w)
  }
}