library(devtools)

# Package loading stuff ---
load_all()
document()
#check()
#install()

use_vignette('wrangle-meshblock')


use_r('nsw_bbox')

# Testing stuff ----
# test-return_address_coords() done
run_gnaf_leaflet_shiny()

addr <-
  return_address_coords(street_number = 6, street_name = 'AMALFI DRIVE', postcode = 2127)

tmp_fun <- function(x, method){
  download_netcdf_subset(variable = x,
                         model = csiro_catalog$model$`NorESM1-M`,
                         rcp = csiro_catalog$rcp$rcp85,
                         year_range = csiro_catalog$year_range$`2016-2045`,
                         lat = addr$LATITUDE, lon = addr$LONGITUDE,
                         date_start = '2016-01-01', date_end = '2045-12-31',
                         date_step = 30, method = method)
}

rsds <- tmp_fun(csiro_catalog$variable$Solar_Radiation, method = 'httr2')
hurs <- tmp_fun(csiro_catalog$variable$Relative_Humidity, method = 'httr2')
pr <- tmp_fun(csiro_catalog$variable$`Rainfall_(Precipitation)`, method = 'httr2')
tasmin <- tmp_fun(csiro_catalog$variable$Minimum_Temperature, method = 'httr2')
tas <- tmp_fun(csiro_catalog$variable$Mean_Temperature, method = 'httr2')
tasmax <- tmp_fun(csiro_catalog$variable$Maximum_Temperature, method = 'httr2')
wvap <- tmp_fun(csiro_catalog$variable$Evaporation, method = 'httr2')

library(stars)
library(dplyr)
library(ggplot2)

zz <-
  list(hurs,
       pr,
       tasmin,
       tas,
       tasmax,
       wvap) %>%
  lapply(., function(x){
    var = strsplit(basename(x), split = '_')[[1]][2]
    stars::read_ncdf(x, var = var)
  })

class_PCICt <- function(x){
  class(x)[1] == 'PCICt'
}

purrr::map_df(zz, function(x){
  x %>%
    as_tibble() %>%
    select(everything(), value = 4) %>%
    mutate(across(where(class_PCICt), as.character),
           time = as.Date(time),
           value = as.numeric(value),
           var = names(x)) %>%
    group_by(var, time) %>%
    summarise(value = mean(value)) %>%
    ungroup()
}) %>%
  ggplot(aes(x = time, y = value)) +
  geom_line() +
  scale_x_date(date_breaks = '1 year',
               date_labels = '%Y') +
  labs(title = 'Climate projections',
       subtitle = with(addr, paste(NUMBER_FIRST, STREET_NAME, LOCALITY_NAME, POSTCODE)),
       y = 'value (units)',
       x = 'Date') +
  facet_wrap(~var, scales = 'free_y', ncol=1) +
  theme_minimal() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.text.x = element_text(angle = 90, hjust = 0))

##
hvi_resp <-
  return_address_coords(street_number = 37, street_name = 'ST PAULS CRESCENT', locality = 'LIVERPOOL', postcode = '2170') %>%
  #return_address_coords(street_number = 1, street_name = 'ABBEY ROAD', locality = 'GOULBURN') %>%
  join_sa1() %>%
  dplyr::pull(SA1_MAINCODE_2016) %>%
  get_heat_vulnerability_index() %>%
  map_heat_vulnerability_index()

uhi_resp <-
  return_address_coords(street_number = 9, street_name = 'BEDFORD STREET', locality = 'EARLWOOD', postcode = '2206') %>%
  #return_address_coords(street_number = 1, street_name = 'ABBEY ROAD', locality = 'GOULBURN') %>%
  dplyr::pull(MB_2016_CODE) %>%
  get_urban_heat_island_value() %>%
  map_urban_heat_island_value()

uvca_resp <-
  return_address_coords(street_number = 9, street_name = 'BEDFORD STREET', locality = 'EARLWOOD', postcode = '2206') %>%
  #return_address_coords(street_number = 1, street_name = 'ABBEY ROAD', locality = 'GOULBURN') %>%
  dplyr::pull(MB_2016_CODE) %>%
  get_urban_vegetation_cover_all() %>%
  map_urban_vegetation_cover_all()





# Recorded steps ----
use_r('return_address_coords')
use_mit_license()
use_readme_rmd()

use_r('get_heat_vulnerability_index')
use_r('gnaf-leaflet-example')

# Required packages
use_package('shiny')
use_package('tibble')
use_package('leaflet')
use_package('dplyr')
use_package('base')
use_package('httr2')
use_package('reactable')
use_package('htmltools')
use_package('RColorBrewer')
use_package('tibble')

# Add gnaf to package data
use_test('create_dataset_url')
use_r('create_dataset_url')
use_r('csiro_catalog')
gnaf <- readRDS('gnaf_min.rds')
use_r('gnaf')
use_r('mb_2016-to-SA1_2016')
use_data(gnaf)
use_data(mb2016_to_sa12016)
use_r('join_sa1')
use_r('map_heat_vulnerability_index')
use_r('get_urban_vegetation_cover_all')
use_r('map_urban_vegetation_cover_all')
use_r('service_urls')
use_r('query_api')
use_r('get_urban_heat_island_value')
use_r('map_urban_heat_island_value')



