# constant.R unit tests

test_that(
  "test constant variables", {
    expect_equal(base_url, "https://api.weatherbit.io/v2.0/")
    expect_is(api_key, "character")
    expect_is(valid_langs, "character")
    expect_in("en", valid_langs)
    expect_is(vaild_units, "character")
    expect_in("M", vaild_units)
  }
)
