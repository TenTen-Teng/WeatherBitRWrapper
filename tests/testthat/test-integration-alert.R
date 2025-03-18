# Integration test for alert

# Test weather_alert_lat
test_that(
    "test weather_alert_lat", {
        skip_on_cran()
        df <- weather_alert_lat(lat=49.88307, lon=119.48568)

        expect_s3_class(df, "data.frame")
        expect_equal(df$city_name[1], "Heishantou")
    }
)

# Test weather_alert_city
test_that(
    "test weather_alert_city", {
        skip_on_cran()
        df <- weather_alert_city(city="Kelowna")

        expect_s3_class(df, "data.frame")
        expect_equal(df$city_name[1], "Kelowna")
    }
)

# Test weather_alert_postal
test_that(
    "test weather_alert_postal", {
        skip_on_cran()
        df <- weather_alert_postal(postal_code="V1V1V7", country="CA")

        expect_s3_class(df, "data.frame")
        expect_equal(df$city[1], "Kelowna")
    }
)

# Test weather_alert_id
test_that(
    "test weather_alert_id", {
        skip_on_cran()
        df <- weather_alert_id(city_id=8953360)

        expect_s3_class(df, "data.frame")
        expect_equal(df$city[1], "Comugne")
    }
)