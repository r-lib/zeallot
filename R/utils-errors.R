local_error_call <- function() {
  sys_calls <-
    sys.calls()

  assignment_calls <-
    grepl("(%<-%|%->%)", as.character(sys_calls))

  if (!any(assignment_calls)) {
    return()
  }

  sys_calls[assignment_calls][[1]]
}

local_error_cnd <- function(msg) {
  errorCondition(
    message = msg,
    class = "zeallot_assignment_error",
    call = local_error_call()
  )
}

local_error_stop <- function(..., sep = "", collapse = "\n") {
  stop(
    local_error_cnd(
      paste(..., sep = sep, collapse = collapse)
    )
  )
}