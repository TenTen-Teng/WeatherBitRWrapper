# WeatherBitWrapper
![workflow](https://github.com/TenTen-Teng/WeatherBitRWrapper/actions/workflows/weatherbitrwrapper.yml/badge.svg)

- [WeatherBitWrapper](#weatherbitwrapper)
  - [Introduction](#introduction)
  - [Functions Overview](#functions-overview)
  - [Example Usage](#example-usage)
  - [Vignettes](#vignettes)
  - [Questions](#questions)
  - [Contributor](#contributor)

## Introduction
**WeatherBitWrapper** is an R package designed to retrieve weather data from the **WeatherBit API**. It provides easy access to **current weather**, **severe weather alerts**, and **7-day forecasts**, returning structured **data frames** for easy analysis in R.

## Functions Overview
This package includes the following core functions:

### 1. Current Weather Functions
- **`get_current_temperature(location, by = "city")`** – Retrieves the current temperature, feels-like temperature, and dew point.
- **`get_current_wind(location, by = "city")`** – Provides wind speed, direction, and gusts.
- **`get_current_precipitation(location, by = "city")`** – Fetches precipitation rate, humidity, and cloud coverage.

### 2. Severe Weather Alerts
- **`weather_alert_lat(lat, lon)`** – Get alerts using latitude and longitude.
- **`weather_alert_city(city, state = NULL, country = NULL)`** – Get alerts by city name.
- **`weather_alert_postal(postal_code, country = NULL)`** – Get alerts by postal code.
- **`weather_alert_id(city_id)`** – Get alerts using a city ID.

### 3. 7-Day Forecast
- **`get_forecast_by_city(city, day = 7)`** – Retrieves a forecast for a given city.
- **`get_forecast_by_lat_lon(lat, lon, day = 7)`** – Retrieves a forecast using latitude/longitude.
- **`get_forecast_by_postal_code(postal_code, country, day = 7)`** – Retrieves a forecast using postal code.
- **`get_forecast_by_city_id(city_id, day = 7)`** – Retrieves a forecast using a city ID.

## Example Usage  
Below are quick examples for fetching current weather data, severe weather alerts, and 7-day forecasts. For a full guide on using this package, please refer to the **vignette**.

#### Fetching Current Weather
```r
library(WeatherBitWrapper)

# Get current temperature for New York
get_current_temperature(location = "New York", by = "city")
```

#### Retrieving Severe Weather Alerts
```r
# Get severe weather alerts for Los Angeles
weather_alert_city(city = "Los Angeles", state = "CA", country = "US")
```

#### Getting a 7-Day Forecast
```r
# Get a 7-day weather forecast for postal code 10001
get_forecast_by_postal_code(postal_code = "10001", country = "US", day = 7)
```

## Vignettes
Please see our [vignette](./vignettes/Example.Rmd)

## Questions
1. Where to find a Weatherbit API key?
   Go to Weatherbit [API website](https://www.weatherbit.io/). Sign up and you will get your API key.

2. How to set up API key to R environment.
   1. Set API key in the environment by opening the `.Renviron` file in RStudio using `file.edit("~/.Renviron")`
   2. Add `WEATHERBIT_API_KEY=your_actual_api_key_here` and saving the file.
   
## Contributor
<!-- readme: contributors -start -->
<table>
	<tbody>
		<tr>
            <td align="center">
                <a href="https://github.com/TenTen-Teng">
                    <img src="https://avatars.githubusercontent.com/u/18547241?v=4" width="100;" alt="TenTen-Teng"/>
                    <br />
                    <sub><b>TenTen-Teng</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/yz031326">
                    <img src="https://avatars.githubusercontent.com/u/180347465?v=4" width="100;" alt="yz031326"/>
                    <br />
                    <sub><b>Yuzhu Han</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/Ieleniayu">
                    <img src="https://avatars.githubusercontent.com/u/113123777?v=4" width="100;" alt="Ieleniayu"/>
                    <br />
                    <sub><b>Ieleniayu</b></sub>
                </a>
            </td>
		</tr>
	<tbody>
</table>
<!-- readme: contributors -end -->
