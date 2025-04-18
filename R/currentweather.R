sys.source("R/constant.R", envir = globalenv())
sys.source("R/utils.R", envir = globalenv())

# Define the API endpoint
base_url <- "https://api.weatherbit.io/v2.0/"
current_endpoint <- "current"
current_endpoint_name <- "current_weather"
current_weather_url <- paste(base_url, current_endpoint, sep = '')

#' Function to validate location input
#'
#' @param location Location input as a string
#' @param by Method to specify location ("city", "latlon", "postal")
#' @import dplyr httr jsonlite glue
validate_location <- function(location, by) {
  if (missing(location) || location == "") stop("Error: Location must be provided.")
  
  if (by == "latlon") {
    coords <- unlist(strsplit(location, ","))
    if (length(coords) != 2 || any(sapply(coords, function(x) is.na(as.numeric(x))))) {
      stop("Error: Invalid lat/lon format. Use 'latitude,longitude' with numeric values.")
    }
  } else if (!(by %in% c("city", "postal"))) {
    stop("Error: Invalid 'by' parameter. Use 'city', 'latlon', or 'postal'.")
  }
}

#' Function to process API response
#'
#' @param response API response object
#' @return Parsed JSON response as a data frame
#' @import dplyr httr jsonlite glue
process_api_response <- function(response) {
  content_data <- content(response, as = "text", encoding = "UTF-8")
  json_data <- fromJSON(content_data, flatten = TRUE)
  
  if (!"data" %in% names(json_data) || length(json_data$data) == 0) {
    stop("Error: No data returned. Check location or API key.")
  }
  
  return(json_data$data)
}

#' Function to get current temperature
#'
#' @param location Location input (city, lat/lon, or postal code)
#' @param by Method to specify location ("city", "latlon", "postal")
#' @param save_dir Optional directory to save result
#' @return A tibble with temperature data
#' @import dplyr httr jsonlite glue
get_current_temperature <- function(location, by = "city", save_dir = "") {
  if (!connect_api_key()) stop("Error: API key is missing. Set up your WeatherBit API key.")
  validate_location(location, by)
  
  params <- list(key = api_key())
  if (by == "city") {
    params$city <- location
  } else if (by == "latlon") {
    coords <- unlist(strsplit(location, ","))
    params$lat <- coords[1]
    params$lon <- coords[2]
  } else if (by == "postal") {
    params$postal_code <- location
  }
  
  response <- GET(current_weather_url, query = params)
  data <- process_api_response(response)
  
  result <- tibble(
    city = data$city_name,
    country = data$country_code,
    temperature_C = data$temp,
    feels_like_C = data$app_temp,
    dew_point_C = data$dewpt
  )
  
  if (save_dir != "") {
    save_csv(result, save_dir, endpoint = current_endpoint_name, params = c(location))
  }
  
  return(result)
}

#' Function to get current wind
#'
#' @param location Location input (city, lat/lon, or postal code)
#' @param by Method to specify location ("city", "latlon", "postal")
#' @param save_dir Optional directory to save result
#' @return A tibble with wind data
#' @import dplyr httr jsonlite glue
get_current_wind <- function(location, by = "city", save_dir = "") {
  if (!connect_api_key()) stop("Error: API key is missing. Set up your WeatherBit API key.")
  validate_location(location, by)
  
  params <- list(key = api_key())
  if (by == "city") {
    params$city <- location
  } else if (by == "latlon") {
    coords <- unlist(strsplit(location, ","))
    params$lat <- coords[1]
    params$lon <- coords[2]
  } else if (by == "postal") {
    params$postal_code <- location
  }
  
  response <- GET(current_weather_url, query = params)
  data <- process_api_response(response)
  
  result <- tibble(
    city = data$city_name,
    country = data$country_code,
    wind_speed_mps = data$wind_spd,
    wind_direction = data$wind_cdir_full,
    wind_gusts_mps = ifelse(is.null(data$gust), NA, data$gust)
  )
  
  if (save_dir != "") {
    save_csv(result, save_dir, endpoint = current_endpoint_name, params = c(location))
  }
  
  return(result)
}

#' Function to get current precipitation
#'
#' @param location Location input (city, lat/lon, or postal code)
#' @param by Method to specify location ("city", "latlon", "postal")
#' @param save_dir Optional directory to save result
#' @return A tibble with precipitation data
#' @import dplyr httr jsonlite glue
get_current_precipitation <- function(location, by = "city", save_dir = "") {
  if (!connect_api_key()) stop("Error: API key is missing. Set up your WeatherBit API key.")
  validate_location(location, by)
  
  params <- list(key = api_key())
  if (by == "city") {
    params$city <- location
  } else if (by == "latlon") {
    coords <- unlist(strsplit(location, ","))
    params$lat <- coords[1]
    params$lon <- coords[2]
  } else if (by == "postal") {
    params$postal_code <- location
  }
  
  response <- GET(current_weather_url, query = params)
  data <- process_api_response(response)
  
  result <- tibble(
    city = data$city_name,
    country = data$country_code,
    precipitation_mm = ifelse(is.null(data$precip), 0, data$precip),
    humidity_percent = data$rh,
    cloud_coverage_percent = data$clouds
  )
  
  if (save_dir != "") {
    save_csv(result, save_dir, endpoint = current_endpoint_name, params = c(location))
  }
  
  return(result)
}