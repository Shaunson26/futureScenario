test_that("create_dataset_url", {

  res <-
    create_dataset_url(variable = csiro_catalog$variable$Solar_Radiation,
                       model = csiro_catalog$model$`NorESM1-M`,
                       rcp = csiro_catalog$rcp$rcp85,
                       year_range = csiro_catalog$year_range$`2016-2045`)

  expect_identical(res$url, 'https://data-cbr.csiro.au/thredds/ncss/catch_all/oa-aus5km/Climate_Change_in_Australia_User_Data/Application_Ready_Data_Gridded_Daily/Solar_Radiation/2016-2045/rsds_aus_NorESM1-M_rcp85_r1i1p1_CSIRO-MnCh-wrt-1986-2005-Scl_v1_day_2016-2045.nc')
})
