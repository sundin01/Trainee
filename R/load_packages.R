# Function definitions -------------------
#This function takes a set of packages and installs and loads them.
#There is no return, only a successful output notification.

load_packages <-  function(packages){
  # Install packages not yet installed
  installed_packages <- packages %in% rownames(installed.packages())
  if (any(installed_packages == FALSE)) {
    install.packages(packages[!installed_packages], repos = "http://cran.us.r-project.org")
  }
  invisible(lapply(packages, library, character.only = TRUE)) #load packages
  print("All packages installed and loaded. You are ready to go!")
}

packages <- c('influxdbclient', 'ggplot2', 'tidyverse', 'lubridate', 'dplyr', 'caret',
              'vip', 'parsnip', 'workflows', 'tune', 'dials', 'stringr', 'terra', 'stars',
              'sf', 'plyr', 'doParallel', 'foreach', 'terrainr', 'starsExtra', 'pdp',
              'recipes', 'tidyterra', 'shiny', 'xgboost', 'rnaturalearth', 'zoo',
              'moments', 'tibble', 'rsample', 'yardstick', 'cowplot', 'purrr', 'renv',
              'ranger','Boruta','devtools','sp','keras','tensorflow')

load_packages(packages)
