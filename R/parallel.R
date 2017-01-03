parallel <- function(...) {
  args <- eval(substitute(alist(...)))
  evalenv <- parent.frame()

  if (length(args) == 1) {
    if (!grepl(.ASSIGNREGEX, args[[1]])) {
      stop('IN PROGRESS')
    }
  }

  assgnmnt <- which(grepl(.ASSIGNREGEX, args))
  rhand <- args[1:(assgnmnt - 1)]
  NULL
}
