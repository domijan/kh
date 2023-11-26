#' Find the names of the neighbouring constituencies of a unit
#'
#' @param cont A neighbourhood list of class "nb"
#' @param x The name of a unit
#'
#' @return A vector containing the names of its neighbours
#' @export
#'
#' @examples
find_neighbours <- function(cont,x)
{
  integer <- which(names(cont) == x) |>
    as.integer()

  nb_nums <- cont[[integer]]

  return(names(cont)[nb_nums])

}
