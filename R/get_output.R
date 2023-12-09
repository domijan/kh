get_output <- function(model,dataframe){

  tempdf <- dataframe |>
    mutate_if(is.numeric, funs(replace(., TRUE, 1)))

  output <- predict(model, tempdf, type = "terms", se.fit = TRUE) |>
    as.data.frame()

  names(output) <- str_replace_all(names(output),
                                   "^fit.s.",
                                   "smooth_")
  names(output) <- str_replace_all(names(output),
                                   "^se.fit.s.",
                                   "smoothse_")
  names(output) <- str_replace_all(names(output),
                                   "^fit.",
                                   "fixed_")
  names(output) <- str_replace_all(names(output),
                                   "^se.fit.",
                                   "fixedse_")
  # Define a pattern to match strings starting with "smooth" and ending with .
  pattern <- "(smooth[^,]*)\\."

  # remove the . at the end of each matching string
  names(output) <- str_replace_all(names(output), pattern, "\\1")

  output <- output |>
    select(starts_with("smooth_"),starts_with("fixed_"),starts_with("smoothse_"),starts_with("fixedse_"),everything()) |>
    cbind(dataframe) |>
    as.data.frame() |>
    st_as_sf()

  return(output)
}
