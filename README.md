
<!-- README.md is generated from README.Rmd. Please edit that file -->

# futureScenario

<!-- badges: start -->
<!-- badges: end -->

The goal of futureScenario is to …

## to do

1.  Obtain and create useable GNAF data - **done**
2.  Incorporate Graemes prediction workflow  
3.  Generate reporting outputs  
4.  Generate shiny apps

## Installation

<!--
You can install the released version of futureScenario from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("futureScenario")
```
-->

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Shaunson26/futureScenario")
```

``` r
library(futureScenario)
```

## Data

A flattened and minified GNAF address dataset `?gnaf`

``` r
head(gnaf)
#> # A tibble: 6 x 7
#>   NUMBER_FIRST STREET_NAME      LOCALITY_NAME POSTCODE LONGITUDE LATITUDE MB_2016_CODE
#>          <dbl> <chr>            <chr>            <dbl>     <dbl>    <dbl>        <dbl>
#> 1            1 ABERCROMBIE LANE SYDNEY            2000      151.    -33.9  10742401000
#> 2         5010 ABERCROMBIE LANE SYDNEY            2000      151.    -33.9  10743110000
#> 3            3 AGAR STEPS       MILLERS POINT     2000      151.    -33.9  11205344000
#> 4            5 AGAR STEPS       MILLERS POINT     2000      151.    -33.9  11205344000
#> 5            7 AGAR STEPS       MILLERS POINT     2000      151.    -33.9  11205344000
#> 6            9 AGAR STEPS       MILLERS POINT     2000      151.    -33.9  11205344000
```

## Functions

`return_address_coords()` is used to query `gnaf`. Currently with exact
matches only. If any query files are missing, there will be a wildcard
used for those fields

``` r
# An exact match
return_address_coords(street_number = 2, street_name = 'IVY STREET', locality = 'DARLINGTON', postcode = '2008')
#> # A tibble: 1 x 7
#>   NUMBER_FIRST STREET_NAME LOCALITY_NAME POSTCODE LONGITUDE LATITUDE MB_2016_CODE
#>          <dbl> <chr>       <chr>            <dbl>     <dbl>    <dbl>        <dbl>
#> 1            2 IVY STREET  DARLINGTON        2008      151.    -33.9  10755400000

# missing street_name returns all street_names matching the rest of the query
return_address_coords(street_number = 2, locality = 'DARLINGTON', postcode = '2008')
#> # A tibble: 8 x 7
#>   NUMBER_FIRST STREET_NAME         LOCALITY_NAME POSTCODE LONGITUDE LATITUDE MB_2016_CODE
#>          <dbl> <chr>               <chr>            <dbl>     <dbl>    <dbl>        <dbl>
#> 1            2 CALDER ROAD         DARLINGTON        2008      151.    -33.9  10755730000
#> 2            2 EDWARD STREET       DARLINGTON        2008      151.    -33.9  10756590000
#> 3            2 GOLDEN GROVE STREET DARLINGTON        2008      151.    -33.9  11205732600
#> 4            2 IVY LANE            DARLINGTON        2008      151.    -33.9  10755400000
#> 5            2 IVY STREET          DARLINGTON        2008      151.    -33.9  10755400000
#> 6            2 LANDER STREET       DARLINGTON        2008      151.    -33.9  10756580000
#> 7            2 SHEPHERD LANE       DARLINGTON        2008      151.    -33.9  10751380000
#> 8            2 THOMAS STREET       DARLINGTON        2008      151.    -33.9  10752920000
```

## API calls

### Heat vulnerability

Call to NSW data

``` r
hvi <-
  return_address_coords(street_number = 2, street_name = 'IVY STREET', locality = 'DARLINGTON', postcode = '2008') %>%
  join_sa1() %>%
  dplyr::pull(SA1_MAINCODE_2016) %>%
  get_heat_vulnerability_index() %>%  # JSON as a list
  map_heat_vulnerability_index()

hvi %>% 
  do.call(rbind.data.frame, .)
#>                               label value   value_text
#> HVI        Heat vulnerability index     3     moderate
#> Expos_Indx           Exposure index     2 low-moderate
#> Sensi_Indx        Sensitivity index     5         high
#> AdapC_Indx        Adaptive capacity     4 low-moderate
```

## Shiny

Shiny apps for exploration and other purposes

``` r
run_gnaf_leaflet_shiny()
```
