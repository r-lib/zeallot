# allotalot

> Parallel Assignment in R

The package in action,

```R
library(allotalot)

.(a, b) %<-% list(1, 2)
a
#> 1
b
#> 2
```

A more complex example,
```R
.(a, .(c, d), b) %<-% list('hello', list('goodnight', 'moon'), 'world')
a
#> "hello"
b
#> "world"
c
#> "goodnight"
d
#> "moon"
```

Vectors are not unpacked and the following will throw an error,
```R
.(a, b) %<-% c('whoops', 'error')
```

To work around this use `as.list`,
```R
.(a, b) %<-% as.list(c('whoops', 'error'))
```

One can also swap variable values,
```R
prv <- 2016
nxt <- 2017
.(prv, nxt) <- list(nxt, prv)
prv
#> 2017
nxt
#> 2016
```

allotalot can be installed using devtools:
```R
# install.packages('devtools')
devtools::install_github('nteetor/allotalot')
```

For more information refer to the introductory vignette.