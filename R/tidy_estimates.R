#' Title
#'
#' @param model The output of an `mgcv::gam()` model
#' @param dataframe `sf` dataframe to which the output will be attached
#'
#' @return `sf` dataframe with the smooth and fixed outputs of the model as the initial columns
#' @export
#'
#' @examples
tidy_estimates <- function(model,dataframe){

  # Identify numeric columns
  numeric_columns <- sapply(dataframe, is.numeric)

  # Replace numeric columns with the number 1
  tempdf <- dataframe
  tempdf[, numeric_columns] <- 1

  output <- predict(model, tempdf, type = "terms", se.fit = TRUE) |>
    as.data.frame()

  ### if only one smooth:
  if(nrow(summary(model$smooth)) == 1) {
    # change names from fit. to the type of effect (random effect or mrf.smooth)
    names(output)[1] <- paste0(summary(model$smooth)[,2],".")
    # same for standard error columns
    names(output)[2] <- paste0("se.",summary(model$smooth)[,2],".")
  }

  else {
    ### if more than one smooth:

    # change names from fit. to the type of effect (random effect or mrf.smooth)
    names(output)[stringr::str_starts(names(output),"fit.s.")] <- stringr::str_replace(names(output)[stringr::str_starts(names(output),"fit.s.")],
                                                                                       "fit.s.",
                                                                                       paste0(summary(model$smooth)[,2],"."))
    # same for standard error columns
    names(output)[stringr::str_starts(names(output),"se.fit.s.")] <- stringr::str_replace(names(output)[stringr::str_starts(names(output),"se.fit.s.")],
                                                                                          "se.fit.s.",
                                                                                          paste0("se.",summary(model$smooth)[,2],"."))
  }

  # remove the . at the end of each matching string
  names(output) <- stringr::str_remove_all(names(output), "\\.$")

  # swap around and put a | in the mrf smooths
  names(output) <- stringr::str_replace_all(names(output), "\\.{2}", "|")

  output <- output |>
    cbind(dataframe) |>
    as.data.frame() |>
    dplyr::select(-matches("fit\\.")) |>
    sf::st_as_sf()

  return(output)

}
