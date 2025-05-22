
<!-- README.md is generated from README.Rmd. Please edit that file -->

# zeallot

Variable assignment with zeal!

![alt
text](https://codecov.io/gh/r-lib/zeallot/branch/master/graph/badge.svg "deep fat fry")
![alt
text](https://www.r-pkg.org/badges/version/zeallot "green means go!")

## What’s there to be excited about?

zeallot allows multiple, unpacking, or destructuring assignment in R by
providing the `%<-%` operator. With zeallot you can tighten code with
explicit variable names, unpack pieces of a lengthy list or the entirety
of a small list, destructure and assign object elements, or do it all at
once.

Unpack a list of values.

``` r
c(x, y) %<-% list(2, 3)

x
#> [1] 2
y
#> [1] 3
```

Destructure a data frame and assign its columns.

``` r
c(cyl=, wt=) %<-% mtcars

cyl
#>  [1] 6 6 4 6 8 6 8 4 4 6 6 8 8 8 8 8 8 4 4 4 4 8 8 8 8 4 4 4 8 6 8 4
wt
#>  [1] 2.620 2.875 2.320 3.215 3.440 3.460 3.570 3.190 3.150 3.440 3.440 4.070
#> [13] 3.730 3.780 5.250 5.424 5.345 2.200 1.615 1.835 2.465 3.520 3.435 3.840
#> [25] 3.845 1.935 2.140 1.513 3.170 2.770 3.570 2.780
```

Unpack a nested list into nested left-hand side variables.

``` r
c(c(x, y), z) %<-% list(list(1, 2), 3)

x
#> [1] 1
y
#> [1] 2
z
#> [1] 3
```

Destructure and partially unpack a list. “a” is assigned to `first` and
the remaining letters are grouped and assigned to one variable.

``` r
c(first, ..rest) %<-% letters

first
#> [1] "a"
unlist(rest)
#>  [1] "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t"
#> [20] "u" "v" "w" "x" "y" "z"
```

## Getting started

Below is a simple usage example using the
[purrr](https://github.com/tidyverse/purrr) package and the safely
function.

### Safe functions

The `purrr::safely` function returns a “safe” version of a function. The
following example is borrowed from the safely documentation. In this
example a safe version of the log function is created.

``` r
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
#> <simpleError in .Primitive("log")(x, base): non-numeric argument to mathematical function>
```

A safe function always returns a list of two elements and will not throw
an error. Instead of throwing an error, the error element of the return
list is set and the value element is NULL. When called successfully the
result element is set and the error element is NULL.

Safe functions are a great way to write self-documenting code. However,
dealing with a return value that is always a list could prove tedious
and may undo efforts to write concise, readable code. Enter zeallot.

### The `%<-%` operator

With zeallot’s unpacking operator `%<-%` we can unpack a safe function’s
return value into two explicit variables and avoid dealing with the list
return value all together.

``` r
c(res, err) %<-% safe_log(10)

res
#> [1] 2.302585
err
#> NULL
```

The name structure of the operator is a flat or nested set of bare
variable names built with calls to `c()`. . These variables do not need
to be previously defined. On the right-hand side is a vector, list, or
other R object to unpack. `%<-%` unpacks the right-hand side, checks the
number of variable names against the number of unpacked values, and then
assigns each unpacked value to a variable. The result, instead of
dealing with a list of values there are two distinct variables, `res`
and `err`.

### Further reading and examples

For more on the above example, other examples, and a thorough
introduction to zeallot check out the vignette on [unpacking
assignment](vignettes/unpacking-assignment.Rmd).

Below are links to discussions about multiple, unpacking, and
destructuring assignment in R,

- <https://stackoverflow.com/questions/7519790/assign-multiple-new-variables-on-lhs-in-a-single-line-in-r>
- <https://stackoverflow.com/questions/1826519/how-to-assign-from-a-function-which-returns-more-than-one-value>

## Installation

You can install the development version of zeallot from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("r-lib/zeallot")
```

------------------------------------------------------------------------

Thank you to Paul Teetor for inspiring me to build zeallot.

Without his encouragement nothing would have gotten off the ground.
