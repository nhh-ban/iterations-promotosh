transform_metadata_to_df <- function(stations_metadata) {
  library(dplyr)
  library(purrr)
  library(lubridate)
  
  # Assuming stations_metadata is the main list containing the nested lists
  traffic_points <- stations_metadata$trafficRegistrationPoints
  
  # Use map_df to iterate and create a dataframe
  df <- map_df(traffic_points, function(point) {
    tibble(
      id = point$id,
      name = point$name,
      latestData = as_datetime(point$latestData$volumeByHour, tz = "UTC"),
      lat = point$location$coordinates$latLon$lat,
      lon = point$location$coordinates$latLon$lon
    )
  })

  return(df)
}


# task 4a
library(lubridate)
library(anytime)

to_iso8601 <- function(datetime, offset) {
  # Adjust the datetime by the offset (in days)
  adjusted_datetime <- datetime + days(offset)
  
  # Convert to ISO8601 format and append 'Z' to indicate UTC time zone
  iso8601_datetime <- format(adjusted_datetime, "%Y-%m-%dT%H:%M:%S") # Convert to ISO8601 without time zone
  iso8601_datetime <- paste0(iso8601_datetime, "Z") # Append 'Z' for UTC
  
  return(iso8601_datetime)
}

# task4c

transform_volumes <- function(json_response) {
  # Parse the JSON and extract the nested data
  volumes <- json_response$data$trafficData$volume$byHour$edges
  # Convert the list of volumes into a dataframe
  df <- purrr::map_df(volumes, function(edge) {
    tibble(
      from = edge$node$from,
      to = edge$node$to,
      volume = edge$node$total$volumeNumbers$volume
    )
  })
  return(df)
}

#task 4d
library(ggplot2)

plot_volume_data <- function(volume_df) {
  ggplot(volume_df, aes(x = from, y = volume)) +
    geom_line() +
    theme_minimal() +
    labs(title = "Traffic Volume", x = "Time", y = "Volume")
}



