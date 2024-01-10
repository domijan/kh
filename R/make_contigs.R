#' Title
#'
#' @param data A simple features dataframe
#' @param unit The level (e.g. region, county) at which the neighbourhood structure operates
#' @param link_islands_k An integer value. The closest k units to isolated units will be represented as neighbours
#' @param modelling.package either "mgcv" (default) or "brms"
#'
#' @return A neighbourhood list of class "nb" for "mgcv" or a neighbourhood matrix for "brms"
#' @export
#'
#' @examples
make_contigs <- function(data, # sf dataframe
                         unit, # neighbour areal unit
                         link_islands_k = 0, # link island to k nearest units, 0 removes all islands
                         modelling.package = "mgcv")
{

  data1 <- data %>% dplyr::group_by(across({{ unit }})) %>% dplyr::summarise()

  # link_islands_k

  if (link_islands_k > 0)
  {
    # unconnected units
    cont <-  data1 %>%
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
      distances <- sf::st_distance(data1$geometry[unconnected[i]], sf::st_geometry(data1$geometry)) %>%
        as.numeric() %>% sort()
      distdf[i,2] <- round(distances[link_islands_k+1]) +100
      distdf[i,1] <- unconnected[i]
    }
    bufs <- rep(0,nrow(data1))
    for (i in 1:length(unconnected))
    {
      bufs[distdf[i,1]] <- distdf[i,2]
    }

    cont <- data1 %>%
      sf::st_buffer(dist=bufs) %>%
      sf::st_intersects() %>%
      purrr::imap(~setdiff(.x,.y))

    names(cont) <- data1 %>% dplyr::pull(unit1)
    class(cont) <- "nb"
  }

  # otherwise, just return unaltered contiguity structure
  if(link_islands_k <= 0)
  {
    cont <- data1 %>%
      sf::st_intersects() %>%
      purrr::imap(~setdiff(.x,.y))

    names(cont) <- data1 %>% dplyr::pull(unit1)
    class(cont) <- "nb"
  }

  if(modelling.package == "mgcv"){
    return(cont)
  }
  if(modelling.package =="brms"){
    cont2 <-spdep::nb2mat(cont)
    cont2[cont2!=0] <- 1
    rownames(cont2) <- names(cont)
    # colnames(cont2) <- names(cont)
    return(cont2)
  }

}
