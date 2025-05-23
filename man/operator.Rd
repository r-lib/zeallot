% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/operator.R
\name{operator}
\alias{operator}
\alias{\%<-\%}
\alias{\%->\%}
\title{Multiple assignment operators}
\usage{
x \%<-\% value

value \%->\% x
}
\arguments{
\item{x}{A name structure, see section below.}

\item{value}{A list of values, vector of values, or \R object to assign.}
}
\value{
\code{\%<-\%} and \code{\%->\%} invisibly return \code{value}.

These operators are used primarily for their assignment side-effect.
\code{\%<-\%} and \code{\%->\%} assign into the environment in which they
are evaluated.
}
\description{
Assign values to name(s).
}
\section{Name Structure}{


\strong{The basics}

At its simplest, the name structure is a single variable name, in which
case \code{\%<-\%} and \code{\%->\%} perform regular assignment, \code{x
\%<-\% list(1, 2, 3)} or \code{list(1, 2, 3) \%->\% x}.

To specify multiple variable names use \code{c()}, for example \code{c(x, y, z)
\%<-\% c(1, 2, 3)}.

When \code{value} is neither an atomic vector nor a list, \code{\%<-\%} and
\code{\%->\%} will try to destructure \code{value} into a list before assigning
variables, see \code{\link[=destructure]{destructure()}}.

\strong{In-place assignment}

One may also assign into a list or environment, \code{c(x, x[[1]]) \%<-\%
list(list(), 1)}.

\strong{Nested names}

One can also nest calls to \code{c()}, \code{c(x, c(y, z))}. This nested structure is
used to unpack nested values, \code{c(x, c(y, z)) \%<-\% list(1, list(2,
3))}.

\strong{Collector variables}

To gather extra values from the beginning, middle, or end of \code{value} use a
collector variable. Collector variables are indicated with the \code{..}
prefix, \code{c(..x, y) \%<-\% list(1, 2, 3, 4)}.

\strong{Skipping values}

Use \code{.} in place of a variable name to skip a value without raising an error
or assigning the value, \code{c(x, ., z) \%<-\% list(1, 2, 3)}.

Use \code{..} to skip multiple values without raising an error or assigning the
values, \code{c(w, .., z) \%<-\% list(1, NA, NA, 4)}.

\strong{Default values}

Use \code{=} with a value to specify a default value for a variable,
\code{c(x, y = NULL) \%<-\% list(1)}.

Unfortunately, using a default value with in-place assignment raises an error
because of \R's syntax, \code{c(x, x[[1]] = 1) \%<-\% list(list())}.

\strong{Named assignment}

Use \code{=} \emph{without} a value to assign values by name, \code{c(two=) \%<-\% list(one = 1, two = 2, three = 3)}.
}

\examples{
# Basic usage
c(x, y) \%<-\% list(0, 1)

# Unpack and assign nested values
c(c(x, y), z) \%<-\% list(list(2, 3), list(3, 4))

# Assign columns of data frame
c(eruptions, waiting) \%<-\% faithful

# Assign specific columns by name
c(mpg=, hp=, gear=) \%<-\% mtcars

# Alternatively, assign a column by position
c(first_col, .., last_col) \%<-\% mtcars

# Skip initial values, assign final value
todo_list <- list("1. Make food", "2. Pack lunch", "3. Save world")

c(.., final_todo) \%<-\% todo_list

# Assign first name, skip middle initial, assign last name
c(first_name, ., last_name) \%<-\% c("Ursula", "K", "Le Guin")

# Unpack nested values w/ nested names
fibs <- list(1, list(2, list(3, list(5))))

c(f2, c(f3, c(f4, c(f5)))) \%<-\% fibs

# Unpack first numeric, leave rest
c(f2, ..rest) \%<-\% unlist(fibs)

# Swap values without using temporary variables
c(a, b) \%<-\% c("eh", "bee")

c(a, b) \%<-\% c(b, a)

# Handle missing values with default values
parse_time <- function(x) {
  strsplit(x, " ")[[1]]
}

c(hour, period = NA) \%<-\% parse_time("10:00 AM")

c(hour, period = NA) \%<-\% parse_time("15:00")

# Right operator
list(1, 2, "a", "b", "c") \%->\% c(x, y, ..z)

}
\seealso{
For more on unpacking custom objects please refer to
\code{\link[=destructure]{destructure()}}.
}
