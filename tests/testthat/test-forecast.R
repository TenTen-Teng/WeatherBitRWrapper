# forecast.R unit tests.
library(mockery)
library(httr)
library(httr2)
library(httptest)
library(jsonlite)

test_that(
  "test constant variables", {
    expect_equal(endpoint, "forecast/daily")
    expect_equal(endpoint_name, "forecast")
    expect_equal(forecast_url, "https://api.weatherbit.io/v2.0/forecast/daily")
  }
)

test_that("get_forecast_by_city() handle inputs", {
  # Mock a valid API response
  mock_response <- fake_response(
    "https://mock-api.com/forecast",
    verb = "GET",
    status_code = 200,
    headers = list(),
  content = '
    [
      {
        "city_name": "Raleigh",
        "data.datetime": "2024-03-15",
        "data.temp": 25,
        "data.humidity": 60
      }
  ]'
  )
  class(mock_response) <- "response"

  # Mock both `connect_api_key` and `GET`
  stub(get_forecast_by_city, "connect_api_key", function() FALSE)
  stub(get_forecast_by_city, "GET", function(url, query = list()) mock_response)

  expect_error(get_forecast_by_city("Raleigh,NC"))
  expect_error(get_forecast_by_city("Raleigh,NC", language = 'abc'))
  expect_error(get_forecast_by_city("Raleigh,NC", unit = 'abc'))
  expect_error(get_forecast_by_city("Raleigh,NC", day = 20))
  expect_error(get_forecast_by_city("Raleigh,NC", day = -1))
  expect_error(get_forecast_by_city("Raleigh,NC", day = 'abc'))
}
)

test_that("get_forecast_by_city() correctly handles API response", {
  # Mock a valid API response
  mock_response <- fake_response(
    "https://mock-api.com/forecast",
    verb = "GET",
    status_code = 200,
    headers = list(),
  content = '
    [
      {
        "city_name": "Raleigh",
        "data.datetime": "2024-03-15",
        "data.temp": 25,
        "data.humidity": 60
      }
  ]'
  )
  class(mock_response) <- "response"

  # Mock both `connect_api_key` and `GET`
  stub(get_forecast_by_city, "connect_api_key", function() TRUE)
  stub(get_forecast_by_city, "GET", function(url, query = list()) mock_response)

  result <- get_forecast_by_city("Raleigh,NC")

  expect_s3_class(result, "data.frame")
  expect_equal(result$city_name[1], "Raleigh")
  expect_equal(result$data.datetime[1], "2024-03-15")
  expect_equal(result$data.temp[1], 25)
}
)

test_that("get_forecast_by_city() handle bad response", {
  # Mock a valid API response
  mock_response <- fake_response(
    "https://mock-api.com/forecast",
    verb = "GET",
    status_code = 404,
    headers = list(),
  content = '
    [
      {
        "city_name": "Raleigh",
        "data.datetime": "2024-03-15",
        "data.temp": 25,
        "data.humidity": 60
        "error": "error message"
      }
  ]'
  )
  class(mock_response) <- "response"

  # Mock both `connect_api_key` and `GET`
  stub(get_forecast_by_city, "connect_api_key", function() TRUE)
  stub(get_forecast_by_city, "GET", function(url, query = list()) mock_response)

  expect_error(get_forecast_by_city("Raleigh,NC"))
}
)

