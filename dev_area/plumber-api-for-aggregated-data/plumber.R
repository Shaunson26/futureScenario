#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
library(magrittr)
library(dplyr)
library(jsonlite)

# mtcars %>%
#   filter(mpg < 20) %>%
#   toJSON(dataframe = 'columns')

climate_file <- "C:/Users/60141508/Downloads/2016-2045_tas_aus_NorESM1-M_rcp85_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc4"

climate_data <-
  stars::read_ncdf(climate_file, var = 'tas')%>%
  tibble::as_tibble()

#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.

#* Return the climate data by coordinates
#* @param lat lat
#* @param lon lon
#* @serializer rds
#* @get /tas
function(lat, lon) {
  #lat='-33.101'; lon='147.351'
  lat_round = round(as.numeric(lat) / 0.05) * 0.05
  lon_round = round(as.numeric(lon) / 0.05) * 0.05
  dplyr::filter(climate_data,
                dplyr::near(lat, lat_round),
                dplyr::near(lon, lon_round))
}

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg = "") {
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Return the mtcars by mpg
#* @serializer rds
#* @get /mtcars
function() {
  mtcars
}


