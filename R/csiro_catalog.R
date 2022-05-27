csiro_catalog <-
  list(
    variable = list(
      `Solar_Radiation` =  "Solar_Radiation",
      `Relative_Humidity` =  "Relative_Humidity",
      `Rainfall_(Precipitation)` =  "Rainfall_(Precipitation)",
      `Minimum_Temperature` =  "Minimum_Temperature",
      `Mean_Temperature` =  "Mean_Temperature",
      `Maximum_Temperature` =  "Maximum_Temperature",
      `Evaporation` =  "Evaporation"
    ),
    year_range = list(
      `2016-2045` = '2016-2045',
      `2036-2066` = '2036-2066',
      `2056-2085` = '2056-2085',
      `2075-2104` = '2075-2104'
    ),
    model = list(
      `NorESM1-M` =  "NorESM1-M",
      `MIROC5` =  "MIROC5",
      `HadGEM2-CC` =  "HadGEM2-CC",
      `GFDL-ESM2M` =  "GFDL-ESM2M",
      `CanESM2` =  "CanESM2",
      `CNRM-CM5` =  "CNRM-CM5",
      `CESM1-CAM5` =  "CESM1-CAM5",
      `ACCESS1-0` =  "ACCESS1-0"
    ),
    rcp = list(
      `rcp45` =  "rcp45",
      `rcp85` =  "rcp85"
    ),
    filename = '{variable}_aus_{model}_{rcp}_r1i1p1_CSIRO-{something}-wrt-1986-2005-Scl_v1_day_{year_range}.nc'
  )


