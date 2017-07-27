# zeallot 0.0.4

## Major Changes

* The bracket and colon syntax has been deprecated in favor of a lighter syntax.
  Documentation has been updated accordingly, see docs for more information
  about the new syntax. Using the old syntax will raise a warning and will be
  removed in future versions of zeallot. Thank you to Hadley for the suggestion.
  (@hadley, #21)
  
## Minor Improvements

* `%<-%` can now be used for regular assignment. (@hadley, #17)
* `...` can now be used to skip multiple values without assigning those values
  and is now recommended over the previously suggested `....`. (@hadley, #18)
  
## Miscellaneous Changes

* `massign()` is no longer exported.

## Bug Fixes

* Numerics on left-hand side are no longer unintentionally quoted and will now
  raise an error. (@hadley, #20)
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
