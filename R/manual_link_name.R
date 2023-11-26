manual_link_name <- function(cont,x,y)
{
  class(cont) <- "list"

  xnum <- which(names(cont)==x) |>
    as.integer()
  ynum <- which(names(cont)==y) |>
    as.integer()

  if(xnum %in% cont[[ynum]])
  {
    class(cont) <- "nb"

    return(cont)
  }
  else
  {
  cont[[xnum]] <- c(cont[[xnum]],ynum) |>
    sort()
  cont[[ynum]] <- c(cont[[ynum]],xnum) |>
    sort()

  class(cont) <- "nb"

  return(cont)
  }
}
