# alerts.r unit test

# Load required libraries
library(mockery)
library(httr)
library(httr2)
library(httptest)
library(jsonlite)

# Test constant variables
#test_that("test constant variables", {
#    expect_equal(endpoint, "alerts")
#    expect_equal(endpoint_name, "alerts")
#    expect_equal(alerts_url, "https://api.weatherbit.io/v2.0/alerts")
#})

# Test weather_alert_lat() function
# Test input validation
test_that("weather_alert_lat() handles input validation", {
  # Mock connect_api_key to return TRUE
    stub(weather_alert_lat, "connect_api_key", function() TRUE)

    expect_error(weather_alert_lat(), "All parameters \\(lat, lon\\) are required.")
    expect_error(weather_alert_lat(lat = 49.88307), "All parameters \\(lat, lon\\) are required.")
    expect_error(weather_alert_lat(lon = -119.48568), "All parameters \\(lat, lon\\) are required.")
})

# Test handling of API responses
test_that("weather_alert_lat() correctly handles API response", {
  # Mock API response
  mock_response <- fake_response(
    "https://mock-api.com/alerts",
    verb = "GET",
    status_code = 200,
    headers = list(),
    content = '
    {
      "alerts": [
        {
          "description": "Severe snow storm in Kelowna, BC, Canada",
          "effective_local": "2025-03-23T23:23:00",
          "effective_utc": "2025-03-24T07:23:00",
          "ends_local": "2025-03-24T03:40:00",
          "ends_utc": "2025-03-24T11:40:00",
          "expires_local": "2025-03-24T16:40:00",
          "expires_utc": "2025-03-25T00:40:00",
          "onset_local": "2025-03-24T10:40:00",
          "onset_utc": "2025-03-24T18:40:00",
          "regions": ["Okanagan, BC"],
          "severity": "Watch",
          "title": "Snow Storm Watch issued",
          "uri": "https://api.weather.gov/alerts/"
        }
      ],
      "city_name": "Kelowna",
      "country_code": "CA",
      "lat": 49.88307,
      "lon": -119.48568,
      "state_code": "BC",
      "timezone": "America/Vancouver"
    }'
  )
  class(mock_response) <- "response"

  # Stub API calls
  stub(weather_alert_lat, "connect_api_key", function() TRUE)
  stub(weather_alert_lat, "GET", function(url, query = list()) mock_response)

  # Run function
  result <- weather_alert_lat(49.88307, -119.48568)

  # Expectations
  expect_s3_class(result, "data.frame")
  expect_equal(result$city_name[1], "Kelowna")
  expect_equal(result$state_code[1], "BC")
  expect_equal(result$country_code[1], "CA")
  expect_equal(result$title[1], "Snow Storm Watch issued")
  expect_equal(result$severity[1], "Watch")
  expect_equal(result$description[1], "Severe snow storm in Kelowna, BC, Canada")
  expect_equal(result$regions[1], "Okanagan, BC")
  expect_equal(result$effective_local[1], "2025-03-23T23:23:00")
  expect_equal(result$expires_local[1], "2025-03-24T16:40:00")
  expect_equal(result$uri[1], "https://api.weather.gov/alerts/")
})

# Test handling of API failures
test_that("weather_alert_lat() handles API failures", {
  # Mock API error response
  mock_response <- fake_response(
    "https://mock-api.com/alerts",
    verb = "GET",
    status_code = 404,
    headers = list(),
    content = '
    {
      "error": "Not Found"
    }'
  )
  class(mock_response) <- "response"

  # Stub API calls
  stub(weather_alert_lat, "connect_api_key", function() TRUE)
  stub(weather_alert_lat, "GET", function(url, query = list()) mock_response)

  # Expect error
  expect_error(weather_alert_lat(49.88307, -119.48568), "Error: API request failed! \nStatus code: 404")
})

# Test handling of no alerts
test_that("weather_alert_lat() handles no active alerts", {
  # Mock API response with no alerts
  mock_response <- fake_response(
    "https://mock-api.com/alerts",
    verb = "GET",
    status_code = 200,
    headers = list(),
    content = '
    {
      "alerts": [],
      "city_name": "Kelowna",
      "country_code": "CA",
      "lat": 49.88307,
      "lon": -119.48568,
      "state_code": "BC",
      "timezone": "America/Vancouver"
    }'
  )
  class(mock_response) <- "response"

  # Stub API calls
  stub(weather_alert_lat, "connect_api_key", function() TRUE)
  stub(weather_alert_lat, "GET", function(url, query = list()) mock_response)

  # Run function
  result <- weather_alert_lat(49.88307, -119.48568)

  # Expectations
  expect_s3_class(result, "data.frame")
  expect_true(all(is.na(result$title)))  # Ensure alerts are NA
  expect_equal(result$city_name[1], "Kelowna")
  expect_equal(result$state_code[1], "BC")
  expect_equal(result$country_code[1], "CA")
})


# Test weather_alert_city() function
# Test input validation
test_that("weather_alert_city() handles input validation", {
  # Mock connect_api_key to return TRUE
  stub(weather_alert_city, "connect_api_key", function() TRUE)

  expect_error(weather_alert_city(), "Parameter 'city' is required.")
})

# Test handling of API responses
test_that("weather_alert_city() correctly handles API response", {
  # Mock API response
  mock_response <- fake_response(
    "https://mock-api.com/alerts",
    verb = "GET",
    status_code = 200,
    headers = list(),
    content = '
    {
      "alerts": [
        {
          "description": "Severe snow storm in Kelowna, BC, Canada",
          "effective_local": "2025-03-23T23:23:00",
          "effective_utc": "2025-03-24T07:23:00",
          "expires_local": "2025-03-24T16:40:00",
          "expires_utc": "2025-03-25T00:40:00",
          "regions": ["Okanagan, BC"],
          "severity": "Watch",
          "title": "Snow Storm Watch issued",
          "uri": "https://api.weather.gov/alerts/"
        }
      ],
      "city_name": "Kelowna",
      "state_code": "BC",
      "country_code": "CA",
      "lat": 49.88307,
      "lon": -119.48568,
      "timezone": "America/Vancouver"
    }'
  )
  class(mock_response) <- "response"

  # Stub API calls
  stub(weather_alert_city, "connect_api_key", function() TRUE)
  stub(weather_alert_city, "GET", function(url, query = list()) mock_response)

  # Run function
  result <- weather_alert_city(city = "Kelowna", state = "BC", country = "CA")

  # Expectations
  expect_s3_class(result, "data.frame")
  expect_equal(result$city_name[1], "Kelowna")
  expect_equal(result$state_code[1], "BC")
  expect_equal(result$country_code[1], "CA")
  expect_equal(result$title[1], "Snow Storm Watch issued")
  expect_equal(result$severity[1], "Watch")
  expect_equal(result$description[1], "Severe snow storm in Kelowna, BC, Canada")
  expect_equal(result$regions[1], "Okanagan, BC")
  expect_equal(result$effective_local[1], "2025-03-23T23:23:00")
  expect_equal(result$expires_local[1], "2025-03-24T16:40:00")
  expect_equal(result$uri[1], "https://api.weather.gov/alerts/")
})

# Test handling of API failures
test_that("weather_alert_city() handles API failures", {
  # Mock API error response
  mock_response <- fake_response(
    "https://mock-api.com/alerts",
    verb = "GET",
    status_code = 404,
    headers = list(),
    content = '
    {
      "error": "Not Found"
    }'
  )
  class(mock_response) <- "response"

  # Stub API calls
  stub(weather_alert_city, "connect_api_key", function() TRUE)
  stub(weather_alert_city, "GET", function(url, query = list()) mock_response)

  # Expect error
  expect_error(weather_alert_city(city = "Kelowna", state = "BC", country = "CA"), "Error: API request failed! \nStatus code: 404")
})

# Test handling of no alerts
test_that("weather_alert_city() handles no active alerts", {
  # Mock API response with no alerts
  mock_response <- fake_response(
    "https://mock-api.com/alerts",
    verb = "GET",
    status_code = 200,
    headers = list(),
    content = '
    {
      "alerts": [],
      "city_name": "Kelowna",
      "state_code": "BC",
      "country_code": "CA",
      "lat": 49.88307,
      "lon": -119.48568,
      "timezone": "America/Vancouver"
    }'
  )
  class(mock_response) <- "response"

  # Stub API calls
  stub(weather_alert_city, "connect_api_key", function() TRUE)
  stub(weather_alert_city, "GET", function(url, query = list()) mock_response)

  # Run function
  result <- weather_alert_city(city = "Kelowna", state = "BC", country = "CA")

  # Expectations
  expect_s3_class(result, "data.frame")
  expect_true(all(is.na(result$title)))  # Ensure alerts are NA
  expect_equal(result$city_name[1], "Kelowna")
  expect_equal(result$state_code[1], "BC")
  expect_equal(result$country_code[1], "CA")
})


# Test weather_alert_postal() function
# Test input validation
test_that("weather_alert_postal() handles input validation", {
  # Mock connect_api_key to return TRUE
  stub(weather_alert_postal, "connect_api_key", function() TRUE)

  expect_error(weather_alert_postal(), "Parameter 'postal_code' is required.")
})

# Test handling of API responses
test_that("weather_alert_postal() correctly handles API response", {
  # Mock API response
  mock_response <- fake_response(
    "https://mock-api.com/alerts",
    verb = "GET",
    status_code = 200,
    headers = list(),
    content = '
    {
      "alerts": [
        {
          "description": "Severe snow storm in Kelowna, BC, Canada",
          "effective_local": "2025-03-23T23:23:00",
          "effective_utc": "2025-03-24T07:23:00",
          "expires_local": "2025-03-24T16:40:00",
          "expires_utc": "2025-03-25T00:40:00",
          "regions": ["Okanagan, BC"],
          "severity": "Watch",
          "title": "Snow Storm Watch issued",
          "uri": "https://api.weather.gov/alerts/"
        }
      ],
      "city_name": "Kelowna",
      "state_code": "BC",
      "country_code": "CA",
      "lat": 49.88307,
      "lon": -119.48568,
      "timezone": "America/Vancouver"
    }'
  )
  class(mock_response) <- "response"

  # Stub API calls
  stub(weather_alert_postal, "connect_api_key", function() TRUE)
  stub(weather_alert_postal, "GET", function(url, query = list()) mock_response)

  # Run function
  result <- weather_alert_postal(postal_code = "V1V1V8", country = "CA")

  # Expectations
  expect_s3_class(result, "data.frame")
  expect_equal(result$city_name[1], "Kelowna")
  expect_equal(result$state_code[1], "BC")
  expect_equal(result$country_code[1], "CA")
  expect_equal(result$title[1], "Snow Storm Watch issued")
  expect_equal(result$severity[1], "Watch")
  expect_equal(result$description[1], "Severe snow storm in Kelowna, BC, Canada")
  expect_equal(result$regions[1], "Okanagan, BC")
  expect_equal(result$effective_local[1], "2025-03-23T23:23:00")
  expect_equal(result$expires_local[1], "2025-03-24T16:40:00")
  expect_equal(result$uri[1], "https://api.weather.gov/alerts/")
})

# Test handling of API failures
test_that("weather_alert_postal() handles API failures", {
  # Mock API error response
  mock_response <- fake_response(
    "https://mock-api.com/alerts",
    verb = "GET",
    status_code = 404,
    headers = list(),
    content = '
    {
      "error": "Not Found"
    }'
  )
  class(mock_response) <- "response"

  # Stub API calls
  stub(weather_alert_postal, "connect_api_key", function() TRUE)
  stub(weather_alert_postal, "GET", function(url, query = list()) mock_response)

  # Expect error
  expect_error(weather_alert_postal(postal_code = "V1V1V8", country = "CA"), "Error: API request failed! \nStatus code: 404")
})

# Test handling of no alerts
test_that("weather_alert_postal() handles no active alerts", {
  # Mock API response with no alerts
  mock_response <- fake_response(
    "https://mock-api.com/alerts",
    verb = "GET",
    status_code = 200,
    headers = list(),
    content = '
    {
      "alerts": [],
      "city_name": "Kelowna",
      "state_code": "BC",
      "country_code": "CA",
      "lat": 49.88307,
      "lon": -119.48568,
      "timezone": "America/Vancouver"
    }'
  )
  class(mock_response) <- "response"

  # Stub API calls
  stub(weather_alert_postal, "connect_api_key", function() TRUE)
  stub(weather_alert_postal, "GET", function(url, query = list()) mock_response)

  # Run function
  result <- weather_alert_postal(postal_code = "V1V1V8", country = "CA")

  # Expectations
  expect_s3_class(result, "data.frame")
  expect_true(all(is.na(result$title)))  # Ensure alerts are NA
  expect_equal(result$city_name[1], "Kelowna")
  expect_equal(result$state_code[1], "BC")
  expect_equal(result$country_code[1], "CA")
})


# Test weather_alert_id() function
# Test input validation
test_that("weather_alert_id() handles input validation", {
  # Mock connect_api_key to return TRUE
  stub(weather_alert_id, "connect_api_key", function() TRUE)

  expect_error(weather_alert_id(), "Parameter 'city_id' is required.")
})

# Test handling of API responses
test_that("weather_alert_id() correctly handles API response", {
  # Mock API response
  mock_response <- fake_response(
    "https://mock-api.com/alerts",
    verb = "GET",
    status_code = 200,
    headers = list(),
    content = '
    {
      "alerts": [
        {
          "description": "Severe snow storm in Kelowna, BC, Canada",
          "effective_local": "2025-03-23T23:23:00",
          "effective_utc": "2025-03-24T07:23:00",
          "expires_local": "2025-03-24T16:40:00",
          "expires_utc": "2025-03-25T00:40:00",
          "regions": ["Okanagan, BC"],
          "severity": "Watch",
          "title": "Snow Storm Watch issued",
          "uri": "https://api.weather.gov/alerts/"
        }
      ],
      "city_name": "Kelowna",
      "state_code": "BC",
      "country_code": "CA",
      "lat": 49.88307,
      "lon": -119.48568,
      "timezone": "America/Vancouver"
    }'
  )
  class(mock_response) <- "response"

  # Stub API calls
  stub(weather_alert_id, "connect_api_key", function() TRUE)
  stub(weather_alert_id, "GET", function(url, query = list()) mock_response)

  # Run function
  result <- weather_alert_id(city_id = 123456)

  # Expectations
  expect_s3_class(result, "data.frame")
  expect_equal(result$city_name[1], "Kelowna")
  expect_equal(result$state_code[1], "BC")
  expect_equal(result$country_code[1], "CA")
  expect_equal(result$title[1], "Snow Storm Watch issued")
  expect_equal(result$severity[1], "Watch")
  expect_equal(result$description[1], "Severe snow storm in Kelowna, BC, Canada")
  expect_equal(result$regions[1], "Okanagan, BC")
  expect_equal(result$effective_local[1], "2025-03-23T23:23:00")
  expect_equal(result$expires_local[1], "2025-03-24T16:40:00")
  expect_equal(result$uri[1], "https://api.weather.gov/alerts/")
})

# Test handling of API failures
test_that("weather_alert_id() handles API failures", {
  # Mock API error response
  mock_response <- fake_response(
    "https://mock-api.com/alerts",
    verb = "GET",
    status_code = 404,
    headers = list(),
    content = '
    {
      "error": "Not Found"
    }'
  )
  class(mock_response) <- "response"

  # Stub API calls
  stub(weather_alert_id, "connect_api_key", function() TRUE)
  stub(weather_alert_id, "GET", function(url, query = list()) mock_response)

  # Expect error
  expect_error(weather_alert_id(city_id = 123456), "Error: API request failed! \nStatus code: 404")
})

# Test handling of no alerts
test_that("weather_alert_id() handles no active alerts", {
  # Mock API response with no alerts
  mock_response <- fake_response(
    "https://mock-api.com/alerts",
    verb = "GET",
    status_code = 200,
    headers = list(),
    content = '
    {
      "alerts": [],
      "city_name": "Kelowna",
      "state_code": "BC",
      "country_code": "CA",
      "lat": 49.88307,
      "lon": -119.48568,
      "timezone": "America/Vancouver"
    }'
  )
  class(mock_response) <- "response"

  # Stub API calls
  stub(weather_alert_id, "connect_api_key", function() TRUE)
  stub(weather_alert_id, "GET", function(url, query = list()) mock_response)

  # Run function
  result <- weather_alert_id(city_id = 123456)

  # Expectations
  expect_s3_class(result, "data.frame")
  expect_true(all(is.na(result$title)))  # Ensure alerts are NA
  expect_equal(result$city_name[1], "Kelowna")
  expect_equal(result$state_code[1], "BC")
  expect_equal(result$country_code[1], "CA")
})

