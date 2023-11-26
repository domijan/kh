manual_unlink_name <- function(cont,x,y)
{
  class(cont) <- "list"

  xnum <- which(names(cont)==x) |>
    as.integer()
  ynum <- which(names(cont)==y) |>
    as.integer()

  if(xnum %in% cont[[ynum]])
  {
    cont[[xnum]] <- cont[[xnum]][cont[[xnum]] !=ynum] |>
      sort()
    cont[[ynum]] <- cont[[ynum]][cont[[ynum]] !=xnum] |>
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
