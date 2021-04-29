
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
#>   NUMBER_FIRST       STREET_NAME LOCALITY_NAME POSTCODE LONGITUDE  LATITUDE
#> 1            1 BARANGAROO AVENUE    BARANGAROO     2000  151.2011 -33.86240
#> 2           15 BARANGAROO AVENUE    BARANGAROO     2000  151.2014 -33.86401
#> 3           17 BARANGAROO AVENUE    BARANGAROO     2000  151.2014 -33.86401
#> 4           19 BARANGAROO AVENUE    BARANGAROO     2000  151.2014 -33.86401
#> 5           21 BARANGAROO AVENUE    BARANGAROO     2000  151.2014 -33.86401
#> 6           23 BARANGAROO AVENUE    BARANGAROO     2000  151.2014 -33.86401
```

## Functions

`return_address_coords()` is used to query `gnaf`. Currently with exact
matches only. If any query files are missing, there will be a wildcard
used for that those fields

``` r
# An exact match
return_address_coords(street_number = 2, street_name = 'IVY STREET', locality = 'DARLINGTON', postcode = '2008')
#> # A tibble: 1 x 6
#>   NUMBER_FIRST STREET_NAME LOCALITY_NAME POSTCODE LONGITUDE LATITUDE
#>          <int> <chr>       <chr>            <int>     <dbl>    <dbl>
#> 1            2 IVY STREET  DARLINGTON        2008      151.    -33.9

# missing street_name returns all street_names matching the rest of the query
return_address_coords(street_number = 2, locality = 'DARLINGTON', postcode = '2008')
#> # A tibble: 8 x 6
#>   NUMBER_FIRST STREET_NAME         LOCALITY_NAME POSTCODE LONGITUDE LATITUDE
#>          <int> <chr>               <chr>            <int>     <dbl>    <dbl>
#> 1            2 CALDER ROAD         DARLINGTON        2008      151.    -33.9
#> 2            2 EDWARD STREET       DARLINGTON        2008      151.    -33.9
#> 3            2 GOLDEN GROVE STREET DARLINGTON        2008      151.    -33.9
#> 4            2 IVY LANE            DARLINGTON        2008      151.    -33.9
#> 5            2 IVY STREET          DARLINGTON        2008      151.    -33.9
#> 6            2 LANDER STREET       DARLINGTON        2008      151.    -33.9
#> 7            2 SHEPHERD LANE       DARLINGTON        2008      151.    -33.9
#> 8            2 THOMAS STREET       DARLINGTON        2008      151.    -33.9
```

## Shiny

Shiny apps for exploration and other purposes

``` r
run_gnaf_leaflet_shiny()
```
