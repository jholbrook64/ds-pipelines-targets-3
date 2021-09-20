
library(targets)
# loading these into the script is different from putting them intot he tar_option_set argument
library(tarchetypes)
library(tibble)

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval", "urbnmapr", "rnaturalearth", "cowplot", "tarchetypes", "tibble"))

# Load functions needed by targets below
source("1_fetch/src/find_oldest_sites.R")
source("1_fetch/src/get_site_data.R")
source("3_visualize/src/map_sites.R")

# Configuration
states <- c('WI','MN','MI', 'IL')
parameter <- c('00060')

# Targets
list(
  # Identify oldest sites
  tar_target(oldest_active_sites, find_oldest_sites(states, parameter)),

  # TODO: PULL SITE DATA HERE
  # tar_target(wi_data, get_site_data(oldest_active_sites, states[1], parameter[1])),
  #
  # tar_target(mn_data, get_site_data(oldest_active_sites, states[2], parameter[1])),
  #
  # tar_target(mi_data, get_site_data(oldest_active_sites, states[3], parameter[1])),

  tar_map(
    values = tibble(state_abb = states),
    tar_target(data, get_site_data(oldest_active_sites, state_abb, parameter))
    # Insert step for tallying data here
    # Insert step for plotting data here
  ),

  # Map oldest sites
  tar_target(
    site_map_png,
    map_sites("3_visualize/out/site_map.png", oldest_active_sites),
    format = "file"
  )
)
