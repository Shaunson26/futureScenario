library(httr2)

# could use request + req_url_path_append if always from same base url

#https://mapprod2.environment.nsw.gov.au/arcgis/rest/services/UHGC/UHGC/MapServer/1/query?objectIds=1&f=pjson&returnGeometry=false&where=SA1_MAIN16+%3D+%2710201102801%2
#https://mapprod2.environment.nsw.gov.au/arcgis/rest/services/UHGC/UHGC/MapServer/1/query?objectIds=1&f=pjson&returnGeometry=false&&outFields=SA1_MAIN16,HVI&where=SA1_MAIN16='10201102801'
#https://mapprod2.environment.nsw.gov.au/arcgis/rest/services/UHGC/UHGC/MapServer/1/query?where=SA1_MAIN16+%3D+%2710201102801%27&text=&objectIds=1%2C2%2C3&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&distance=&units=esriSRUnit_Foot&relationParam=&outFields=SA1_MAIN16+%2C+HVI+&returnGeometry=false&returnTrueCurves=false&maxAllowableOffset=&geometryPrecision=&outSR=&havingClause=&returnIdsOnly=false&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&historicMoment=&returnDistinctValues=false&resultOffset=&resultRecordCount=&returnExtentOnly=false&datumTransformation=&parameterValues=&rangeValues=&quantizationParameters=&featureEncoding=esriDefault&f=html


service_urls <-
  list(heat_vulnerability_index = 'https://mapprod2.environment.nsw.gov.au/arcgis/rest/services/UHGC/UHGC/MapServer/1/query?')

resp <-
  httr2::request(service_urls$heat_vulnerability_index) %>%
  httr2::req_url_query(f='pjson',
                       returnGeometry='false',
                       outFields="*",
                       where="SA1_MAIN16='10201102801'") %>%
  req_perform()

resp %>% resp_raw()
resp %>% resp_status()
resp %>% resp_status_desc()

resp_list <-
  resp %>%
  resp_body_json(check_type = FALSE)

resp_list$features[[1]]$attributes$HVI
