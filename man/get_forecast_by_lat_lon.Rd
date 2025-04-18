% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/forecast.R
\name{get_forecast_by_lat_lon}
\alias{get_forecast_by_lat_lon}
\title{Get forecast by lat and lon.}
\usage{
get_forecast_by_lat_lon(
  lat,
  lon,
  save_dir = "",
  language = "en",
  unit = "M",
  day = 16
)
}
\arguments{
\item{lat}{Latitude}

\item{lon}{Longtitude}

\item{save_dir}{The file path to save result}

\item{language}{Language, default as English}

\item{unit}{Available units, default as Metric (Celsius, m/s, mm)}

\item{day}{Forecast days, default as 16}
}
\description{
Get forecast by lat and lon.
}
