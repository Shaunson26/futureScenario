#' A shiny app with GNAF address selection and view on leaflet
#'
#' Start a shiny app with address selectors that show results on leaflet
#' @export
run_gnaf_leaflet_shiny <- function() {
  appDir <- system.file("shiny-examples", "gnaf-leaflet", package = "futureScenario")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `mypackage`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
