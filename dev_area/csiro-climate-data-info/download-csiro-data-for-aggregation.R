#' Download data-cbr.csiro.au data
#'

library(devtools)

load_all()

downloaded_file_path <-
  download_netcdf_subset(variable = csiro_catalog$variable$Mean_Temperature,
                         model = csiro_catalog$model$`NorESM1-M`,
                         rcp = csiro_catalog$rcp$rcp45,
                         year_range = csiro_catalog$year_range$`2016-2045`,
                         # nsw wide
                         bbox = nsw_bbox,
                         # full range
                         date_start = '2016-01-01', date_end = '2045-12-31',
                         # every 15 days
                         date_step = 15,
                         method = 'httr')




