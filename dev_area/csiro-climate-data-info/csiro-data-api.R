# Data API
# save-as link
#https://data-cbr.csiro.au/thredds/ncss/grid/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Daily/Mean_Temperature/2016-2045/tas_aus_NorESM1-M_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc/dataset.html
# netcdf subset URL
#https://data-cbr.csiro.au/thredds/ncss/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Daily/Mean_Temperature/2016-2045/tas_aus_NorESM1-M_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc?var=tas&north=-27&west=140&east=156.2500&south=-40&disableProjSubset=on&horizStride=1&time_start=2016-01-01T00%3A00%3A00Z&time_end=2016-02-01T00%3A00%3A00Z&timeStride=1&accept=netcdf
#https://data-cbr.csiro.au/thredds/ncss/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Daily/Mean_Temperature/2016-2045/tas_aus_CESM1-CAM5_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc/dataset.html

#2016-01-01T00:00:00Z
#format(Sys.time(), '%FT%TZ')
format(Sys.Date(), '%FT%TZ')

csiro <-
  list(
    base = 'https://data-cbr.csiro.au/',
    thredds = 'thredds/ncss/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Daily',
    variable = 'Mean_Temperature',
    year_range = '2016-2045',
    model_dataset = 'tas_aus_NorESM1-M_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc', #?
    query = list(var='tas',
                 north=-33.830,#-27,
                 west=151.070, #140,
                 east=151.080, #156.2500,
                 south=-33.8320,#-40,
                 disableProjSubset='on',
                 horizStride=1,
                 time_start='2016-01-01T00:00:00Z',
                 time_end='2016-01-02T00:00:00Z',
                 timeStride=1,
                 accept='netcdf')
  )

library(httr2)

return_address_coords(street_number = 6, street_name = 'AMALFI DRIVE', postcode = 2127) %>%
  dplyr::select(LONGITUDE, LATITUDE) %>%
  as.data.frame()

resp <-
  request(csiro$base) %>%
  req_url_path_append(csiro$thredds) %>%
  req_url_path_append(csiro$variable) %>%
  req_url_path_append(csiro$year_range) %>%
  req_url_path_append(csiro$model_dataset) %>%
  req_url_query(!!!csiro$query) %>%
  req_perform()





# a test file from netcdf subset web interface
library(stars)
library(dplyr)
library(ggplot2)

test_file <- "C:/Users/60141508/Downloads/2016-2045_tas_aus_NorESM1-M_rcp45_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc"

aa <- read_ncdf(test_file, var = 'tas')

aa_dims <- attributes(aa)$dim

lon_vec <-
  with(aa_dims$lon,
       seq(offset, by = delta, length = to))

lat_vec <-
  with(aa_dims$lat,
       seq(offset, by = delta, length = to))
bb <-
  return_address_coords(street_number = 6, street_name = 'AMALFI DRIVE', postcode = 2127) %>%
  select(LONGITUDE, LATITUDE)

# lon_vec[which.min(abs(bb$LONGITUDE - lon_vec))]
# lat_vec[which.min(abs(bb$LATITUDE - lat_vec))]

aa %>%
  slice('lon', which.min(abs(bb$LONGITUDE - lon_vec))) %>%
  slice('lat', which.min(abs(bb$LATITUDE - lat_vec))) %>%
  as_tibble() %>%
  mutate(time = as.Date(time + 1)) %>%
  ggplot(aes(x = time, y = as.numeric(tas))) +
  geom_line() +
  scale_x_date(date_breaks = '7 days',
               date_labels = '%d-%m-%Y') +
  labs(title = 'Some model predictions',
       subtitle = '6 AMALFI DRIVE WENTWORTH POINT 2127',
       y = 'Mean temperature (C)',
       x = 'Date')

##
test_file <- "C:/Users/60141508/Downloads/2016-2045_tas_aus_NorESM1-M_rcp85_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_day_2016-2045 (2).nc4"

aa <- read_ncdf(test_file, var = 'tas')

aa %>%
  as_tibble()

