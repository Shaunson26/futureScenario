#' GNAF wrangling
#'
#' GNAF is a set of relational tables designed for a database. A simple flat table can
#' be made.
#'
#' data obtained from https://data.gov.au/dataset/ds-dga-19432f89-dc3a-4ef3-b943-5326ef1dbecc/details
#'
#' 1.5 Gb zip, has all states
#' NSW tables were extracted to my downloads folder (not synced with work one drive)

library(dplyr)

nsw <- list.files('C:/Users/60141508/Downloads/nsw_gnaf', full.names = T)
names(nsw) <- basename(nsw)
nsw <- as.list(nsw)
names(nsw)

# show whats in
lapply(nsw, readLines, n=5)
#GANSW715656125

# Join
street_number_postcode <- readr::read_delim(nsw$NSW_ADDRESS_DETAIL_psv.psv, delim = '|')
street_name <- readr::read_delim(nsw$NSW_STREET_LOCALITY_psv, delim = '|')
locality_name <- readr::read_delim(nsw$NSW_LOCALITY_psv.psv, delim = '|')
geocode <- readr::read_delim(nsw$NSW_ADDRESS_DEFAULT_GEOCODE_psv.psv, delim = '|')
meshblock_2016 <- readr::read_delim(nsw$NSW_ADDRESS_MESH_BLOCK_2016_psv.psv, delim = '|')
meshblock_2016_code <- readr::read_delim(nsw$NSW_MB_2016_psv.psv, delim = '|')

# Clean + free memory
# 4,921,334 to 2,801,406 ... keep the first ID of a street number
street_number_postcode <-
  street_number_postcode %>%
  select(ADDRESS_DETAIL_PID, NUMBER_FIRST, STREET_LOCALITY_PID, LOCALITY_PID, POSTCODE) %>%
  distinct(NUMBER_FIRST, STREET_LOCALITY_PID, LOCALITY_PID, POSTCODE, .keep_all = T)

gnaf_flat <-
  street_number_postcode %>%
  left_join(
    street_name %>%
      select(STREET_LOCALITY_PID, STREET_NAME, STREET_TYPE_CODE),
    by = 'STREET_LOCALITY_PID') %>%
  left_join(
    locality_name %>%
      select(LOCALITY_PID, LOCALITY_NAME),
    by = 'LOCALITY_PID'
  ) %>%
  left_join(
    geocode %>%
      select(ADDRESS_DETAIL_PID, LONGITUDE, LATITUDE),
    by = 'ADDRESS_DETAIL_PID'
  ) %>%
  left_join(
    meshblock_2016 %>%
      select(ADDRESS_DETAIL_PID, MB_2016_PID),
    by = 'ADDRESS_DETAIL_PID'
  ) %>%
  left_join(
    meshblock_2016_code %>%
      select(MB_2016_PID, MB_2016_CODE),
    by = 'MB_2016_PID'
  )

gnaf_flat <-
  gnaf_flat %>%
  mutate(STREET_NAME = paste(STREET_NAME, STREET_TYPE_CODE),
         STREET_NAME = sub(' NA$', '', STREET_NAME)) %>%
  select(NUMBER_FIRST, STREET_NAME, LOCALITY_NAME, POSTCODE,  LONGITUDE, LATITUDE, MB_2016_CODE)

gnaf_flat <-
  gnaf_flat %>%
  arrange(POSTCODE,STREET_NAME, LOCALITY_NAME, NUMBER_FIRST) %>%
  mutate(across(c(NUMBER_FIRST, POSTCODE), .fns = as.integer),
         MB_2016_CODE = as.character(MB_2016_CODE))

gnaf <- gnaf_flat

use_data(gnaf, overwrite = TRUE)

