#' Create CSIRO dataset URL
#'
#' Parameters used in determining the dataset URL
create_dataset_url <- function(variable, model, rcp, year_range){

  shorten_variable <- function(x){
    variable_map <-
      c(
        Solar_Radiation = 'rsds',
        Relative_Humidity = 'hurs',
        `Rainfall_(Precipitation)` = 'pr',
        Minimum_Temperature = 'tasmin',
        Mean_Temperature = 'tas',
        Maximum_Temperature = 'tasmax',
        Evaporation = 'wvap'
      )

    variable_map[x]
  }

  something_value <- function(x){
    ifelse(x %in% c('Rainfall_(Precipitation)'), 'DecCh', 'MnCh')
  }

  something_value <- something_value(variable)

  model_dataset <-
    glue::glue(csiro_catalog$filename,
               variable = shorten_variable(variable),
               model = model,
               rcp = rcp,
               something = something_value,
               year_range = year_range
    )

  httr2::request('https://data-cbr.csiro.au/') %>%
    httr2::req_url_path_append('thredds/ncss/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Daily') %>%
    httr2::req_url_path_append(variable) %>%
    httr2::req_url_path_append(year_range) %>%
    httr2::req_url_path_append(model_dataset)
}
