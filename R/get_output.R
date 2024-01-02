#' Title
#'
#' @param model The output of an `mgcv::gam()` model
#' @param dataframe `sf` dataframe to which the output will be attached
#'
#' @return `sf` dataframe with the smooth and fixed outputs of the model as the initial columns
#' @export
#'
#' @examples
get_output <- function(model,dataframe){

  tempdf <-dataframe |>
    mutate(across(where(is.numeric), ~replace_na(., 1)))

  output <- predict(model, dataframe, type = "terms", se.fit = TRUE) |>
    as.data.frame()

  names(output)[stringr::str_starts(names(output),"fit.s.")] <- stringr::str_replace(names(output)[stringr::str_starts(names(output),"fit.s.")],
                                                                   "fit.s.",
                                                                   paste0(summary(model$smooth)[,2],"."))

  names(output)[stringr::str_starts(names(output),"se.fit.s.")] <- stringr::str_replace(names(output)[stringr::str_starts(names(output),"se.fit.s.")],
                                                                      "se.fit.s.",
                                                                      paste0("se.",summary(model$smooth)[,2],"."))

  # remove the . at the end of each matching string
  names(output) <- stringr::str_remove_all(names(output), "\\.$")

  # remove the .. at the end of each matching string
  names(output) <- stringr::str_replace_all(names(output), "\\.{2}", "|")

  output <- output |>
    cbind(dataframe) |>
    as.data.frame() |>
    dplyr::select(-matches("fit\\.")) |>
    sf::st_as_sf()

  return(output)


  # tempdf <- dataframe |>
  #   mutate_if(is.numeric, funs(replace(., TRUE, 1)))
  #
  # output <- predict(model, tempdf, type = "terms", se.fit = TRUE) |>
  #   as.data.frame()
  #
  # names(output) <- stringr::str_replace_all(names(output),
  #                                  "^fit.s.",
  #                                  "smooth_")
  # names(output) <- stringr::str_replace_all(names(output),
  #                                  "^se.fit.s.",
  #                                  "smoothse_")
  # names(output) <- stringr::str_replace_all(names(output),
  #                                  "^fit.",
  #                                  "fixed_")
  # names(output) <- stringr::str_replace_all(names(output),
  #                                  "^se.fit.",
  #                                  "fixedse_")
  # # Define a pattern to match strings starting with "smooth" and ending with .
  # pattern <- "(smooth[^,]*)\\."
  #
  # # remove the . at the end of each matching string
  # names(output) <- stringr::str_replace_all(names(output), pattern, "\\1")
  #
  # output <- output |>
  #   dplyr::select(starts_with("smooth_"),starts_with("fixed_"),starts_with("smoothse_"),starts_with("fixedse_"),everything()) |>
  #   cbind(dataframe) |>
  #   as.data.frame() |>
  #   sf::st_as_sf()
  #
  # return(output)
}
