library(httr2)
library(stars)
library(dplyr)
library(ggplot2)
aa <-
  return_address_coords(street_number = 74, street_name = 'WILKINS STREET', postcode = 2200)

aa_data <-
  download_netcdf_subset(lat = aa$LATITUDE, lon = aa$LONGITUDE,
                         date_start = '2016-01-01', date_end = '2030-01-01',
                         date_step = 30)

zz <- read_ncdf(aa_data, var = 'tas')

zz %>%
  as_tibble() %>%
  mutate(time = as.Date(time),
         tas = as.numeric(tas)) %>%
  group_by(time) %>%
  summarise(tas = mean(tas)) %>%
  ggplot(aes(x = time, y = tas)) +
  geom_line() +
  scale_x_date(date_breaks = '1 year',
               date_labels = '%Y') +
  labs(title = 'Climate projections - mean temperature',
       subtitle = paste(aa$NUMBER_FIRST, aa$STREET_NAME, aa$LOCALITY_NAME, aa$POSTCODE),
       y = 'Mean temperature (C)',
       x = 'Date') +
  theme_minimal() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())






  # a test file from netcdf subset web interface


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

