#' Generates quick map of specified contiguities
#'
#' @param cont A neighbourhood list of class "nb"
#' @param data A simple features dataframe
#' @param unit The level (e.g. region, county) at which the neighbourhood structure operates
#'
#' @return A map for visualising and checking of contiguities
#' @export
#'
#' @examples
quickmap_contigs <- function(cont, data, unit){
  # to show the contiguities on a map

  data1 <- data %>% dplyr::group_by({{ unit }}) %>% dplyr::summarise()

  # first, the dataframe must be a spdf, spatial dataframe
  df_sp <- sf::as_Spatial(data1)

  if(is.matrix(cont)){
    temp <- spdep::mat2listw(cont, style="B")
    cont <- temp[2]
    cont <- cont$neighbours
    class(cont) <- "nb"
  }

  # make lines where there are contiguities
  neighbors_sf <- as(spdep::nb2lines(cont, coords = df_sp), 'sf')
  neighbors_sf <- sf::st_set_crs(neighbors_sf, sf::st_crs(data))

  # get the endpoints of these lines (they are not necessarily the centroids...)
  endpoints_coords <- sf::st_coordinates(neighbors_sf) |> data.frame() |>
    sf::st_as_sf(coords=c("X","Y"), crs=sf::st_crs(neighbors_sf))

  # map the connections
  plot <- ggplot2::ggplot() +
    ggplot2::geom_sf(data=data1, fill="lightgoldenrodyellow", colour="gray70", linewidth=0.5) +
    ggplot2::geom_sf(data=endpoints_coords, size=0.5) +
    ggplot2::geom_sf(data = neighbors_sf, colour="darkred", linewidth=0.08) +
    ggplot2::guides(colour = "none") +
    ggplot2::coord_sf(datum=NA) +
    ggplot2::theme_minimal() +
    ggplot2::theme_bw() +
    ggplot2::theme(axis.title.x = ggplot2::element_blank()) +
    ggplot2::theme(axis.title.y = ggplot2::element_blank())

  print(plot)
}
