all_equalish <- function(lhs, rhs) {
  if (class(rhs) != 'list') {
    return(paste('expecting', length(lhs), 'values, but found 1'))
  }

  if (length(lhs) != length(rhs)) {
    return(paste('expecting', length(lhs), 'values, but found', length(rhs)))
  }

  for (i in seq_along(lhs)) {
    if (length(lhs[[i]]) > 1) {
      msg <- all_equalish(lhs[[i]], rhs[[i]])
      if (is.character(msg)) {
        return(msg)
      }
    }
  }
}

multi_assign <- function(names, values, envir, inherits = FALSE) {
  if (length(names) == 1) {
    if (names != '..') {
      assign(names[[1]], values, envir = envir, inherits = inherits)
    }
    return()
  }

  for (i in seq_along(names)) {
    multi_assign(names[[i]], values[[i]], envir, inherits = inherits)
  }
}

#' Parallel, Multiple, and Unpacking Assignment
#'
#' The \code{\%<-\%} operator performs parallel assignment by coercing the LHS
#' of an assignment expression to a name structure and assigning values from the
#' RHS to these names.
#'
#' @usage x \%<-\% value
#'
#' @param x A bare name or name structure.
#' @param value A list of values to assign.
#'
#' @return
#'
#' \code{\%<-\%} invisibly returns \code{value}.
#'
#' @seealso \code{\link{unpack}}, \code{\link{items}}, \code{\link{enumerate}}
#'
#' @rdname parallel-assign
#' @export
#' @examples
#' x: y %<-% list(0, 1)
#' x  # 0
#' y  # 1
#'
#' {z: w} %<-% list(2, 3)
#' z  # 2
#' w  # 3
#'
#' # tackle a heavily nested list ...
#' fibs %<-% list(0, list(1, list(1, list(2, list(3)))))
#'
#' # ... with an equally heavily nested
#' # name structure
#' {f0: {f1: {f2: {f3: {f4}}}}} %<-% fibs
#'
#' f1  # 1
#' f3  # 2
#' f4  # note that f4 is list(3)
#'
#' # unpack only the first element
#' f0: fcdr %<-% fibs
#'
#' f0    # 0
#' fcdr  # list(1, list(1, list(2, list(3))))
#'
#' # unpack first name, skip middle initial,
#' # get last name
#' first: ..: last %<-% list('Ursula', 'K', 'Le Guin')
#'
#' first  # "Ursula"
#' last   # "Le Guin"
#'
#' exists('..', inherits = FALSE)  # FALSE
#'
#' a: b %<-% list('A', 'B')
#' a  # "A"
#' b  # "B"
#'
#' # swap the values
#' a: b %<-% list(b, a)
#' a  # "B"
#' b  # "A"
#'
#' guests %<-% c('Nathan,Allison,Matt,Polly', 'Smith,Peterson,Williams,Jones')
#'
#' firsts: lasts %<-% strsplit(guests, ',')
#'
#' firsts  # "Nathan", "Allison", ..
#' lasts   # "Smith", "Peterson", ..
#'
`%<-%` <- function(x, value) {
  ast <- tree(substitute(x))

  astcalls <- calls(ast, exclude = c(':', '{'))
  if (any(!is.na(astcalls))) {
    sym <- astcalls[which(!is.na(astcalls))[1]]
    stop('unexpected call `', sym, '`', call. = FALSE)
  }

  lhs <- eval(parse(text = lystified(ast)))

  rhs <- if (is.list(value)) value else list(value)
  callenv <- parent.frame()

  if (length(lhs) == 1) {
    assign(lhs[[1]], value, envir = callenv, inherits = FALSE)
    return(invisible(value))
  }

  comparison <- all_equalish(lhs, rhs)
  if (is.character(comparison)) {
    stop(comparison, call. = FALSE)
  }

  tempenv <- new.env(parent = emptyenv())

  # first assign variables to temporary environment
  multi_assign(lhs, rhs, tempenv)

  # then move variables to calling environment
  for (name in ls(tempenv, all.names = TRUE)) {
    assign(name, tempenv[[name]], envir = callenv, inherits = FALSE)
  }

  rm('tempenv', inherits = FALSE)

  invisible(value)
}
