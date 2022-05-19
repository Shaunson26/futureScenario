#' Wrangle urban vegetation cover results
#'
#' Wrangle list into  data.frame
#'
#' @param x, list, that from \code{map_urban_vegetation_cover_all}
#'
#' @return tibble / data.frame
#'
#' @export
map_urban_vegetation_cover_all <- function(x){

  attributes_labels <-
    c('PerAnyVeg' = 'Percent any vegetation',
      #'PerNonVeg' = 'Percent no vegetation',
      'PerGrass' = 'Percent grass',
      'PerShrub' = 'Percent shrubs',
      'PerTr03_10' = 'Percent short trees (3-10 m)',
      'PerTr10_15' = "Percent medium tress (10-15 m)",
      'PerTr15mPl' = "Percent tall trees (>15 m)")

  sapply(x$features, function(x) {
    x$attributes[names(attributes_labels)] %>%
      as.numeric()
  }) %>%
    rowMeans() %>%
    tibble::tibble(attributes = unname(attributes_labels),
           pct = .)

}
