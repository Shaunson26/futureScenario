#' Meshblock 2016 concordance
#'
#'  Downloaded from the meshblock page on ABS
#' https://www.abs.gov.au/AUSSTATS/abs@.nsf/Lookup/1270.0.55.001Main+Features10018July%202016?OpenDocument

library(dplyr)

aa <- readr::read_csv('dev_area/MB_2016_NSW.csv')

mb2016_to_sa12016 <-
  aa %>%
  select(MB_CODE_2016, SA1_MAINCODE_2016) %>%
  mutate(across(.fns = as.character))


usethis::use_data(mb2016_to_sa12016)
