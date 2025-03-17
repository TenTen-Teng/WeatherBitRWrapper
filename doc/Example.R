## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(dplyr)
library(magrittr) 
library(jsonlite)
library(httr)
library(glue)
library(knitr)
library(kableExtra)

## ----warning=FALSE------------------------------------------------------------
# Load the package
library(WeatherBitRWrapper)

## ----eval=FALSE---------------------------------------------------------------
# get_current_temperature(location, by = "city", save_dir = "")

## -----------------------------------------------------------------------------
# Fetch current temperature in Vancouver
df <- WeatherBitRWrapper::get_current_temperature("Vancouver")

kable(df) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "100px")

## ----eval=FALSE---------------------------------------------------------------
# get_current_wind(location, by = "city", save_dir = "")

## -----------------------------------------------------------------------------
# Fetch current wind data in Vancouver
df <- WeatherBitRWrapper::get_current_wind("Vancouver")

kable(df) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "100px")

## ----eval=FALSE---------------------------------------------------------------
# get_current_precipitation(location, by = "city", save_dir = "")

## -----------------------------------------------------------------------------
# Fetch current precipitation data in Vancouver
df <- WeatherBitRWrapper::get_current_precipitation("Vancouver")

kable(df) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "100px")

## ----eval=FALSE---------------------------------------------------------------
# weather_alert_lat <- (
#   lat, lon, save_dir = ''
#   )

## ----warning=FALSE, collapse = TRUE-------------------------------------------
# Fetch weather alerts at [49.88307, 119.48568]

df <- WeatherBitRWrapper::weather_alert_lat(lat=49.88307, lon=119.48568)

kable(df) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "100px")

## ----eval=FALSE---------------------------------------------------------------
# weather_alert_city <- (
#   city, state = NULL, country = NULL, save_dir = ''
#   )

## ----warning=FALSE, collapse = TRUE-------------------------------------------
# Fetch weather alerts in Kelowna

df <- WeatherBitRWrapper::weather_alert_city(city="Kelowna")

kable(df) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "100px")

## ----warning=FALSE, collapse = TRUE-------------------------------------------
# Fetch weather alerts in Kelowna, BC

df <- WeatherBitRWrapper::weather_alert_city(city="Kelowna", state="BC")

kable(df) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "100px")

## ----warning=FALSE, collapse = TRUE-------------------------------------------
# Fetch weather alerts in Kelowna, BC, Canada

df <- WeatherBitRWrapper::weather_alert_city(city="Kelowna", state="BC", country="CA")

kable(df) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "100px")

## ----eval=FALSE---------------------------------------------------------------
# weather_alert_postal <- (
#   postal_code, country = NULL, save_dir = ''
#   )

## ----warning=FALSE, collapse = TRUE-------------------------------------------
# Fetch weather alerts at V1V1V7

df <- WeatherBitRWrapper::weather_alert_postal(postal_code="V1V1V7")

kable(df) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "100px")

## ----warning=FALSE, collapse = TRUE-------------------------------------------
# Fetch weather alerts at V1V1V7, Canada

df <- WeatherBitRWrapper::weather_alert_postal(postal_code="V1V1V7", country="CA")

kable(df) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "100px")

## ----eval=FALSE---------------------------------------------------------------
# weather_alert_id <- (
#   city_id, save_dir = ''
#   )

## ----warning=FALSE, collapse = TRUE-------------------------------------------
# Fetch weather alerts at 8953360

df <- WeatherBitRWrapper::weather_alert_id(city_id=8953360)

kable(df) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "100px")

## ----eval=FALSE---------------------------------------------------------------
# get_forecast_by_city <- (
#   city, save_dir = '', language = 'en', unit = 'M', day = 16
#   )

## ----warning=FALSE, collapse = TRUE-------------------------------------------
# Fetch next 16 days weather in Raleigh, NC.

df <- WeatherBitRWrapper::get_forecast_by_city("Raleigh,NC")

kable(df[1:16, ]) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "300px")

## ----warning=FALSE, , fig.width=6, fig.height=4-------------------------------
library(ggplot2)

# Fetch forecast data in Raleigh,NC
weather_data <- WeatherBitRWrapper::get_forecast_by_city("Raleigh,NC", save_dir = './')

# Convert date format.
weather_data$data.datetime <- as.Date(weather_data$data.datetime)

# Create an area chart
ggplot(weather_data, aes(x = data.datetime)) +
  geom_ribbon(aes(ymin = data.app_min_temp, ymax = data.app_max_temp), fill = "skyblue", alpha = 0.5) +
  geom_line(aes(y = data.app_max_temp), color = "red", linewidth = 1) +   # High temp line
  geom_line(aes(y = data.app_min_temp), color = "blue", linewidth = 1) +   # Low temp line
  labs(title = "Raleigh,NC - Daily Temperature Range",
       x = "Date",
       y = "Temperature (°C)")

## ----warning=FALSE------------------------------------------------------------
# Fetch next 16 days weather in Raleigh, NC in French.

df <- WeatherBitRWrapper::get_forecast_by_city("Raleigh,NC", language = "fr")

kable(df[1:16, ]) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "300px")

## ----warning=FALSE------------------------------------------------------------
# Fetch next 16 days weather in Raleigh, NC with Fahrenheit.

df <- WeatherBitRWrapper::get_forecast_by_city("Raleigh,NC", unit = 'I')

kable(df[1:16, ]) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "300px")

## ----eval=FALSE---------------------------------------------------------------
# get_forecast_by_lat_lon <- (
#   lat, lon, save_dir = '', language = 'en', unit = 'M', day = 16
# )

## ----warning=FALSE------------------------------------------------------------
# Fetch next 16 days weather in [38.123, 78.543].

df <- WeatherBitRWrapper::get_forecast_by_lat_lon(lat=38.123, lon=-78.543)

kable(df[1:16, ]) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "300px")

## ----eval=FALSE---------------------------------------------------------------
# get_forecast_by_postal_code(
#   postal_code,  country, save_dir = "", language = "en", unit = "M", day = 16
#   )

## ----warning=FALSE------------------------------------------------------------
# Fetch next 16 days weather at 22202.

df <- WeatherBitRWrapper::get_forecast_by_postal_code(postal_code=22202, country='US')

kable(df[1:16, ]) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "300px")

## ----eval=FALSE---------------------------------------------------------------
# get_forecast_by_city_id (
#   city_id, save_dir = '', language = 'en', unit = 'M', day = 16
#   )

## ----warning=FALSE------------------------------------------------------------
# Fetch next 16 days weather at 8953360

df <- WeatherBitRWrapper::get_forecast_by_city_id(city_id = 8953360)

kable(df[1:16, ]) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE) %>%
  scroll_box(height = "300px")

