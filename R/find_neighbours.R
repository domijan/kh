find_neighbours <- function(cont,x)
{
  integer <- which(names(cont) == x) |>
    as.integer()

  nb_nums <- cont[[integer]]

  return(names(cont)[nb_nums])

}
