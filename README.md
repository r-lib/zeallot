<h1 align="center"> <img alt="zeallot" src="inst/logo.png" height="250"></h1>

Variable assignment with zeal!

[travis]: https://travis-ci.org/nteetor/zeallot.svg?branch=master "shake and bake"
[appveyor]: https://ci.appveyor.com/api/projects/status/github/nteetor/zeallot?branch=master&svg=true "frappe!" 
[coverage]: https://codecov.io/gh/nteetor/zeallot/branch/master/graph/badge.svg "deep fat fry" 
[cran]: https://www.r-pkg.org/badges/version/zeallot "getting there"

![alt text][travis] ![alt text][appveyor] ![alt text][coverage] ![alt text][cran]

Below is the zeallot syntax in action.
```R
x: y %<-% c(0, 1)
x
#> 0
y
#> 1
```

## What's to be excited about?

zeallot allows multiple or unpacking assignment in R. With zeallot you can 
tighten code with explicit variable names, unpack pieces of a lengthy list or 
the entirety of a small list, de-structure and assign object elements, or do a
little of all of these at once.

You can install zeallot from CRAN,
```R
install.packages('zeallot')
```

## Getting Started

A simple example using the [purrr](https://github.com/hadley/purrr) package.
The `purrr::safely` function returns a "safe" version of a function. From the
safely documentation examples,

```R
safe_log <- purrr::safely(log)
safe_log(10)
#> $result
#> [1] 2.302585
#>
#> $error
#> NULL

safe_log("a")
#> $result
#> NULL
#>
#> $error
#> <simpleError in .f(...): non-numeric argument to mathematical function>
```

A safe function always returns a list of two elements. Instead of throwing an 
error, the error element of the return list is set and the value element is
NULL. If no error occurs then the result element is set to the return value of
the original, unsafe, function and the error element is NULL. In either case an
error is not raised.

Safe functions are a great way to build flexible, reactive code. However,
dealing with a return value that is always a list could prove tedious. Enter
zeallot.

With zeallot we can unpack our safe function's return value into two explicit
variables and avoid dealing the list return value all together.

```R
{res: err} %<-% safe_log(10)
res
#> [1] 2.302585
err
#> NULL
```

zeallot defines the unpacking operator `%<-%`. On the left-hand side of the 
operator we create a list of bare variable names using colons and braces. These
variables do not have to be previously defined. On the right-hand side is our
vector, list, or other R objec to unpack.

After running the assignment expression on the first example line the `res` and
`err` variables are assigned the result and error values from our safe
function's list return.

For more on this example, other examples, and a thorough introduction to zeallot
check out the vignette on 
[unpacking assignment](vignettes/unpacking-assignment.Rmd).

---

Inspiration for this package goes to Paul Teetor.

Without his encouragement nothing would have gotten off the ground.
