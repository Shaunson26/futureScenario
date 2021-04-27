library(devtools)

# Package stuff
document()
load_all()
#install()

# Testing stuff
?gnaf
head(gnaf)

?run_gnaf_leaflet_shiny
run_gnaf_leaflet_shiny()

# Recorded steps ----

use_mit_license()

use_readme_rmd()


use_r('gnaf-leaflet-example')

# Required packages
use_package('shiny')
use_package('tibble')
use_package('leaflet')
use_package('dplyr')
use_package('base')

# Add gnaf to package data
gnaf <- readRDS('gnaf_min.rds')
use_r('gnaf')





