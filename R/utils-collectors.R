is_collector <- function(x) {
  isTRUE(startsWith(as.character(x), ".."))
}

collector_name <- function(x) {
  sub("^[.]{2}", "", as.character(x))
}

is_deprecated_collector <- function(x) {
  isTRUE(startsWith(as.character(x), "..."))
}

deprecated_collector_name <- function(x) {
  sub("^[.]{3}", "", as.character(x))
}

dep_warn_env <- list2env(list(warn = TRUE), parent = emptyenv())

dep_warn_reset <- function() {
  (dep_warn_env$warn <- TRUE)
}

dep_warn_once <- function(cnd) {
  if (isTRUE(dep_warn_env$warn)) {
    dep_warn_env$warn <- FALSE
    warning(cnd)
  }
}

dep_warn_call <- function() {
  sys_calls <-
    sys.calls()

  assignment_calls <-
    grepl("([.]{3}.+%<-%|%->%.+[.]{3})", as.character(sys_calls))

  if (!any(assignment_calls)) {
    return()
  }

  sys_calls[assignment_calls][[1]]
}

dep_warn_suggest_fix <- function(call) {
  if (length(call) == 0) {
    return()
  }

  call_str <- paste(deparse(call), collapse = " ")

  collector_str <-
    regmatches(call_str, regexpr("[.]{3}[^\\s,\\)]+", call_str, perl = TRUE))

  collector_fix <- sub("...", "..", collector_str, fixed = TRUE)

  paste0("`", collector_str, "` => `", collector_fix, "`")
}

dep_warn_msg <- function(call) {
  paste0(
    "collector syntax has changed,\n",
    "  * Please use `..` instead of `...`\n",
    "  * ", dep_warn_suggest_fix(call)
  )
}

dep_warn_cond <- function() {
  call <- dep_warn_call()

  warningCondition(
    message = dep_warn_msg(call),
    class = "deprecated_collector_warning",
    call = call
  )
}

deprecated_collector_warn <- function() {
  dep_warn_once(dep_warn_cond())
}
