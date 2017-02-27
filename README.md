<h1 align="center"> <img alt="zeallot" src="inst/logo.png"></h1>

Variable assignment with zeal!

[travis]: https://travis-ci.org/nteetor/zeallot.svg?branch=master "shake and bake"
[appveyor]: https://ci.appveyor.com/api/projects/status/github/nteetor/zeallot?branch=master&svg=true "frappe!" 
[coverage]: https://codecov.io/gh/nteetor/zeallot/branch/master/graph/badge.svg "deep fat fry" 
[cran]: https://www.r-pkg.org/badges/version/zeallot "green means go!"

![alt text][travis] ![alt text][appveyor] ![alt text][coverage] ![alt text][cran]

## What's there to be excited about?

zeallot allows multiple or unpacking assignment in R by providing the `%<-%`
operator. With zeallot you can tighten code with explicit variable names, unpack
pieces of a lengthy list or the entirety of a small list, de-structure and
assign object elements, or do it all at once.

```R
x : y %<-% c(0, 1)
#> x
# [1] 0
#> y
# [1] 1

{r : d} %<-% list(2, 2)
#> r
# [1] 2
#> d
# [1] 2

{duration : wait} %<-% faithful

# duration  (first column of `faithful`)
# wait      (second column)

{{a : b} : {c : d}} %<-% list(list(1, 2), list(3, 4))
#> a
# [1] 1
#> b  
# [1] 2
#> c
# [1] 3
#> d
# [1] 4

{first : ...rest} %<-% as.list(letters)
#> first
# [1] "a"
#> rest  # the remaining values of `letters`
# [[1]]
# [1] "b"
# 
# [[2]]
# [1] "c"
#
# ..
# 
# [[24]]
# [1] "y"
# 
# [[25]]
# [1] "z"
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
{res : err} %<-% safe_log(10)
res
#> [1] 2.302585
err
#> NULL
```

On the left-hand side of the operator is a list of bare variable names using
colons and braces. These variables do not need to be previously defined. On the
right-hand side is a vector, list, or other R object to unpack. `%<-%` unpacks
the right-hand side, checks the number of variable names against the number of
unpacked values, and then assigns each unpacked value to a variable. The result,
instead of dealing with a list of values there are two distinct variables, `res`
and `err`.

### Further Reading and Examples

For more on the above example, other examples, and a thorough introduction to
zeallot check out the vignette on [unpacking
assignment](vignettes/unpacking-assignment.Rmd).

---

Thank you to Paul Teetor for inspiring me to build zeallot.

Without his encouragement nothing would have gotten off the ground.
