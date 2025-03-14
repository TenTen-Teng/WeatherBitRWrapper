# utils.R unit tests.
library(withr)
library(glue)

# Test connect_api_key function.
test_that("mock environment variable API key and test connect_api_key function", {
  with_envvar(c(WEATHERBIT_API_KEY = "abcde"), {
    expect_equal(connect_api_key(), TRUE)
  })
  with_envvar(c(WEATHERBIT_API_KEY = ""), {
    expect_equal(connect_api_key(), FALSE)
  })
}
  )

# Test save_csv function.
mock_df <- data.frame(
  a = c(1, 2, 3),
  b = c("aa", "bb", "cc")
)

test_that("test save a dataframe as a csv file", {
  # Temporary file path
  temp_file <- tempfile(fileext = ".csv")

  # Run the function that generates the file
  save_csv(mock_df, temp_file)

  # Check if the file exists
  expect_true(file.exists(temp_file))

  # Clean up
  unlink(temp_file)

  # Without directory and endpoint.
  save_csv(mock_df)
  expect_true(file.exists('./dataframe.csv'))
  file.remove('./dataframe.csv')

  # Without directory, but with endpoint.
  save_csv(mock_df, endpoint = 'abc')
  expect_true(file.exists('./abc_dataframe.csv'))
  file.remove('./abc_dataframe.csv')

  # With params
  save_csv(mock_df, params = c('abc', '123'))
  expect_true(file.exists('./abc_123.csv'))
  file.remove('./abc_123.csv')
}
          )
