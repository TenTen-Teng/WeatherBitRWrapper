# constant.R unit tests
library(withr)

test_that(
  "test constant variables", {
    expect_equal(base_url, "https://api.weatherbit.io/v2.0/")
    expect_type(api_key(), "character")
    expect_type(valid_langs, "character")
    expect_in("en", valid_langs)
    expect_type(vaild_units, "character")
    expect_in("M", vaild_units)
  }
)

test_that("mock environment variable API key", {
  with_envvar(c(WEATHERBIT_API_KEY = "abcde"), {
    expect_equal(api_key(), "abcde")
  })
  with_envvar(c(WEATHERBIT_API_KEY = ""), {
    expect_equal(api_key(), "")
  })
}
)

with_envvar(
  c(WEATHERBIT_API_KEY = "abcde"),{
  print(Sys.getenv("WEATHERBIT_API_KEY"))
})
