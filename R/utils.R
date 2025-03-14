# Helpful functions.

# Connect API key function.
connect_api_key <- function(){
  # Check API key.
  if (api_key() == ''){
      return (FALSE)
  } else {
    return (TRUE)
  }
}

#' Save a dataframe as CSV file
#'
#' @param dataframe A dataframe to save
#' @param dir The file path
#' @param endpoint Endpoint name
#' @param params A list of useful information include in the saved CSV file name.
#' @importFrom glue glue
save_csv <- function(dataframe, dir = '', endpoint = '', params = c()){
    if (dir == '') {
        warning("Empty directory. Use current directory instead.")
        dir <- './'
    }

    # Create directory.
    if (!file.exists(dir)){
      dir.create(dir)
    }

    # Generate file name.
    file_name <- ''
    if (length(params) != 0){
      if (endpoint == ''){
        file_name <- paste(
          glue_collapse(params, sep = "_"), sep = ''
        ) %>% glue('.csv')
      } else {
        file_name <- paste(
          glue({endpoint}), '_', glue_collapse(params, sep = "_"), sep = ''
        ) %>% glue('.csv')
      }
    } else if (endpoint == ''){
      file_name <- glue('dataframe.csv')
    } else{
        file_name <- glue({endpoint}, '_', 'dataframe.csv')
    }
    path <- paste(dir, file_name, sep='')

    # Save to csv file
    tryCatch(
        {
            write.csv(dataframe, file = path, row.names = FALSE)
            cat(glue("File {file_name} saved successfully into {path}.\n"))
        }, warning = function(w) {
            cat("Warning: ", conditionMessage(w), "\n")
        }, error = function(e) {
            cat("Error: ", conditionMessage(e), "\n")
        }
    )
}

