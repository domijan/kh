#' Title
#'
#' @param output the `sf` dataframe output of `get_output()`
#'
#' @return quick maps of all smooths
#' @export
#'
#' @examples
quickmap_smooths <- function(output){
  output1 <- output |>
    dplyr::select(starts_with("smooth_"))

  fillnames <- output1 |>
    sf::st_drop_geometry() |>
    names()
  plot_list <- list()
  for (i in 1:length(fillnames)){
    plot_list[[i]] <- ggplot2::ggplot(output1) +
      ggplot2::geom_sf(aes(fill=!!as.name(fillnames[i])), linewidth=0.05, colour="black") +
      ggplot2::scale_fill_gradient2() +
      ggplot2::labs(title="smooth",
           subtitle=stringr::str_remove(fillnames[i],"smooth_")) +
      ggplot2::coord_sf(datum=NA) +
      ggplot2::theme_minimal() +
      ggplot2::theme_bw()

  }
  print(ggpubr::ggarrange(plotlist = plot_list, legend = "none", ncol = 3, nrow = round(length(plot_list)/3 +0.3)))
}
