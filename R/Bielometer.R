# Function to load packages
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
packages <- c("jsonlite", "leaflet", "osmdata", "sf")
load_packages(packages)

# Define the bounding box using latitude and longitude boundaries
bbox <- list(min_lon = 7.216667, min_lat = 47.116667, max_lon = 7.316667, max_lat = 47.183333)

# Create a leaflet map
leaflet() %>%
  addTiles() %>%
  fitBounds(lng1 = bbox$min_lon, lat1 = bbox$min_lat, lng2 = bbox$max_lon, lat2 = bbox$max_lat)




