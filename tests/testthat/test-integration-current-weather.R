# Integration test for current weather

# Test get_current_temperature
test_that(
    "test get_current_temperature", {
        skip_on_cran()
        df <- get_current_temperature("Vancouver")

        expect_s3_class(df, "data.frame")
        expect_equal(df$city[1], "Vancouver")
    }
)

# Test get_current_wind
test_that(
    "test get_current_wind", {
        skip_on_cran()
        df <- get_current_wind("Vancouver")

        expect_s3_class(df, "data.frame")
        expect_equal(df$city[1], "Vancouver")
    }
)

# Test get_current_precipitation
test_that(
    "test get_current_precipitation", {
        skip_on_cran()
        df <- get_current_precipitation("Vancouver")

        expect_s3_class(df, "data.frame")
        expect_equal(df$city[1], "Vancouver")
    }
)