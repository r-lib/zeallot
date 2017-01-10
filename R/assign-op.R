#' Parallel, Multiple, and Unpacking Assignment
#'
#' The \code{\%<-\%} operator performs parallel assignment by coercing the LHS
#' of an assignment expression to a name structure and assigning values from the
#' RHS to those names.
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

  caughls <- calls(ast)
  if (any(!(caughls %in% c(':', '{')))) {
    bad <- caughls[which(!(caughls %in% c(':', '{')))][1]
    stop('unexpected call `', bad, '`', call. = FALSE)
  }

  lhs <- variables(ast)
  rhs <- if (!is.list(value)) list(value) else value
  callenv <- parent.frame()

  if (length(lhs) == 1) {
    assign(lhs[[1]], value, envir = callenv, inherits = FALSE)
    return(invisible(value))
  }

  vars <- unlist(lhs)
  if ('...' %in% vars) {
    stop('must specify variable name after rest prefix, e.g. ...rest', call. = FALSE)
  }

  # lhform <- form(lhs)
  # rhform <- form(rhs)
  #
  # if (length(lhform) < length(rhform)) {
  #   rhextra <- rhform[(length(lhform) + 1):length(rhform)]
  #
  #   if (rhform[length(rhform) - length(lhform)] == rhextra[1] ||
  #       any(rhextra[1] != rhextra)) {
  #     stop('too many values to unpack', call. = FALSE)
  #   }
  # } else if (length(lhform) > length(rhform)) {
  #   lhextra <- length(lhform) - length(rhform)
  #
  #   stop('need more than ', lhextra, ' value', if (lhextra > 1) 's ' else ' ',
  #        'to unpack', call. = FALSE)
  # } else if (any(lhform != rhform)) {
  #   lhtrunc <- lhform[1:length(rhform)]
  #   mismatch <- lhform[which(lhtrunc != rhform)]
  #
  #   stop('need more than ', mismatch, ' value', if (mismatch > 1) 's ' else ' ',
  #        'to unpack', call. = FALSE)
  # }

  tempenv <- new.env(parent = emptyenv())

  # first assign variables to temporary environment
  massign(lhs, rhs, tempenv)

  # then move variables to calling environment
  for (name in ls(tempenv, all.names = TRUE)) {
    assign(name, tempenv[[name]], envir = callenv, inherits = FALSE)
  }

  rm('tempenv', inherits = FALSE)

  invisible(value)
}
