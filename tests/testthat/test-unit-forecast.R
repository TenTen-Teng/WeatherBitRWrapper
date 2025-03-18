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

# Test get_forecast_by_city()
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
  expect_error(get_forecast_by_city("Raleigh,NC", language = 123))
  expect_error(get_forecast_by_city("Raleigh,NC", unit = 'abc'))
  expect_error(get_forecast_by_city("Raleigh,NC", unit = 123))
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



# Test get_forecast_by_lat_lon()
test_that("get_forecast_by_lat_lon() handle inputs", {
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
  stub(get_forecast_by_lat_lon, "connect_api_key", function() FALSE)
  stub(get_forecast_by_lat_lon, "GET", function(url, query = list()) mock_response)

  expect_error(get_forecast_by_lat_lon(lat=38.123, lon=-78.543))
  expect_error(get_forecast_by_lat_lon(lat=38.123, lon=-78.543, language = 'abc'))
  expect_error(get_forecast_by_lat_lon(lat=38.123, lon=-78.543, unit = 'abc'))
  expect_error(get_forecast_by_lat_lon(lat=38.123, lon=-78.543, day = 20))
  expect_error(get_forecast_by_lat_lon(lat=38.123, lon=-78.543, day = -1))
  expect_error(get_forecast_by_lat_lon(lat=38.123, lon=-78.543, day = 'abc'))
}
)

test_that("get_forecast_by_lat_lon() correctly handles API response", {
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
  stub(get_forecast_by_lat_lon, "connect_api_key", function() TRUE)
  stub(get_forecast_by_lat_lon, "GET", function(url, query = list()) mock_response)

  result <- get_forecast_by_lat_lon(lat=38.123, lon=-78.543)

  expect_s3_class(result, "data.frame")
  expect_equal(result$city_name[1], "Raleigh")
  expect_equal(result$data.datetime[1], "2024-03-15")
  expect_equal(result$data.temp[1], 25)
}
)

test_that("get_forecast_by_lat_lon() handle bad response", {
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
  stub(get_forecast_by_lat_lon, "connect_api_key", function() TRUE)
  stub(get_forecast_by_lat_lon, "GET", function(url, query = list()) mock_response)

  expect_error(get_forecast_by_lat_lon(lat=38.123, lon=-78.543))
}
)



# Test get_forecast_by_postal_code
test_that("get_forecast_by_postal_code() handle inputs", {
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
  stub(get_forecast_by_postal_code, "connect_api_key", function() FALSE)
  stub(get_forecast_by_postal_code, "GET", function(url, query = list()) mock_response)

  expect_error(get_forecast_by_postal_code(postal_code=27601, country='US'))
  expect_error(get_forecast_by_postal_code(postal_code=27601, country='US', language = 'abc'))
  expect_error(get_forecast_by_postal_code(lpostal_code=27601, country='US', unit = 'abc'))
  expect_error(get_forecast_by_postal_code(postal_code=27601, country='US', day = 20))
  expect_error(get_forecast_by_postal_code(postal_code=27601, country='US', day = -1))
  expect_error(get_forecast_by_postal_code(postal_code=27601, country='US', day = 'abc'))
}
)

test_that("get_forecast_by_postal_code() correctly handles API response", {
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
  stub(get_forecast_by_postal_code, "connect_api_key", function() TRUE)
  stub(get_forecast_by_postal_code, "GET", function(url, query = list()) mock_response)

  result <- get_forecast_by_postal_code(postal_code=27601, country='US')

  expect_s3_class(result, "data.frame")
  expect_equal(result$city_name[1], "Raleigh")
  expect_equal(result$data.datetime[1], "2024-03-15")
  expect_equal(result$data.temp[1], 25)
}
)

test_that("get_forecast_by_postal_code() handle bad response", {
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
  stub(get_forecast_by_postal_code, "connect_api_key", function() TRUE)
  stub(get_forecast_by_postal_code, "GET", function(url, query = list()) mock_response)

  expect_error(get_forecast_by_postal_code(postal_code=27601, country='US'))
}
)



# Test get_forecast_by_city_id
test_that("get_forecast_by_city_id() handle inputs", {
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
  stub(get_forecast_by_city_id, "connect_api_key", function() FALSE)
  stub(get_forecast_by_city_id, "GET", function(url, query = list()) mock_response)

  expect_error(get_forecast_by_city_id(city_id = 8953360))
  expect_error(get_forecast_by_city_id(city_id = 8953360, language = 'abc'))
  expect_error(get_forecast_by_city_id(city_id = 8953360, unit = 'abc'))
  expect_error(get_forecast_by_city_id(city_id = 8953360, day = 20))
  expect_error(get_forecast_by_city_id(city_id = 8953360, day = -1))
  expect_error(get_forecast_by_city_id(city_id = 8953360, day = 'abc'))
}
)

test_that("get_forecast_by_postal_code() correctly handles API response", {
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
  stub(get_forecast_by_city_id, "connect_api_key", function() TRUE)
  stub(get_forecast_by_city_id, "GET", function(url, query = list()) mock_response)

  result <- get_forecast_by_city_id(city_id = 8953360)

  expect_s3_class(result, "data.frame")
  expect_equal(result$city_name[1], "Raleigh")
  expect_equal(result$data.datetime[1], "2024-03-15")
  expect_equal(result$data.temp[1], 25)
}
)

test_that("get_forecast_by_city_id() handle bad response", {
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
  stub(get_forecast_by_city_id, "connect_api_key", function() TRUE)
  stub(get_forecast_by_city_id, "GET", function(url, query = list()) mock_response)

  expect_error(get_forecast_by_city_id(city_id = 8953360))
}
)
