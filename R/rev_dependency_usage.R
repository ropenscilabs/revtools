#' Review dependency usage: Count used functions from external packages.
#'
#' @inheritParams functionMap::map_r_package
#'
#' @return A dataframe.
#' @export
#'
#' @examples
#' rev_dependency_usage(pkginspector_example("viridisLite"))
rev_dependency_usage <- function(path = ".", include_base = FALSE) {
  if (identical(path, ".")) {
    path <- usethis::proj_get()
  }

  map <- functionMap::map_r_package(path, include_base)$node_df
  map %>%
    dplyr::filter(!.data$own) %>%
    dplyr::filter(.data$ID != "::") %>%
    tidyr::separate(.data$ID, into = c("package", "fn"), sep = "::") %>%
    dplyr::group_by(.data$package) %>%
    dplyr::summarize(
      n = length(unique(.data$fn)), functions = paste0(.data$fn, collapse = ", ")
    )
}
