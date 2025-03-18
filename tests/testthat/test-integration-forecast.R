# Integration test for forecast R

# Test get_forecast_by_city
test_that(
    "test get_forecast_by_city", {
        skip_on_cran()
        df <- get_forecast_by_city("Raleigh,NC")

        expect_s3_class(df, "data.frame")
        expect_equal(df$city_name[1], "Raleigh")
    }
)

# Test get_forecast_by_lat_lon
test_that(
    "test get_forecast_by_lat_lon", {
        skip_on_cran()
        df <- get_forecast_by_lat_lon(lat=38.123, lon=-78.543)

        expect_s3_class(df, "data.frame")
        expect_equal(df$city_name[1], "Free Union")
    }
)

# Test get_forecast_by_postal_code
test_that(
    "test get_forecast_by_postal_code", {
        skip_on_cran()
        df <- get_forecast_by_postal_code(postal_code=22202, country='US')

        expect_s3_class(df, "data.frame")
        expect_equal(df$city_name[1], "Arlington")
    }
)

# Test get_forecast_by_city_id
test_that(
    "test get_forecast_by_city_id", {
        skip_on_cran()
        df <- get_forecast_by_city_id(city_id = 8953360)

        expect_s3_class(df, "data.frame")
        expect_equal(df$city_name[1], "Comugne")
    }
)

