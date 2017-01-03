unpack <- function(...) {
  args <- eval(substitute(alist(...)))
  nargs <- length(args)

  if (nargs == 0) {
    stop('expecting at least one argument', call. = FALSE)
  }

  if (!grepl('<-', deparse(args[[nargs]]))) {
    stop('missing expression to unpack', call. = FALSE)
  }

  if (length(args[[nargs]]) != 3) {
    stop('bad expression format, expecting ',
         '<name_1>, <name_2>, .., <name_N> <- <expression>',
         call. = FALSE)
  }

  expr <- args[[nargs]][[3]]
  args[[nargs]] <- args[[nargs]][[2]]

  if (any(vapply(args, class, character(1)) != 'name')) {
    stop('bad expression format, expecting ',
         '<name_1>, <name_2>, .., <name_N> <- <expression>',
         call. = FALSE)
  }

  evalenv <- parent.frame()

  values <- eval(expr, envir = evalenv)

  if (length(values) != nargs) {
    stop('expecting ', nargs, ' values to unpack', call. = FALSE)
  }

  for (i in seq_along(args)) {
    assign(as.character(args[[i]]), values[[i]], envir = evalenv,
           inherits = FALSE)
  }

  invisible(TRUE)
}
