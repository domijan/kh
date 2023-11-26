manual_unlink_numeric <- function(cont,x,y)
{
  class(cont) <- "list"

  x <- as.integer(x)
  y <- as.integer(y)

  if(x %in% cont[[y]])
  {
    cont[[x]] <- cont[[x]][cont[[x]] !=y] |>
      sort()
    cont[[y]] <- cont[[y]][cont[[y]] !=x] |>
      sort()

    class(cont) <- "nb"

    return(cont)
  }
  else
  {
    class(cont) <- "nb"

    return(cont)
  }
}
