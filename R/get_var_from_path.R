#' Get variable name from temporary file path
#'
#' download_netcdf_subset() save a file {randomChars}_{variable}_{model}_{rcp}_{date_range}.nc.
#' This function is used to sub the variable part
#'
#' @param character file path
#'
#' @return character
#'
#' @export
get_var_from_path <- function(x){
  strsplit(basename(x), split = '_')[[1]][2]
}
