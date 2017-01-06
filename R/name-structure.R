#' Name Structure
#'
#' The \code{.} function is used to build the left-hand side of a parallel or
#' unpacking assignment expression.
#'
#' @param \ldots Bare variable names.
#'
#' @details
#'
#' \code{.} allows bare variable names which may or may not yet exist. By
#' nesting calls to \code{.} on the left-hand side of the assignment expression
#' one can unpack nested values on the right-hand side.
#'
#' Use \code{..} to skip assignment of a value.
#'
#' @return
#'
#' The return value of \code{.} is a list structure with \ldots evaluated such
#' that bare names coerced to character strings and further calls to \code{.}
#' are evaluated.
#'
#' @seealso \code{\link{\%<-\%}}
#'
#' @rdname name-structure
#' @export
#' @examples
#' # nothing too extraordinary
#' .(a, b)
#'
#' .(a, .(c, d), b)
#'
#' # now with a little more extra-
#' .(a, b) %<-% list(0, 1)
#'
#' a  # 0
#' b  # 1
#'
#' # tackle a heavily nested list ...
#' fibs %<-% list(0, list(1, list(1, list(2, list(3)))))
#'
#' # ... with an equally heavily nested
#' # name structure
#' .(f0, .(f1, .(f2, .(f3, .(f4))))) %<-% fibs
#'
#' f1  # 1
#' f3  # 2
#' f4  # note that f4 is list(3)
#'
#' # unpack only the first element
#' .(f0, fcdr) %<-% fibs
#'
#' f0    # 0
#' fcdr  # list(1, list(1, list(2, list(3))))
#'
#' # unpack first name, skip middle initial,
#' # get last name
#' .(first, .., last) %<-% list('Ursula', 'K', 'Le Guin')
#'
#' first  # "Ursula"
#' last   # "Le Guin"
#'
#' exists('..', inherits = FALSE)  # FALSE
#'
. <- function(...) {
  struct <- ._(...)
  if (is.character(struct)) {
    list(struct)
  } else {
    struct
  }
}

._ <- function(...) {
  args <- eval(substitute(alist(...)))

  if (length(args) == 1) {
    arg <- args[[1]]

    if (is.symbol(arg) || is.name(arg)) {
      return(as.character(arg))
    } else if (is.call(arg)) {
      if (arg[[1]] != '.') {
        stop('unexpected ', class(args[[1]]), ' ', arg[[1]], call. = FALSE)
      }

      return(eval(arg))
    } else {
      stop('unexpected ', class(arg), call. = FALSE)
    }
  }

  lapply(args, function(a) eval(substitute(._(a), list(a = a))))
}
