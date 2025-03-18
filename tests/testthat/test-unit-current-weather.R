# test-current-weather.R - Unit tests for currentweather.R functions
library(testthat)
library(mockery)
library(httr)
library(httr2)
library(httptest)
library(jsonlite)

# Load currentweather.R to get function definitions
# sys.source("R/currentweather.R", envir = globalenv())

test_that("Test constant variables", {
  expect_equal(current_endpoint, "current")
  expect_equal(current_endpoint_name, "current_weather")
  expect_equal(current_weather_url, "https://api.weatherbit.io/v2.0/current")
})

# Test get_current_temperature()
test_that("get_current_temperature() handles inputs", {
  mock_response <- fake_response(
    "https://mock-api.com/current",
    verb = "GET",
    status_code = 200,
    headers = list(),
    content = '
      {
        "data": [
          {
            "city_name": "Vancouver",
            "temp": 18,
            "app_temp": 16,
            "dewpt": 12
          }
        ]
      }'
  )
  class(mock_response) <- "response"
  
  # Mock API key and GET request
  stub(get_current_temperature, "connect_api_key", function() FALSE)
  stub(get_current_temperature, "httr::GET", function(url, query = list()) mock_response)
  
  expect_error(get_current_temperature("Vancouver"))
  expect_error(get_current_temperature("Vancouver", by = "unknown"))
  expect_error(get_current_temperature("123,abc", by = "latlon"))
})

# test_that("get_current_temperature() correctly handles API response", {
#   mock_response <- fake_response(
#     "https://mock-api.com/current",
#     verb = "GET",
#     status_code = 200,
#     headers = list(),
#     content = '
#       [
#         {
#           "city_name": "Vancouver",
#           "temp": 18,
#           "app_temp": 16,
#           "dewpt": 12
#         }
#       ]'
#   )
#   class(mock_response) <- "response"
  
#   stub(get_current_temperature, "connect_api_key", function() TRUE)
#   stub(get_current_temperature, "GET", function(url, query = list()) mock_response)
  
#   result <- get_current_temperature("Vancouver")
  
#   expect_s3_class(result, "data.frame")
#   expect_equal(result$city[1], "Vancouver")
#   expect_equal(result$temperature_C[1], 18)
# })

test_that("get_current_temperature() handles bad API response", {
  mock_response <- fake_response(
    "https://mock-api.com/current",
    verb = "GET",
    status_code = 404,
    headers = list(),
    content = '{ "error": "Invalid location" }'
  )
  class(mock_response) <- "response"
  
  stub(get_current_temperature, "connect_api_key", function() TRUE)
  stub(get_current_temperature, "GET", function(url, query = list()) mock_response)
  
  expect_error(get_current_temperature("InvalidCity"))
})

# Test get_current_wind()
test_that("get_current_wind() handles inputs", {
  mock_response <- fake_response(
    "https://mock-api.com/current",
    verb = "GET",
    status_code = 200,
    headers = list(),
    content = '
      [
        {
          "city_name": "Vancouver",
          "wind_spd": 3.2,
          "wind_cdir_full": "Northwest",
          "gust": 5.0
        }
      ]'
  )
  class(mock_response) <- "response"
  
  stub(get_current_wind, "connect_api_key", function() FALSE)
  stub(get_current_wind, "GET", function(url, query = list()) mock_response)
  
  expect_error(get_current_wind("Vancouver"))
  expect_error(get_current_wind("Vancouver", by = "unknown"))
})

# test_that("get_current_wind() correctly handles API response", {
#   mock_response <- fake_response(
#     "https://mock-api.com/current",
#     verb = "GET",
#     status_code = 200,
#     headers = list(),
#     content = '
#       [
#         {
#           "city_name": "Vancouver",
#           "wind_spd": 3.2,
#           "wind_cdir_full": "Northwest",
#           "gust": 5.0
#         }
#       ]'
#   )
#   class(mock_response) <- "response"
  
#   stub(get_current_wind, "connect_api_key", function() TRUE)
#   stub(get_current_wind, "GET", function(url, query = list()) mock_response)
  
#   result <- get_current_wind("Vancouver")
  
#   expect_s3_class(result, "data.frame")
#   expect_equal(result$wind_speed_mps[1], 3.2)
#   expect_equal(result$wind_direction[1], "Northwest")
# })

test_that("get_current_wind() handles bad API response", {
  mock_response <- fake_response(
    "https://mock-api.com/current",
    verb = "GET",
    status_code = 404,
    headers = list(),
    content = '{ "data": [], "error": "Invalid location" }'
  )
  class(mock_response) <- "response"
  
  stub(get_current_wind, "connect_api_key", function() TRUE)
  stub(get_current_wind, "GET", function(url, query = list()) mock_response)
  
  expect_error(get_current_wind("InvalidCity"))
})