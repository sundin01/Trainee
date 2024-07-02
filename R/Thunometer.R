#-------------------------------------------------------------------------------
# Get all packages you need
#-------------------------------------------------------------------------------
load_packages <- function(packages) {
  # Install packages not yet installed
  installed_packages <- packages %in% rownames(installed.packages())
  if (any(installed_packages == FALSE)) {
    install.packages(packages[!installed_packages], repos = "http://cran.us.r-project.org")
  }
  invisible(lapply(packages, library, character.only = TRUE)) # Load packages
  print("All packages installed and loaded. You are ready to go!")
}

# List of packages to load
packages <- c("jsonlite", "leaflet", "osmdata", "sf", 'tidyverse','influxdbclient' )
load_packages(packages)

#-------------------------------------------------------------------------------
# Get the data from abilium
#-------------------------------------------------------------------------------

source('../Trainee/R/get_data.R')

#-------------------------------------------------------------------------------
# Make a map
#-------------------------------------------------------------------------------

# Define the bounding box using latitude and longitude boundaries
bbox <- list(min_lon = 7.583333, min_lat = 46.716667, max_lon = 7.65, max_lat = 46.766667)


leaflet() |>
  addTiles() |>
  fitBounds(lng1 = bbox$min_lon, lat1 = bbox$min_lat, lng2 = bbox$max_lon, lat2 = bbox$max_lat) |>
  addCircleMarkers(
    data = meta,
    ~OST_CHTOPO, ~NORD_CHTOPO,
    label = ~Log_NR,
    radius = 5,
    color = "green",
    fill = TRUE,
    fillOpacity = 0.7)
