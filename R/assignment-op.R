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
#' To separate names on the left-hand side of an expression use \code{:}. To
#' construct a nested set of names on the left-hand side of an expression use
#' braces, \code{\{} and \code{\}}.
#'
#' To begin simply, parallel assignment occurs one-to-one between names on the
#' left-hand side of the expressiona and values on the right-hand side of the
#' expression. If there are three names on the left side, three values are
#' expected on the right side. Values on the right-hand side may be listed as a
#' list or vector.
#'
#' It is important to understand what happens when there is, intentionally, a
#' many-to-one ratio of names and values. If many names are specified, but only
#' a single value is specified then the value is unpacked before assignment. For
#' example, a data frame is unpacked into a list of columns or a character
#' string is unpacked into a list of individual characters. For more information
#' about how a particular class is unpacked see \code{\link{unpack}}.
#' \code{unpack} is a generic function and may be implemented for custom
#' classes. After a value is unpacked a one-to-one ratio of names and values is
#' expected, otherwise an error is raised.
#'
#' To skip a value without raising an error, use the special name \code{.}. To
#' collect multiple or remaining values into a variable, prefix the variable
#' with \code{...}. These two special cases can be combined, \code{....}, to
#' skip multiple values without raising an error. It is important to note that
#' a single collector variable may be used per value depth, otherwise the number
#' of values to collect in each collector is unknown and an error is raised.
#'
#' For concrete examples see below.
#'
#' @return
#'
#' \code{\%<-\%} invisibly returns \code{value}.
#'
#' @seealso \code{\link{unpack}}
#'
#' @rdname parallel-assign
#' @export
#' @examples
#' # basic usage
#' {a: b} %<-% list(0, 1)
#'
#' a  # 0
#' b  # 1
#'
#' # no braces when unpacking vectors
#' c: d  %<-% c(0, 1)
#'
#' c  # 0
#' d  # 1
#'
#' # unpack and assign nested values
#' {{e: f}: {g: h}} %<-% list(list(2, 3), list(3, 4))
#'
#' e  # 2
#' f  # 3
#' g  # 4
#' h  # 5
#'
#' # can assign more than 2 values
#' {j: k: l} %<-% list(6, 7, 8)
#'
#' # assign columns of data frame
#' {sep_len: sep_wdth: pet_len: pet_wdth: spcs} %<-% iris
#'
#' # assign only some of values
#' {mpg: cyl: disp: ...rest} %<-% mtcars
#'
#' mpg   # first column
#' cyl   # second column
#' disp  # third column
#' rest  # the rest of the mtcars columns,
#'       # *as a list*
#'
#' # assign values at end of list
#' TODOs <- list('make food', 'pack lunch', 'save the world')
#'
#' {...skipped: do_it} %<-% TODOs
#'
#' skipped  # c('make food', 'pack lunch')
#' do_it    # 'save the world'
#'
#' # assign first name, skip middle initial without
#' # error, assign last name
#' first: .: last %<-% c('Ursula', 'K', 'Le Guin')
#'
#' first  # "Ursula"
#' last   # "Le Guin"
#'
#' # setup a simple model and get
#' # a summary
#' f <- lm(hp ~ gear, data = mtcars)
#' fsum <- summary(f)
#'
#' # extract call and fstatistic from
#' # the summary
#' {fcall: ....: fstat: .} %<-% fsum
#'
#' fcall  # hp ~ gear
#' fstat  # named vector of length 3
#'
#' # tackle a heavily nested list with
#' # equally heavily nested names
#' fibs <- list(0, list(1, list(1, list(2, list(3)))))
#'
#' {f0: {f1: {f2: {f3: {f4}}}}} %<-% fibs
#'
#' f0  # 0
#' f1  # 1
#' f2  # 1
#' f3  # 2
#' f4  # list(3) *!!*
#'
#' # unpack only first and second values
#' # no error because second value is a list
#' {f0: fcdr} %<-% fibs
#'
#' f0    # 0
#' fcdr  # list(1, list(1, list(2, list(3))))
#'
#' # swap values without using a
#' # temporary variable
#' a: b %<-% c('eh', 'bee')
#' a  # 'eh'
#' b  # 'bee'
#'
#' a: b %<-% c(b, a)
#' a  # 'bee'
#' b  # 'eh'
#'
#' # strsplit example
#' guests <- c('Nathan,Allison,Matt,Polly', 'Smith,Peterson,Williams,Jones')
#'
#' {firsts: lasts} %<-% strsplit(guests, ',')
#'
#' firsts  # c("Nathan", "Allison", ..
#' lasts   # c("Smith", "Peterson", ..
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

  rhs <- value
  if (length(value) == 0) {
    rhs <- list(value)
  } else if (is.atomic(value)) {
    rhs <- as.list(value)
  } else if (!is_list(value)) {
    rhs <- list(value)
  }

  massign(lhs, rhs, envir = cenv)

  invisible(value)
}
