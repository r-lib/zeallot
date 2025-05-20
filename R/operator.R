#' Multiple assignment operators
#'
#' Assign values to name(s).
#'
#' @param x A name structure, see section below.
#'
#' @param value A list of values, vector of values, or \R object to assign.
#'
#' @section Name Structure:
#'
#' **The basics**
#'
#' At its simplest, the name structure is a single variable name, in which
#' case \code{\%<-\%} and \code{\%->\%} perform regular assignment, \code{x
#' \%<-\% list(1, 2, 3)} or \code{list(1, 2, 3) \%->\% x}.
#'
#' To specify multiple variable names use `c()`, for example \code{c(x, y, z)
#' \%<-\% c(1, 2, 3)}.
#'
#' When `value` is neither an atomic vector nor a list, \code{\%<-\%} and
#' \code{\%->\%} will try to destructure `value` into a list before assigning
#' variables, see [destructure()].
#'
#' **In-place assignment**
#'
#' One may also assign into a list or environment, \code{c(x, x[[1]]) \%<-\%
#' list(list(), 1)}.
#'
#' **Nested names**
#'
#' One can also nest calls to `c()`, `c(x, c(y, z))`. This nested structure is
#' used to unpack nested values, \code{c(x, c(y, z)) \%<-\% list(1, list(2,
#' 3))}.
#'
#' **Collector variables**
#'
#' To gather extra values from the beginning, middle, or end of `value` use a
#' collector variable. Collector variables are indicated with the `..`
#' prefix, \code{c(..x, y) \%<-\% list(1, 2, 3, 4)}.
#'
#' **Skipping values**
#'
#' Use `.` in place of a variable name to skip a value without raising an error
#' or assigning the value, \code{c(x, ., z) \%<-\% list(1, 2, 3)}.
#'
#' Use `..` to skip multiple values without raising an error or assigning the
#' values, \code{c(w, .., z) \%<-\% list(1, NA, NA, 4)}.
#'
#' **Default values**
#'
#' Use `=` with a value to specify a default value for a variable,
#' \code{c(x, y = NULL) \%<-\% list(1)}.
#'
#' Unfortunately, using a default value with in-place assignment raises an error
#' because of \R's syntax, \code{c(x, x[[1]] = 1) \%<-\% list(list())}.
#'
#' **Named assignment**
#'
#' Use `=` _without_ a value to assign values by name, `c(two=) %<-%
#' list(one = 1, two = 2, three = 3)`.
#'
#' @return
#'
#' \code{\%<-\%} and \code{\%->\%} invisibly return `value`.
#'
#' These operators are used primarily for their assignment side-effect.
#' \code{\%<-\%} and \code{\%->\%} assign into the environment in which they
#' are evaluated.
#'
#' @seealso
#'
#' For more on unpacking custom objects please refer to
#' [destructure()].
#'
#' @name operator
#' @export
#' @examples
#' # Basic usage
#' c(x, y) %<-% list(0, 1)
#'
#' # Unpack and assign nested values
#' c(c(x, y), z) %<-% list(list(2, 3), list(3, 4))
#'
#' # Assign columns of data frame
#' c(eruptions, waiting) %<-% faithful
#'
#' # Assign specific columns by name
#' c(mpg=, hp=, gear=) %<-% mtcars
#'
#' # Alternatively, assign a column by position
#' c(first_col, .., last_col) %<-% mtcars
#'
#' # Skip initial values, assign final value
#' todo_list <- list("1. Make food", "2. Pack lunch", "3. Save world")
#'
#' c(.., final_todo) %<-% todo_list
#'
#' # Assign first name, skip middle initial, assign last name
#' c(first_name, ., last_name) %<-% c("Ursula", "K", "Le Guin")
#'
#' # Unpack nested values w/ nested names
#' fibs <- list(1, list(2, list(3, list(5))))
#'
#' c(f2, c(f3, c(f4, c(f5)))) %<-% fibs
#'
#' # Unpack first numeric, leave rest
#' c(f2, ..rest) %<-% unlist(fibs)
#'
#' # Swap values without using temporary variables
#' c(a, b) %<-% c("eh", "bee")
#'
#' c(a, b) %<-% c(b, a)
#'
#' # Handle missing values with default values
#' parse_time <- function(x) {
#'   strsplit(x, " ")[[1]]
#' }
#'
#' c(hour, period = NA) %<-% parse_time("10:00 AM")
#'
#' c(hour, period = NA) %<-% parse_time("15:00")
#'
#' # Right operator
#' list(1, 2, "a", "b", "c") %->% c(x, y, ..z)
#'
#' # Pipe chains
#' mtcars |>
#'   lapply(mean) %->%
#'   c(vs=)
#'
`%<-%` <- function(x, value) {
  force(value)

  pairs <- unpack(substitute(x), value)

  list_assign(pairs, parent.frame())

  invisible(value)
}

#' @rdname operator
#' @export
`%->%` <- function(value, x) {
  force(value)

  pairs <- unpack(substitute(x), value)

  list_assign(pairs, parent.frame())

  invisible(value)
}



