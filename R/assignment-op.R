#' Parallel, Multiple, and Unpacking Assignment
#'
#' The \code{\%<-\%} operator performs parallel assignment by assigning values
#' from the right-hand side values, \code{value}, to left-hand side names,
#' \code{x}.
#'
#' @usage x \%<-\% value
#'
#' @param x A bare name or name structure, see details.
#' @param value A list or vectors of values or \R object to assign, see details.
#'
#' @details
#'
#' Separate names in \code{x} using \code{:}, e.g. \code{a: b \%<-\% c(0, 1)}.
#' To unpack a list of values names must be surrounded with braces, e.g.
#' \code{\{c: d\} \%<-\% list(0, 1)}.
#'
#' \code{value} is recursively coerced to a list structure during assignment.
#' Singleton values are not coerced to lists of length 1. It is important to be
#' mindful of this when unpacking values. This includes S3 objects. For example,
#' the output of \code{\link{summary.lm}} would be recursively coerced to a
#' list. In this case the residuals component would be a named list instead of a
#' name vector.
#'
#' @return
#'
#' \code{\%<-\%} invisibly returns \code{value}.
#'
#' @rdname parallel-assign
#' @export
#' @examples
#' a: b %<-% c(0, 1)
#' a  # 0
#' b  # 1
#'
#' {c: d} %<-% list(2, 3)
#' c  # 2
#' d  # 3
#'
#' # tackle a heavily nested list ...
#' fibs <- list(0, list(1, list(1, list(2, list(3)))))
#'
#' # ... with an equally heavily nested
#' # name structure
#' {f0: {f1: {f2: {f3: {f4}}}}} %<-% fibs
#'
#' f0  # 0
#' f1  # 1
#' f2  # 1
#' f3  # 2
#' f4  # note that f4 is list(3)
#'
#' # unpack only the first element
#' {f0: fcdr} %<-% fibs
#'
#' f0    # 0
#' fcdr  # list(1, list(1, list(2, list(3))))
#'
#' # unpack first name, skip value without error,
#' # get last name
#' {first: .: last} %<-% list('Ursula', 'K', 'Le Guin')
#'
#' first  # "Ursula"
#' last   # "Le Guin"
#'
#' # swap values without a temporary variable
#' {a: b} %<-% list('A', 'B')
#' a  # "A"
#' b  # "B"
#'
#' {a: b} %<-% list(b, a)
#' a  # "B"
#' b  # "A"
#'
#' guests <- c('Nathan,Allison,Matt,Polly', 'Smith,Peterson,Williams,Jones')
#'
#' {firsts: lasts} %<-% strsplit(guests, ',')
#'
#' firsts  # "Nathan", "Allison", ..
#' lasts   # "Smith", "Peterson", ..
#'
#' # consume extra values
#' TODOs <- list('make lunch', 'defeat chandrian', 'save the world')
#'
#' {now: ...later} %<-% TODOs
#'
#' now    # "make lunch"
#' later  # our other two TODOs
#'
`%<-%` <- function(x, value) {
  ast <- tree(substitute(x))
  internals <- unlist(calls(ast))
  cenv <- parent.frame()

  if (!is.null(internals)) {

    if (any(!(internals %in% c(':', '{')))) {
      name <- internals[which(!(internals %in% c(':', '{')))][1]
      stop('unexpected call `', name, '`', call. = FALSE)
    }

    if (internals[1] == ':' && is_list(value)) {
      stop('expecting vector of values, but found list', call. = FALSE)
    }
    if (internals[1] == '{' && is.vector(value) && !is_list(value)) {
      stop('expecting list of values, but found vector', call. = FALSE)
    }

  }

  lhs <- variables(ast)
  if (is_list(lhs) && length(lhs) == 1) {
    lhs <- lhs[[1]]
  } else if (!is_list(lhs)) {
    lhs <- list(lhs)
  }

  rhs <- lapply(value, identity)
  if (is.null(value)) {
    rhs <- list(NULL)
  } else if (length(value) == 0) {
    rhs <- list(value)
  }

  massign(lhs, rhs, envir = cenv)

  invisible(value)
}
