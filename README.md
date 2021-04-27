
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

A flatten and minified GNAF address dataset `?gnaf`

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

## Shiny

Shiny apps for exploration and other purposes

``` r
run_gnaf_leaflet_shiny()
```
