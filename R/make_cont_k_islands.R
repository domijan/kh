make_cont_k_islands <- function(data, # sf dataframe
                                unit, # neighbour areal unit
                                link_islands_k = 0) # link island to k nearest units, 0 removes all islands
{

  unit1 <- deparse(substitute(unit))

  data1 <- data |> dplyr::group_by(unit1) |> dplyr::summarise()

  # link_islands_k

  if (link_islands_k > 0)
  {
    # unconnected units
    cont <-  data1 |>
      sf::st_intersects()
    still_unconnected <- lengths(lapply(cont, function(lst) lst))
    unconnected <- which(still_unconnected == 1)
    # Calculate distances
    distdf <- data.frame(
      constnumb = 0,
      ndist = 0
    )
    for (i in 1:length(unconnected))
    {
      distances <- sf::st_distance(data1$geometry[unconnected[i]], sf::st_geometry(data1$geometry)) |>
        as.numeric() |> sort()
      distdf[i,2] <- round(distances[link_islands_k+1]) +100
      distdf[i,1] <- unconnected[i]
    }
    bufs <- rep(0,nrow(data1))
    for (i in 1:length(unconnected))
    {
      bufs[distdf[i,1]] <- distdf[i,2]
    }

    cont <- data1 |>
      sf::st_buffer(dist=bufs) |>
      sf::st_intersects() |>
      purrr::imap(~setdiff(.x,.y))

    names(cont) <- data1 |> dplyr::pull(unit1)
    class(cont) <- "nb"

    return(cont)

  }

  # otherwise, just return unaltered contiguity structure
  if(link_islands_k <= 0)
  {
    cont <- data1 |>
      sf::st_intersects() |>
      purrr::imap(~setdiff(.x,.y))

    names(cont) <- data1 |> dplyr::pull(unit1)
    class(cont) <- "nb"
  }

}
