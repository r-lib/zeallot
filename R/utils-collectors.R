is_collector <- function(x) {
  isTRUE(startsWith(as.character(x), ".."))
}

collector_name <- function(x) {
  sub("^[.]{2}", "", as.character(x))
}
