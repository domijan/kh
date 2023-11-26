makemap <- function(cont, data, unit){
  # to show the contiguities on a map
  unit1 <- deparse(substitute(unit))

  data1 <- data %>% dplyr::group_by(.data[[unit1]]) %>% dplyr::summarise()


  # first, the dataframe must be a spdf, spatial dataframe
  df_sp <- sf::as_Spatial(data1)

  # make lines where there are contiguities
  neighbors_sf <- as(spdep::nb2lines(cont, coords = df_sp), 'sf')
  neighbors_sf <- sf::st_set_crs(neighbors_sf, sf::st_crs(data))

  # get the endpoints of these lines (they are not necessarily the centroids...)
  endpoints_coords <- sf::st_coordinates(neighbors_sf) |> data.frame() |>
    sf::st_as_sf(coords=c("X","Y"), crs=sf::st_crs(neighbors_sf))

  # map the connections
  plot <- ggplot2::ggplot() +
    ggplot2::geom_sf(data=data1, fill="lightgoldenrodyellow", colour="gray70", linewidth=0.5) +
    ggplot2::geom_sf(data=endpoints_coords) +
    ggplot2::geom_sf(data = neighbors_sf, colour="darkred", linewidth=0.08) +
    ggplot2::guides(colour = "none") +
    ggplot2::coord_sf(datum=NA) +
    ggplot2::theme_minimal() +
    ggplot2::theme_bw() +
    ggplot2::theme(axis.title.x = ggplot2::element_blank()) +
    ggplot2::theme(axis.title.y = ggplot2::element_blank())

  print(plot)
}
