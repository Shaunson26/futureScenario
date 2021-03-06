% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_netcdf_subset.R
\name{download_netcdf_subset}
\alias{download_netcdf_subset}
\title{Query CSIRO NetCDF Subset Service}
\usage{
download_netcdf_subset(
  variable,
  year_range,
  model,
  rcp,
  lat,
  lon,
  date_start,
  date_end,
  date_step = 1,
  method = "download.file"
)
}
\arguments{
\item{lat, }{number, latitude}

\item{lon}{number, longitude}

\item{date_start}{date}

\item{date_end}{date}

\item{date_step}{number, days between date_start and date_end to download}

\item{method}{character, use httr2 or download.file methods}
}
\value{
character, path to temporary file that is downloaded
}
\description{
Query CSIRO NetCDF Subset Service
}
