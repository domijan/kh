#' Title
#'
#' @param output the `sf` dataframe output of `get_output()`
#'
#' @return a list containing quick maps of all smooths
#' @export
#'
#' @examples
quickmap_smooths <- function(output){
  output1 <- output |>
    dplyr::select(starts_with("random.effect"),starts_with("mrf.smooth"))

  fillnames <- output1 |>
    sf::st_drop_geometry() |>
    names()

  newtitle <- sub("^(.*?\\..*?)\\..*$", "\\1", fillnames)
  newsubtitle <- sub(".*\\.[^.]*\\.(.*)", "\\1", fillnames)


  plot_list <- list()
  for (i in 1:length(fillnames)){
    plot_list[[i]] <- ggplot2::ggplot() +
      ggplot2::geom_sf(data=output1, ggplot2::aes(fill=!!as.name(fillnames[i])), linewidth=0.05, colour="black") +
      ggplot2::scale_fill_gradient2() +
      ggplot2::labs(title=newtitle[i],
                    subtitle=newsubtitle[i]) +
      ggplot2::coord_sf(datum=NA) +
      ggplot2::theme_minimal() +
      ggplot2::theme_bw() +
      ggplot2::theme(plot.subtitle = ggplot2::element_text(size=8))


  #   output1 <- output |>
  #   dplyr::select(starts_with("smooth_"))
  #
  # fillnames <- output1 |>
  #   sf::st_drop_geometry() |>
  #   names()
  # plot_list <- list()
  # for (i in 1:length(fillnames)){
  #   plot_list[[i]] <- ggplot2::ggplot() +
  #     ggplot2::geom_sf(data=output1, ggplot2::aes(fill=!!as.name(fillnames[i])), linewidth=0.05, colour="black") +
  #     ggplot2::scale_fill_gradient2() +
  #     ggplot2::labs(title="smooth",
  #          subtitle=stringr::str_remove(fillnames[i],"smooth_")) +
  #     ggplot2::coord_sf(datum=NA) +
  #     ggplot2::theme_minimal() +
  #     ggplot2::theme_bw() +
  #     ggplot2::theme(plot.subtitle = ggplot2::element_text(size=8))

  }
  return(plot_list)
}
