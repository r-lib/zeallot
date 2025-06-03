# zeallot 0.2.0

## Breaking changes

* The collector syntax has changed. The previous syntax `...` was incompatible
  with `R CMD check` and would raise the error "... may be used in an incorrect
  context". The new syntax `..` (double dots instead of triple) avoids this
  error. (#62)

  ```R
  # new
  c(x, ..) %<-% list(1, 2, 3)
  
  # old
  c(x, ...) %<-% list(1, 2, 3)
  ```
  
* The `destructure` methods for the Date, character, and complex classes have
  been removed.
  
## New features

* Values may now be assigned by name. The new syntax allows assigning a 
  value to a variable by name instead of position. (#47)
  
  ```R
  c(disp=, gear=) %<-% mtcars
  ```
  
* For package developers, the new function `zeallous()` will prevent 
  `R CMD check` from raising visible binding errors for variables assigned using
  `%<-%`. Call the function from a package's `.onLoad` function. (#57)
  
  ```R
  .onLoad <- function(libname, pkgname) {
    zeallous()
  }
  ```

## Major improvements

* Collector variables now default to an empty list instead of raising an error
  when there are no values to collect. (#56)
  
  ```R
  c(x, ..y) %<-% list(1)
  ```

* Trailing anonymous collectors and value skips no longer raise errors.
  
  ```R
  c(x, ..) %<-% list(1)
  
  c(y, .) %<-% list(1)
  ```

## Minor improvements

* Error messages have been simplified.

* R versions >= 3.2 are formally supported.

# zeallot 0.1.0

## Major Improvements

* Bumped to stable version.

## Minor Improvements

* Removed outdate language in the unpacking assignment vignette. (#36)

## Bug Fixes

* Destructuring objects with multiple classes will no longer raise a
  warning. (#35)

# zeallot 0.0.6.1

## Bug Fixes

* Resolved problem where collector variables would not be assigned the correct   default value. (#34)

# zeallot 0.0.6

## Major Improvements

* The left-hand side may now contain calls to `[[`, `[`, and `$` allowing
  assignment of parts of objects. The parent object must already
  exist, otherwise an error is raised. (@rafaqz, #32)

# zeallot 0.0.5

## Major Changes

* The bracket and colon syntax has been completely removed, users will now see
  an "unexpected call `{`" error message when attempting to use the old syntax.
  Please use the `c()` syntax for the name structure.

## Major Improvements

* A `%->%` operator has been added. The right operator performs the same
  operation as `%<-%` with the name structure on the right-hand side and
  the values to assign on the left-hand side.
* `=` may be used to specify the default value of a variable. A default value
  is used when there are an insufficient number of values.

# zeallot 0.0.4

## Major Changes

* The bracket and colon syntax has been deprecated in favor of a lighter syntax
  which uses calls to `c()`. Documentation and vignettes has been updated
  accordingly. Using the old syntax now raises a warning and will be removed in
  future versions of zeallot. (@hadley, #21)

## Minor Improvements

* `%<-%` can now be used for regular assignment. (@hadley, #17)
* `...` can now be used to skip multiple values without assigning those values
  and is recommended over the previously suggested `....`. (@hadley, #18)

## Miscellaneous Changes

* `massign()` is no longer exported.

## Bug Fixes

* Numerics on left-hand side are no longer unintentionally quoted, thus no
  longer treated as valid variable names, and will now raise an error.
  (@hadley, #20)
* Language objects on left-hand side are no longer treated as symbols and will
  now raise an error. (@hadley, #20)

# zeallot 0.0.3

* see 0.0.2.1 notes for additional updates

## Minor Improvements

* Examples now consistently put spaces around colons separating left-hand side
  variables, e.g. `a : b` instead of `a: b`.

## Bug Fixes

* When unpacking an atomic vector, a collector variable will now collect values
  as a vector. Previously, values were collected as a list (#14).

# zeallot 0.0.2.1

* Not on CRAN, changes will appear under version 0.0.3

* Added missing URL and BugReports fields to DESCRIPTION
* Fixed broken badges in README

# zeallot 0.0.2

* Initial CRAN release
* zeallot 0.0.1 may be installed from GitHub
