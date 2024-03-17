library(tidyverse)
library(remotes)

remotes::install_github("SymbolixAU/gtfsway")
library(gtfsway)

url_VP <- "http://realtime.catabus.com/InfoPoint/GTFS-Realtime.ashx?&Type=VehiclePosition"
url_TU <- "http://realtime.catabus.com/InfoPoint/GTFS-Realtime.ashx?&Type=TripUpdate"

response_TU <- httr::GET(url_TU)

response_VP <- httr::GET(url_VP,
                      httr::accept_json(),
                      httr::add_headers('Authorization' = ''))

FeedMessage_TU <- gtfs_realtime(response_TU)

gtfs_tripUpdates(FeedMessage_TU) %>%
  bind_rows() %>%
  write.table(., "trip_updates.csv",
              append = TRUE,
              sep = ",",
              col.names = TRUE,
              row.names = FALSE,
              quote = FALSE)

gtfs_vehiclePosition(gtfs_realtime(response_VP, content = "FeedMessage")) %>%
  bind_rows() %>%
  write.table(., "vehicle_updates.csv",
              append = TRUE,
              sep = ",",
              col.names = TRUE,
              row.names = FALSE,
              quote = FALSE)
