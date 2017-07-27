#' Unpacking Operator
#'
#' Assign values to name(s).
#'
#' @param x A name structure, see details.
#' @param value A list of values, vector of values, or \R object to assign.
#'
#' @details
#'
#' \bold{variable names}
#'
#' To separate variable names use colons, \code{a : b : c}.
#'
#' To nest variable names use braces, \code{\{a : \{b : c\}\}}.
#'
#' \bold{values}
#'
#' To unpack a vector of variables do not include braces, \code{a : b \%<-\% c(1,
#' 2)}.
#'
#' Include braces to unpack a list of values, \code{\{a : b\} \%<-\% list(1,
#' 2)}.
#'
#' When \code{value} is neither a vector nor a list, the zeallot operator will
#' try to de-structure \code{value} into a list, see \code{\link{destructure}}.
#'
#' Nesting names will unpack nested values, \code{\{a : \{b : c\}\} \%<-\% list(1,
#' list(2, 3))}.
#'
#' \bold{collector variables}
#'
#' To gather extra values from the beginning, middle, or end of \code{value}
#' use a collector variable. Collector variables are indicated with a \code{...}
#' prefix.
#'
#' Collect starting values, \code{\{...a : b : c\} \%<-\% list(1, 2, 3, 4)}
#'
#' Collect middle values, \code{\{a : ...b : c\} \%<-\% list(1, 2, 3, 4)}
#'
#' Collect ending values, \code{\{a : b : ...c\} \%<-\% list(1, 2, 3, 4)}
#'
#' \bold{skipping values}
#'
#' Use a period \code{.} in place of a variable name to skip a value without
#' raising an error, \code{\{a : . : c\} \%<-\% list(1, 2, 3)}. Values will not be
#' assigned to \code{.}.
#'
#' Skip multiple values by combining the collector prefix and a period,
#' \code{\{a : .... : e\} \%<-\% list(1, NA, NA, NA, 5)}.
#'
#' @return
#'
#' \code{\%<-\%} invisibly returns \code{value}.
#'
#' \code{\%<-\%} is used primarily for its assignment side-effect. \code{\%<-\%}
#' assigns into the environment in which it is evaluated.
#'
#' @seealso
#'
#' For more on unpacking custom objects please refer to
#' \code{\link{destructure}}.
#'
#' @name operator
#' @export
#' @examples
#' # basic usage
#' {a : b} %<-% list(0, 1)
#'
#' a  # 0
#' b  # 1
#'
#' # no braces when unpacking vectors
#' c : d  %<-% c(0, 1)
#'
#' c  # 0
#' d  # 1
#'
#' # unpack and assign nested values
#' {{e : f} : {g : h}} %<-% list(list(2, 3), list(3, 4))
#'
#' e  # 2
#' f  # 3
#' g  # 4
#' h  # 5
#'
#' # can assign more than 2 values
#' {j : k : l} %<-% list(6, 7, 8)
#'
#' # assign columns of data frame
#' {num_erupts : till_next} %<-% faithful
#'
#' num_erupts  # 3.600 1.800 3.333 ..
#' till_next   # 79 54 74 ..
#'
#' # assign only specific columns, skip
#' # other columns
#' {mpg : cyl : disp : ....} %<-% mtcars
#'
#' mpg   # 21.0 21.0 22.8 ..
#' cyl   # 6 6 4 ..
#' disp  # 160.0 160.0 108.0 ..
#'
#' # skip initial values, assign final value
#' TODOs <- list('make food', 'pack lunch', 'save world')
#'
#' {.... : task} %<-% TODOs
#'
#' task  # 'save world'
#'
#' # assign first name, skip middle initial,
#' # assign last name
#' first : . : last %<-% c('Ursula', 'K', 'Le Guin')
#'
#' first  # 'Ursula'
#' last   # 'Le Guin'
#'
#' # simple model and summary
#' f <- lm(hp ~ gear, data = mtcars)
#' fsum <- summary(f)
#'
#' # extract call and fstatistic from
#' # the summary
#' {fcall : .... : ffstat : .} %<-% fsum
#'
#' fcall
#' ffstat
#'
#' # unpack nested values with
#' # nested names
#' fibs <- list(1, list(2, list(3, list(5))))
#'
#' {f2 : {f3 : {f4 : {f5}}}} %<-% fibs
#'
#' f2  # 1
#' f3  # 2
#' f4  # 3
#' f5  # list(5) *!!*
#'
#' # unpack first value (a numeric) and
#' # second value (a list)
#' {f2 : fcdr} %<-% fibs
#'
#' f2    # 1
#' fcdr  # list(2, list(3, list(5)))
#'
#' # swap values without using a
#' # temporary variable
#' a : b %<-% c('eh', 'bee')
#' a  # 'eh'
#' b  # 'bee'
#'
#' a : b %<-% c(b, a)
#' a  # 'bee'
#' b  # 'eh'
#'
#' # unpack strsplit return value
#' names <- c('Nathan,Maria,Matt,Polly', 'Smith,Peterson,Williams,Jones')
#'
#' {firsts : lasts} %<-% strsplit(names, ',')
#'
#' firsts  # c('Nathan', 'Maria', ..
#' lasts   # c('Smith', 'Peterson', ..
#'
`%<-%` <- function(x, value) {
  ast <- tree(substitute(x))
  cenv <- parent.frame()

  if (length(ast) != 1 && ast[[1]] != "c") {
    return(`old%<-%`(ast, value, cenv))
  }

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
