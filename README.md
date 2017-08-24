# zeallot

Variable assignment with zeal!

[travis]: https://travis-ci.org/nteetor/zeallot.svg?branch=master "shake and bake"
[appveyor]: https://ci.appveyor.com/api/projects/status/github/nteetor/zeallot?branch=master&svg=true "frappe!" 
[coverage]: https://codecov.io/gh/nteetor/zeallot/branch/master/graph/badge.svg "deep fat fry" 
[cran]: https://www.r-pkg.org/badges/version/zeallot "green means go!"
[downloads]: https://cranlogs.r-pkg.org/badges/last-month/zeallot "[====] 100%"

![alt text][travis] ![alt text][appveyor] ![alt text][coverage] ![alt text][cran] ![alt text][downloads]

## What's there to be excited about?

zeallot allows multiple, unpacking, or destructuring assignment in R by
providing the `%<-%` operator. With zeallot you can tighten code with explicit
variable names, unpack pieces of a lengthy list or the entirety of a small list,
destructure and assign object elements, or do it all at once.

Unpack a vector of values.
```R
c(x, y) %<-% c(0, 1)
#> x
#[1] 0
#> y
#[1] 1
```

Unpack a list of values. 
```R
c(r, d) %<-% list(2, 2)
#> r
#[1] 2
#> d
#[1] 2
```

Destructure a data frame and assign its columns.
```R
c(duration, wait) %<-% head(faithful)

#> duration
#[1] 3.600 1.800 3.333 2.283 4.533 2.883
#> wait
#[1] 79 54 74 62 85 55
```

Unpack a nested list into nested left-hand side variables.
```R
c(c(a, b), c(c, d)) %<-% list(list(1, 2), list(3, 4))
#> a
#[1] 1
#> b  
#[1] 2
#> c
#[1] 3
#> d
#[1] 4
```

Destructure and partially unpack a list. "a" is assigned to `first`, but
"b", "c", "d", and "e" are grouped and assigned to one variable.
```R
c(first, ...rest) %<-% list("a", "b", "c", "d", "e")
first
#[1] "a"
rest
#[[1]]
#[1] "b"
#
#[[2]]
#[1] "c"
#
#[[3]]
#[1] "d"
#
#[[4]]
#[1] "e"
```

### Installation

You can install zeallot from CRAN.

```R
install.packages('zeallot')
```

Use devtools to install the latest, development version of zeallot from GitHub.

```R
devtools::install_github('nteetor/zeallot')
```

## Getting Started

Below is a simple example using the [purrr](https://github.com/hadley/purrr)
package and the safely function.

### Safe Functions

The `purrr::safely` function returns a "safe" version of a function. The 
following example is borrowed from the safely documentation. In this example a
safe version of the log function is created.

```R
safe_log <- purrr::safely(log)
safe_log(10)
#$result
#[1] 2.302585
#
#$error
#NULL

safe_log("a")
#$result
#NULL
#
#$error
#<simpleError in .f(...): non-numeric argument to mathematical function>
```

A safe function always returns a list of two elements and will not throw an 
error. Instead of throwing an error, the error element of the return list is set
and the value element is NULL. When called successfully the result element is
set and the error element is NULL.

Safe functions are a great way to write self-documenting code. However, dealing
with a return value that is always a list could prove tedious and may undo
efforts to write concise, readable code. Enter zeallot.

### The `%<-%` Operator

With zeallot's unpacking operator `%<-%` we can unpack a safe function's return
value into two explicit variables and avoid dealing with the list return value
all together.

```R
c(res, err) %<-% safe_log(10)
res
#[1] 2.302585
err
#NULL
```

The name structure of the operator is a flat or nested set of bare variable
names built with calls to `c()`. . These variables do not need to be previously
defined. On the right-hand side is a vector, list, or other R object to unpack.
`%<-%` unpacks the right-hand side, checks the number of variable names against
the number of unpacked values, and then assigns each unpacked value to a
variable. The result, instead of dealing with a list of values there are two
distinct variables, `res` and `err`.

### Further Reading and Examples

For more on the above example, other examples, and a thorough introduction to
zeallot check out the vignette on [unpacking
assignment](vignettes/unpacking-assignment.Rmd).

Below are links to discussions about multiple, unpacking, and destructuring
assignment in R,

* https://stackoverflow.com/questions/7519790/assign-multiple-new-variables-on-lhs-in-a-single-line-in-r
* https://stackoverflow.com/questions/1826519/how-to-assign-from-a-function-which-returns-more-than-one-value

## Related work

The [vadr](https://github.com/crowding/vadr) package includes a
[bind](https://github.com/crowding/vadr/blob/master/R/bind.R#L65) operation
with much of the same functionality as `%<-%`. As the author states, "[they]
strongly prefer there to be a `<-` anywhere that there is a modification to the
environment." If you feel similarly I suggest looking at vadr. Unfortunately the
vadr package is not on CRAN and will need to be installed using
`devtools::install_github()`.

---

Thank you to Paul Teetor for inspiring me to build zeallot.

Without his encouragement nothing would have gotten off the ground.
