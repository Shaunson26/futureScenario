#' Query CSIRO NetCDF Subset Service
#'
#' @param lat, number, latitude
#' @param lon number, longitude
#' @param bbox number, vector of length 4: left,bottom,right,top | min Longitude , min Latitude , max Longitude , max Latitude
#' @param date_start date
#' @param date_end date
#' @param date_step number, days between date_start and date_end to download
#' @param method character, use httr2 or download.file methods
#'
#' @return character, path to temporary file that is downloaded
#'
#' @export
download_netcdf_subset <- function(variable, year_range, model, rcp, bbox, lat, lon, date_start, date_end, date_step = 1, method = 'download.file'){

  # check inputs
  if (!missing(bbox) & any(!missing(lat), !missing(lon))){
    stop('only one of bbox or lat/lon can be given')
  }

  if (!missing(bbox)){
    if (length(bbox) != 4) {
      stop('bbox should be a number vector of length 4: left,bottom,right,top | min Longitude , min Latitude , max Longitude , max Latitude')
    }
  }

  # do stuff
  date_start <- format(as.Date(date_start), '%FT%TZ')
  date_end <- format(as.Date(date_end), '%FT%TZ')

  request_obj <-
    create_dataset_url(variable = variable,
                       model = model,
                       rcp = rcp,
                       year_range = year_range)

  var = sub('_.*', '', basename(request_obj$url))



  if (!missing(bbox)){
    coords <-
      list(
        north = bbox[4],
        west = bbox[1],
        east = bbox[3],
        south = bbox[2]
      )
  } else {
    coords <-
      list(
        north = lat + 0.0001,
        west = lon - 0.0001,
        east = lon + 0.0001,
        south = lat - 0.0001
      )
  }

  query <-
    c(
      list(var=var,
           #disableProjSubset='on',
           horizStride=1,
           time_start=date_start,
           time_end=date_end,
           timeStride=date_step,
           accept='netcdf4'),
      coords
    )

  request_obj <-
    request_obj %>%
    httr2::req_headers(Accept = "application/x-netcdf4") %>%
    httr2::req_url_query(!!!query)

  message('Quering API ...')

  filename <- basename(sub('\\?.*', '', request_obj$url))
  filename <- strsplit(filename, split = '_')[[1]][c(1,3,4,9)]
  filename <- paste(filename, collapse = '_')
  temp_file_path <- tempfile(fileext = paste0('_', filename))

  if (method == 'download.file'){

    download.file(request_obj$url, destfile = temp_file_path, mode = 'wb')

    return(temp_file_path)
  }

  if (method == 'httr2'){

    message(request_obj$url)

    resp <- httr2::req_perform(request_obj)

    if (resp$status_code == 200){

      message('  writing file')

      resp %>%
        httr2::resp_body_raw() %>%
        writeBin(con = temp_file_path)

      return(temp_file_path)

    } else {

      stop('Error in download: ', httr2::resp_status_desc(resp))
    }

  }

  if (method == 'test') {

    message(request_obj$url)

  } else {
    stop("method error")
  }

}

