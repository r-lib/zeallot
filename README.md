# allotalot

Parallel <strike>alloting</strike> assignment in R

[travis]: https://travis-ci.org/nteetor/allotalot.svg?branch=master "lots o' building"
[appveyor]: https://ci.appveyor.com/api/projects/status/github/nteetor/allotalot?branch=master&svg=true "lots o' 'veyors"
[coverage]: https://codecov.io/gh/nteetor/allotalot/branch/master/graph/badge.svg "lots o' coverage"
[cran]: https://www.r-pkg.org/badges/version/allotalot "getting there"

![alt text][travis] ![alt text][appveyor] ![alt text][coverage] ![alt text][cran]

## Getting Started

A first example,

```R
library(allotalot)

.(a, b) %<-% list(0, 1)
a
#> 0
b
#> 1
```

A few interesting or more demonstrative examples,

```R
# assign more than 2 values
.(one, two, three, four) %<-% list(1, 2, 3, 4)
one 
#> 1
two
#> 2
three
#> 3
four
#> 4

# use nested calls to `.()`
.(a, .(c, d), b) %<-% list('hello', list('goodnight', 'moon'), 'world')
a
#> "hello"
b
#> "world"
c
#> "goodnight"
d
#> "moon"

# unpack the dimensions of an object
.(nrows, ncols) %<-% unpack(dim(mtcars))
nrows
#> 32
ncols
#> 11

# swap values without using a temporary variable
.(nrows, ncols) %<-% list(ncols, nrows)
nrows
#> 11
ncols
#> 32
```

The `%<-%` operator can stand in for the standard assignment operator `<-`. Because of this, vectors and objects with an underlying list structure are not unpacked. Use the `unpack()` function provided in allotalot to force unpacking of vectors or list-like objects.

```R
# standard assignment
groceries %<-% list('eggs', 'spinach', 'carrots', 'kiwis')

smry %<-% summary(lm(mpg ~ disp, data = mtcars))

# trivial "unpacking"
.(fear1) %<-% 'The sea in storm'

# this will throw an error
.(a, b) %<-% c('whoops', 'error')

# use `unpack()` to fix the problem
.(a, b) %<-% unpack(c('whoops', 'error'))
```

## Installation

allotalot can be installed using devtools:
```R
# install.packages('devtools')
devtools::install_github('nteetor/allotalot')
```

## Vignette

For more information you can always refer to the introductory vignette.

---

Enjoy alloting a lot of values!
