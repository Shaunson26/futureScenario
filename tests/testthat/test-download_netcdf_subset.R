test_that("bbox or lat/lon works", {

  expect_error(
    download_netcdf_subset(variable = 1,
                           model = 1,
                           rcp = 1,
                           year_range = 1,
                           date_start = '2016-01-01', date_end = '2045-12-31',
                           date_step = 30, method = 'test')
  )

  expect_error(
  download_netcdf_subset(variable = 1,
                         model = 1,
                         rcp = 1,
                         year_range = 1,
                         bbox = nsw_bbox,
                         lat = 1, lon = 1,
                         date_start = '2016-01-01', date_end = '2045-12-31',
                         date_step = 30, method = 'test')
  )
})
