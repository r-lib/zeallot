#' Insert multiple assignment operator
#'
#' Call this function as an addin to insert \code{ \%<-\% } at the
#' cursor position.
#'
#' @return \code{structure(list(), .Names = character(0))}
#' @author David Kahle \email{david@@kahle.io}
#' @export
rs_addin_insert_multi_assign <- function() {
  rstudioapi::insertText(
    rstudioapi::getActiveDocumentContext()$selection[[1]]$range,
    " %<-% "
  )
}
